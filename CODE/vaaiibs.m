clear all  
close all  
u0 = 0.03 ; 
[Fname1,Pname1] = uigetfile('*.wav','Select 1st FIle'); 
[Fname2,Pname2] = uigetfile('*.wav','Select 2nd FIle');
[Fname3,Pname3] = uigetfile('*.wav','Select 3rd FIle');

[z1,Fs1] = audioread(strcat(Pname1,Fname1));
[z2,Fs2] = audioread(strcat(Pname2,Fname2));                                       %noise 
 [z3,Fs3] = audioread (strcat(Pname3,Fname3));                                   %noisy signal       
    Nx(1,:) = size(z2) ; 
    N = 4 ; 
    u = u0/(N*(z2'*z2)/Nx(1,1)) ; 
    %z2 = z2 + 0.2; 
    yhat  = zeros(1,Nx(1,1)); 
    %h=[0.9957; 0.0271 ; -0.0191 ; 0.0289 ; -0.0137 ; 0.0075 ; 0.0133 ; -0.0137 ; 0.0207 ; -0.0050]; 
  
    h     = zeros(N,1); 
    signal= zeros(1,Nx(1,1));   
    for k=1:N 
        X(k)=z2(k,:); 
    end 
    for count= 1:Nx(1,:)-0 ; 
        for n = N:-1:2 
            X(n)=X(n-1); 
        end 
        X(1) = z2(count) ; 
        yhat =  X*h ; 
        signal(count)= z3(count+0) - yhat; 
        h = h+ 2*u*signal(count)*X' ; 
    end 
    figure(2) 
    subplot(2,2,1);plot((h)) 
    xlabel('z1') 
    subplot(2,2,2);plot(z3) 
    xlabel('z3') 
    axis([0 22500 -1 1]) 
    subplot(2,2,4);plot(signal)                           
    xlabel('error') 
    axis([0 22500 -1 1]) 
    subplot(2,2,3);plot(z2) 
    xlabel('z2') 
    axis([0 22500 -1 1]) 
soundsc(z3,Fs1)                                                             %this is mixture of the two first signals    
pause(3.5) 
soundsc(signal,Fs1)                                                       %this signal is filtered and tries to retrieve the first signal   
pause(3.5) 