f_signal = 0.5*pi;
f_noise = 0.3;

N = 50000;
n = (0:N-1)';
s = cos(2*pi*f_signal*n);
w = 1000*cos(2*pi*f_noise*n);

x = s+w;

y = zeros(N,1);
a = zeros(N, 1);

r = 0.95;
mu = 0.0000000002;

for k=10:N-1
    y(k) = x(k) + a(k)*x(k-1) + x(k-2) - r*a(k)*y(k-1)-r*r*y(k-2);
    a(k+1) = a(k)- mu*y(k)*x(k-1);
    
    if abs(a(k+1)) >= 2
        a(k+1) = 0;
    end 
end

a_converged = a(N); % The value of a we should use since algorithm converges
b = [1 a_converged 1];
a_coeff = [1 r*a_converged r*r];
[h,w] = freqz(b, a_coeff, 'whole', 2001);
figure(1)
h=fftshift(h);
w=w-pi;
plot(w/pi, 20*log10(abs(h)))

figure(2)
stem(n(N-100:N), y(N-100:N))
title('y')
figure(3)
plot(n, a)
title('a')