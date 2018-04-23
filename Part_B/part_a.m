clc; clear;
% Initialization of constants
L = 4;
M = 20;
N = 1000;
mu = .01;
SNR = 35;
filter_delay = 5;
w = linspace(-pi,pi,N);

% Initialization of all relevant signals
s = randi([0,1],1,N)*2-1;
h = [0.3,1,0.7,0.3,0.2];
x = zeros(1,N); y = zeros(1,N); error = zeros(1,N);
h_filter = zeros(1, M+1);
% h_filter(M/2)=1;

% Determine output sequence x[n] for input into FIR adaptive equalizer by
% performing the convolution of s and h.
for n = 1:N
    channel_output = 0;
    for m = 1:L+1
        if (n-m >= 1)
            channel_output = channel_output + s(n-m)*h(m);
        end
    end
    x(n) = channel_output;
end

x = awgn(x,SNR);


% Determine output sequence y[n] for output of FIR adaptive equalizer
for n = 40:N
    for m = 1:M+1
            y(n) = y(n) + x(n-m+1)*h_filter(m);
    end
    
    error(n) = s(n-filter_delay) - y(n);
    
    for m=1:M+1
        h_filter(m) = h_filter(m) + mu*error(n)*x(n-m+1);
    end
end


plot(error)


