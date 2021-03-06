function blind_equalization()
% Initialization of constants
L = 4;
M = 20;
N = 1000000;
mu = 1E-3;
SNR = 25;
w = linspace(-pi,pi,N);

% Initialization of all relevant signals
s = randi([0,1],1,N)*2-1;
h = [0.3,1,0.7,0.3,0.2];
x = zeros(1,N); y = zeros(1,N); e = zeros(1,N); a = zeros(M+1,N);

% Determine output sequence x[n] for input into FIR adaptive equalizer
for n = 1:N
    channel_output = 0;
    for m = 1:L+1
        if (n-m+1 > 0)
            channel_output = channel_output + s(n-m+1)*h(m);
        end
    end
    x(n) = channel_output;
end 
x = awgn(x,SNR);

% Determine output sequence y[n] for output of FIR adaptive equalizer
for n = 3:N-1
    equalizer_output = 0;
    for m = 1:M+1
        if (n-m > 0)
            equalizer_output = equalizer_output + x(n-m)*a(m,n);
        end
    end
    y(n) = equalizer_output;
    e(n) = (abs(y(n))^2-1)*y(n);
    a(:,n+1) = a(:,n)-mu*e(n)*x(n);
end

% Frequency Responses
H_channel = fftshift(fft(h,N));
H_equalizer = fftshift(fft(a(:,end),N));

figure(1)
plot(1:N,y)

% figure(2)
% plot(w,abs(H_equalizer));
end
