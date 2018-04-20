function adaptive_notch()
% Calibrate initial values to specify attributes of adaptive filter
r = 0.95;
mu = 1E-4;
N = 50000;

% Initialize signal arrays for use in algorithm
e = zeros(1,N);
y = zeros(1,N);
a = zeros(1,N);
w = 2*pi/N:2*pi/N:2*pi;
z = exp(1i*w);

n = 1:N;
desired = cos(1.7*pi*n);    % Clean signal
noise = 10*sin(0.7*pi*n);   % Strong interference
x = desired+noise;

for i = 3:N-1
    e(i) = x(i)+a(i)*x(i-1)+x(i-2);
    y(i) = e(i)-r*a(i)*y(i-1)-r^2*y(i-2);
    if ((a(i)>=-2)&&(a(i)<2))
        a(i+1) = a(i)-mu*y(i)*x(i-1);
    else
        a(i+1) = 0;
    end
end
% Frequency Responses
H_desired = fftshift(fft(desired,N));
H_noise = fftshift(fft(noise,N));
H_input = fftshift(fft(x,N));
H_output = fftshift(fft(y,N));
H_adaptive = (1+a(end)*z.^(-1)+z.^(-2))./(1+r*a(end)*z.^(-1)+r^2*z.^(-2));


% Plot of Desired Signal
figure(1)
plot(w,abs(H_desired),'LineWidth',1)
xlabel('w')
ylabel('H_{desired}')
xlim([0,2*pi])

% Plot of Noisy Signal
figure(2)
plot(w,abs(H_noise),'LineWidth',1)
xlabel('w')
ylabel('H_{noise}')
xlim([0,2*pi])

% % Plot of Input Signal
% % figure(3)
% % plot(w,abs(H_input),'LineWidth',1)
% % xlabel('w')
% % ylabel('H_{input}')
% % xlim([0,2*pi])

% Plot of Output Signal
figure(3)
plot(w,abs(H_output),'LineWidth',1)
xlabel('w')
ylabel('H_{output}')
xlim([0,2*pi])

% Plot of Adaptive Filter
figure(4)
plot(w,abs(H_adaptive),'LineWidth',1)
xlabel('w')
ylabel('H_{adaptive}')
axis([0,2*pi,0,1.2])
end
