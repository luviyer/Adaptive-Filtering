f_signal = 0.3;
f_noise = 0.8;

N = 5000;
n = (0:N-1)';
s = cos(2*pi*f_signal*n);
w = 10*cos(2*pi*f_noise*n);

x = s+w;

y = zeros(N,1);
a = zeros(N, 1);

r = 0.95;
mu = 0.0000000002;

for k=10:N-1
    a(k+1) = a(k)- mu*y(k)*x(k-1);
    
    if abs(a(k+1)) > 2
        a(k+1) = 0;
    end

    y(k) = x(k) + a(k)*x(k-1) + x(k-2) - r*a(k)*y(k-1)-r^2*y(k-2);
end

figure(1)
stem(n(500:510), x(500:510))
title('x')

figure(2)
stem(n(500:510), y(500:510))
title('y')
figure(3)
plot(n(500:510), a(500:510))
title('a')