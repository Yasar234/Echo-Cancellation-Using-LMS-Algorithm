
clc;
clear all;
close all;
% M = 4001;
% fs = 8000;
% [B,A] = cheby2(4,20,[0.1 0.7]);
% Hd = dfilt.df2t([zeros(1,6) B],A);
% hFVT = fvtool(Hd);  % Analyze the filter
% set(hFVT, 'Color', [1 1 1])
% H = filter(Hd,log(0.99*rand(1,M)+0.01).* ...
%     sign(randn(1,M)).*exp(-0.002*(1:M)));
% H = H/norm(H)*4;    % Room Impulse Response
% plot(0:1/fs:0.5,H);
% xlabel('Time [sec]');
% ylabel('Amplitude');
% title('Room Impulse Response');
% set(gcf, 'Color', [1 1 1])
[fname ,pname] = uigetfile('*wav','select clean wave file');
wavefile = strcat(pname, fname);
v=audioread(wavefile);

% n = 1:length(v);
% t = n/fs;
plot(v);
% axis([0 33.5 -1 1]);
xlabel('Time [sec]');
ylabel('Amplitude');
title('Near-End Speech Signal');
% set(gcf, 'Color', [1 1 1])
% p8 = audioplayer(v,fs);
% playblocking(p8);
[fname1 ,pname1] = uigetfile('*wav','select echo wave file');
wavefile1 = strcat(pname1, fname1);

x=audioread(wavefile1);
x = x(1:length(x));
%dhat = filter(H,1,x);
figure
plot(x);
% axis([0 33.5 -1 1]);
xlabel('Time [sec]');
ylabel('Amplitude');
title('Far-End Echoed Speech Signal');
% set(gcf, 'Color', [1 1 1])
% % p8 = audioplayer(dhat,fs);
% % playblocking(p8);
% for i=1:21119
%     x(i)=x(i);
d = x+v;
% end
figure
plot(d);
% axis([0 33.5 -1 1]);
xlabel('Time [sec]');
ylabel('Amplitude');
title('Microphone Signal');
% set(gcf, 'Color', [1 1 1])
% % p8 = audioplayer(d,fs);
% % playblocking(p8);
p=32;
mu = 0.0001;
w = zeros(1,p);
ha = adaptfilt.lms(p,mu);
[y,e] = filter(ha,x,d);
figure
plot(e);

rms_signal=sqrt(mean(e.^2));
  rms_echo=sqrt(mean((x-e).^2));
%   Lsig=-10*log10(rms_signal);
%   Lech=-10*log10(rms_echo);
ERLE=rms_signal-rms_echo
%  ERLE=Lsig-Lech
erledB = -10*log10(ERLE)
% n = 1:length(e);
% t = n/fs;
% pos = get(gcf,'Position');
% set(gcf,'Position',[pos(1), pos(2)-100,pos(3),(pos(4)+85)])
% subplot(3,1,1);
% plot(t,v(n),'g');
% axis([0 33.5 -1 1]);
% ylabel('Amplitude');
% title('Near-End Speech Signal');
% subplot(3,1,2);
% plot(t,d(n),'b');
% axis([0 33.5 -1 1]);
% ylabel('Amplitude');
% title('Microphone Signal');
% subplot(3,1,3);
% plot(t,e(n),'r');
% axis([0 33.5 -1 1]);
% xlabel('Time [sec]');
% ylabel('Amplitude');
% title('Output of Acoustic Echo Canceller');
% set(gcf, 'Color', [1 1 1])
% % p8 = audioplayer(e/max(abs(e)),fs);
% % playblocking(p8);
% Hd2 = dfilt.dffir(ones(1,1000));
% setfilter(hFVT,Hd2);
% erle = filter(Hd2,(e-v(1:length(e))).^2)./ ...
%     (filter(Hd2,dhat(1:length(e)).^2));
% erledB = -10*log10(erle);
% plot(t,erledB);
% axis([0 33.5 0 40]);
% xlabel('Time [sec]');
% ylabel('ERLE [dB]');
% title('Echo Return Loss Enhancement');
% set(gcf, 'Color', [1 1 1])