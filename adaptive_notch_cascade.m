function adaptive_notch_cascade()
% Calibrate initial values to specify attributes of adaptive filters
r1 = 0.95;
r2 = 0.95;
mu1 = 1E-4;
mu2 = 1E-4;
N = 50000;

% Initialize signal arrays for use in algorithm 
e1 = zeros(1,N);
e2 = zeros(1,N);
y1 = zeros(1,N);
y2 = zeros(1,N);
a1 = zeros(1,N);
a2 = zeros(1,N);
w = 2*pi/N:2*pi/N:2*pi;
z1 = exp(1i*w);
z2 = exp(1i*w);

n = 1:N;
desired = cos(1.7*pi*n);     % Clean signal 
noise1 = 10*sin(0.7*pi*n);   % First strong interference 
noise2 = 10*sin(0.3*pi*n);   % Second strong interference               
x = desired+noise1+noise2;   % Combined input signal

for i = 3:N-1
    % Update first adaptive filter coefficient
    e1(i) = x(i)+a1(i)*x(i-1)+x(i-2);
    y1(i) = e1(i)-r1*a1(i)*y1(i-1)-r1^2*y1(i-2);
    if ((a1(i)>=-2)&&(a1(i)<2)) 
        a1(i+1) = a1(i)-mu1*y1(i)*x1(i-1);
    else 
        a1(i+1) = 0;
    end 
    
    % Update second adaptive filter coefficient
    e2(i) = y1(i)+a2(i)*y1(i-1)+y1(i-2);
    y2(i) = e2(i)-r2*a2(i)*y2(i-1)-r2^2*y2(i-2);
    if ((a2(i)>=-2)&&(a2(i)<2)) 
        a2(i+1) = a2(i)-mu2*y2(i)*x1(i-1);
    else 
        a1(i+1) = 0;
    end 
end

end

