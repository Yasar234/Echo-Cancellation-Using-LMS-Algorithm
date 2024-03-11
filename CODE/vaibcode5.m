clear all;
clf;
close all;

%acoustic channel frequency response
num = [1 0 0 0.5 0 .1];
den = [1 0 0  0 0 0];
[Hc,Wc] = freqz(num,den);

%---BUILD FM SWEEP---%
fs = 2*pi;
tmax = 10000;

f1=0;
f2 = .5;
tsweep = 0:499;
slope = (f2-f1)/1000;
F = slope.*(mod(tsweep,500));

t = 0:1:tmax;
fm = cos(2*pi*slope*t);


F = slope.*(mod(tsweep,500));
fm2 = cos(2*pi*(F).*tsweep);
fm2c = repmat(fm2,20,1);
fm2 = reshape(fm2c',1,10000 );

figure
plot([0:999],fm2(2001:3000))
%subplot(212)
%plot([-512:511]*1/(2*pi), 20*log10(abs(fft(fm2(1:500), 1024))))
grid on
%End building of FM sweep

trainlen = tmax;

%vaaibhav's integration starts here

[Fname1,Pname1] = uigetfile('*.wav','Select 1st FIle'); 


[z1,Fs1] = audioread(strcat(Pname1,Fname1));

z1 = norm(z1);
z1 = round(z1);
zlength = length(z1);
%training signal
r_t = 1*rand(1,z1);

%desired signal
s_t = 0;

%signal through channel
rt_ht = filter(num,den,r_t);

%signal through channel + desired
mic_in = s_t + rt_ht;

%LMS algorithm of echo canceller
reg1=zeros(1,50);
wts = (zeros(1,50));
mu  = .07;
for n = 1:zlength
 
  wts_sv = wts;
 
  reg1 = [r_t(n) reg1(1:49)];
 
  err = mic_in(n) - reg1*(wts');
 
  y(n) = err;
 
  wts = wts + mu*(reg1*(err'));
   
end

%plots
figure
subplot(211)
plot(1:length(y), (y))
hold on
plot(1:10000, zeros(1,10000), 'color', 'r', 'linewidth', 2, 'MarkerSize', 2)
hold off
axis([ -.5 10000 -1 1.1])
grid on
title('Steady State (time response) Desired Signal = 0, trained with white noise')
subplot(212)
plot(1:length(y), 20*log10(abs(y)))
grid on
title('Log Magnitude Training Curve, trained with white noise')



[Hf,Wf] = freqz(wts_sv);
figure
subplot(211)
plot(Wc/pi, 20*log10(abs(Hc)))
grid on
title('Frequency Response of Channel')
subplot(212)
plot(Wf/pi, 20*log10(abs(Hf)),'color','r')
title('Frequency Response of Adaptive Canceller, trained with white noise')
grid on

