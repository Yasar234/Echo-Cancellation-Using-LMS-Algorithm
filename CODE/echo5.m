clc;
clear all;
%warning off;
close all;
 
% Input signals 
ss=audioread('clean\sp12.wav');
subplot 411;
plot(ss);
title('Input Signal')
n=audioread('echoed signal\sp12.wav');
subplot 412;
plot(n);% subplot (1,2,2), disp (n);
title('echoed Signal')
v=audioread('clean\sp11.wav');
subplot 413;
plot(v);
title('Clean Signal')
disp('INPUT signal');
fprintf('%d',ss);
disp('ECHO signal');
fprintf('%d',n);
for ar = 1:1:length(ss);
ss1(ar) = n(ar)-ss(ar);
disp('ERROR SIGNAL');
%fprintf('%d',ss1);
end
for i=1:1:20115
    a(i)=v(i)+ss1(i);
    s(i)=ss1(i);
end
%wavwrite(a,'C:\Users\OM\Desktop\d')
subplot 414;
plot(a);
title('Plot a')
% plot(a);
%Initialization
 N=20115;
 %Hpsd=dspdata.psd(N);
p=1024;
 mu=0.001;
w=zeros(p,1);
x=zeros(N,1);
d=zeros(N,1);
figure;
  plot(s);
  title('Plot s')
%Algorithm
for i=p:N
    xvec=n(i:-1:i-p+1);
    y(i)=w'*xvec;
    e(i)=a(i)-y(i);
    w=w+mu*e(i)*xvec;
end

% plot((s'-e));
% xlabel('time index'); 
% ylabel('signal value');
%title('Calcualated MSE')%Calculating MSE
for i=1:N
     err(i)=(s(i)-e(i)).^2;
     nn(i)=n(i).^2;
     err(i)=(s(i)-e(i));
      nn(i)=n(i);
     ss(i)=s(i);
end
MSE=mean(err);
 plot(err);
 title('Plot Err')
 % Calculating SNR INPUT
 SNR=snr(e,(ss-e));
 rms_signal=sqrt(mean(a.^2));
  rms_echo=sqrt(mean((s-a).^2));
  Lsig=10*log10(rms_signal);
  Lech=10*log10(rms_echo);
  ERLEo=Lsig-Lech;
  fprintf(ERLEo);

%  
% Calculating SNR OUTPUT
 SNR=snr(e,(ss-e));
 rms_signal=sqrt(mean(e.^2));
  rms_echo=sqrt(mean((s-e).^2));
  Lsig=10*log10(rms_signal);
  Lech=10*log10(rms_echo);
  ERLEi=Lsig-Lech;
  fprintf(ERLEi);