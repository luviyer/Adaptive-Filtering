% Adaptive notch
clear; clc;

% Calibrate initial values to specify attributes of adaptive filter 
r = 0.95;
mu = 1E-6;
N = 50000;

% Initialize signal arrays for use in algorithm
e = zeros(1,N);
y = zeros(1,N);
a = zeros(1,N);
w = linspace(-pi, pi, N);
z = exp(1i*w);

n = 1:N;
f_desired = 0.3;
f_noise = 0.4;
desired = cos(2*pi*f_desired*n);    % Clean signal 
noise = 10*cos(2*pi*f_noise*n);   % Strong interference 
x = desired + noise;          % Combined input signal

for i = 3:N-1
    e(i) = x(i)+a(i)*x(i-1)+x(i-2);
    y(i) = e(i)-r*a(i)*y(i-1)-(r^2)*y(i-2);
    if ((a(i)>=-2)&&(a(i)<2)) 
        a(i+1) = a(i)-mu*y(i)*x(i-1);
    else 
        a(i+1) = 0;
    end 
end

% [H_adaptive, w] = freqz([1 a(end) 1], [1 r*a(end) r^2], 'whole', N);
% H_adaptive = fftshift(H_adaptive);

H_adaptive = (1+a(end)*z.^(-1)+z.^(-2))./(1+r*a(end)*z.^(-1)+r^2*z.^(-2));
% H_adaptive = fftshift(H_adaptive)

% Normalize x axis to radial frequency range between -1 and 1, which 
% corresponds to radial frequencies of -pi and pi.  
w = w/pi;  

subplot(2,1,1)
plot(w, 20*log10(abs(H_adaptive)))
title('Adaptive Filter Transfer Function');
xlabel('w (/\pi)'); ylabel('Magnitude (dB)');

subplot(2,1,2)
H_x = fftshift(fft(x(end-1000: end), 1001));
H_y = fftshift(fft(y(end-1000:end), 1001));
w_ = linspace(-pi, pi, 1001)/pi;
plot(w_, abs(H_x));
hold on;
plot(w_, abs(H_y));
xlabel('w (/\pi)'); ylabel('Magnitude');
legend('Input', 'Output');

% Frequency Responses
% H_desired = fftshift(fft(desired,N));
% H_noise = fftshift(fft(noise,N));
% H_input = fftshift(fft(x,N));
% H_output = fftshift(fft(y,N));
% H_adaptive = (1+a(end)*z.^(-1)+z.^(-2))./(1+r*a(end)*z.^(-1)+r^2*z.^(-2))
% 
% 
% % Plot of Desired Signal
% figure(1)
% plot(w,abs(H_desired),'LineWidth',1)
% xlabel('w')
% ylabel('H_{desired}')
% xlim([0,2*pi])
% 
% % Plot of Noisy Signal 
% figure(2) 
% plot(w,abs(H_noise),'LineWidth',1)
% xlabel('w')
% ylabel('H_{noise}')
% xlim([0,2*pi])
% 
% % Plot of Input Signal 
% figure(3)
% plot(w,abs(H_input),'LineWidth',1)
% xlabel('w')
% ylabel('H_{input}')
% xlim([0,2*pi])
% 
% % Plot of Output Signal 
% figure(3)
% plot(w,abs(H_output),'LineWidth',1)
% xlabel('w')
% ylabel('H_{output}')
% xlim([0,2*pi])
% 
% % Plot of Adaptive Filter
% figure(4)
% plot(w,abs(H_adaptive),'LineWidth',1)
% xlabel('w')
% ylabel('H_{adaptive}')
% axis([0,2*pi,0,1.2])
% 



