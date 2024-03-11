clc
clear all
close all
addpath('/echo/');
addpath('/clean/');
M = 4001;
fs = 8000;
[B,A] = cheby2(4,20,[0.1 0.7]);
Hd = dfilt.df2t([zeros(1,6) B],A);
hFVT = fvtool(Hd);  % Analyze the filter
set(hFVT, 'Color', [1 1 1])

H = filter(Hd,log(0.99*rand(1,M)+0.01).* ...
    sign(randn(1,M)).*exp(-0.002*(1:M)));
H = H/norm(H)*4;    % Room Impulse Response
plot(0:1/fs:0.5,H);
xlabel('Time [sec]');
ylabel('Amplitude');
title('Room Impulse Response');
set(gcf, 'Color', [1 1 1])

load nearspeech
n = 1:length(v);
t = n/fs;
plot(t,v);
axis([0 33.5 -1 1]);
xlabel('Time [sec]');
ylabel('Amplitude');
title('Near-End Speech Signal');
set(gcf, 'Color', [1 1 1])
p8 = audioplayer(v,fs);
% playblocking(p8);

load farspeech
x = x(1:length(x));
dhat = filter(H,1,x);
plot(t,dhat);
axis([0 33.5 -1 1]);
xlabel('Time [sec]');
ylabel('Amplitude');
title('Far-End Echoed Speech Signal');
set(gcf, 'Color', [1 1 1])
p8 = audioplayer(dhat,fs);
% playblocking(p8);

d = dhat + v+0.001*randn(length(v),1);
plot(t,d);
axis([0 33.5 -1 1]);
xlabel('Time [sec]');
ylabel('Amplitude');
title('Microphone Signal');
set(gcf, 'Color', [1 1 1])
p8 = audioplayer(d,fs);
playblocking(p8);

mu = 0.025;
W0 = zeros(1,2048);
del = 0.01;
lam = 0.98;
x = x(1:length(W0)*floor(length(x)/length(W0)));
d = d(1:length(W0)*floor(length(d)/length(W0)));

% Construct using LMS Adaptive Filter
hFDAF = lms(2048,mu,1,del,lam);
[y,e] = filter(hFDAF,x,d);
n = 1:length(e);
t = n/fs;
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2)-100,pos(3),(pos(4)+85)])
subplot(3,1,1);
plot(t,v(n),'g');
axis([0 33.5 -1 1]);
ylabel('Amplitude');
title('Near-End Speech Signal');
subplot(3,1,2);
plot(t,d(n),'b');
axis([0 33.5 -1 1]);
ylabel('Amplitude');
title('Microphone Signal');
subplot(3,1,3);
plot(t,e(n),'r');
axis([0 33.5 -1 1]);
xlabel('Time [sec]');
ylabel('Amplitude');
title('Output of Acoustic Echo Canceller');
set(gcf, 'Color', [1 1 1])
p8 = audioplayer(e/max(abs(e)),fs);
% playblocking(p8);


Hd2 = dfilt.dffir(ones(1,1000));
setfilter(hFVT,Hd2);


erle = filter(Hd2,(e-v(1:length(e))).^2)./ ...
    (filter(Hd2,dhat(1:length(e)).^2));
erledB = -10*log10(erle);
plot(t,erledB);
axis([0 33.5 0 40]);
xlabel('Time [sec]');
ylabel('ERLE [dB]');
title('Echo Return Loss Enhancement');
set(gcf, 'Color', [1 1 1])

newmu = 0.04;
set(hFDAF,'StepSize',newmu);
[y,e2] = filter(hFDAF,x,d);
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2)-100,pos(3),(pos(4)+85)])
subplot(3,1,1);
plot(t,v(n),'g');
axis([0 33.5 -1 1]);
ylabel('Amplitude');
title('Near-End Speech Signal');
subplot(3,1,2);
plot(t,e(n),'r');
axis([0 33.5 -1 1]);
ylabel('Amplitude');
title('Output of Acoustic Echo Canceller, \mu = 0.025');
subplot(3,1,3);
plot(t,e2(n),'r');
axis([0 33.5 -1 1]);
xlabel('Time [sec]');
ylabel('Amplitude');
title('Output of Acoustic Echo Canceller, \mu = 0.04');
set(gcf, 'Color', [1 1 1])
p8 = audioplayer(e2/max(abs(e2)),fs);
% playblocking(p8);

close;
erle2 = filter(Hd2,(e2-v(1:length(e2))).^2)./...
    (filter(Hd2,dhat(1:length(e2)).^2));
erle2dB = -10*log10(erle2);
plot(t,[erledB erle2dB]);
axis([0 33.5 0 40]);
xlabel('Time [sec]');
ylabel('ERLE [dB]');
title('Echo Return Loss Enhancements');
legend('FDAF, \mu = 0.025','FDAF, \mu = 0.04');
set(gcf, 'Color', [1 1 1])
