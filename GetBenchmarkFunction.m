function [fobj, l, u, g, d]=GetBenchmarkFunction(number)
dim=30;
switch number
    
    case 'F1'
        % F1- Sphere lower=[-100], upper=[100], gminimum=[0]
        fobj = @F1;
        l=[-100];
        u=[100];
        g=0;
        d=dim;
        
    case 'F2'
        % F2- SumSquares lower=[-10], upper=[10], gminimum=[0]
        fobj = @F2;
        l=[-10];
        u=[10];
        g=0;
        d=dim;
        
    case 'F3'
        % F3- Schwefel 2.22 lower=[-100], upper=[100], gminimum=[0]
        fobj = @F3;
        l=[-100];
        u=[100];
        g=0;
        d=dim;
        
    case 'F4'
        % F4- Rastrigin  lower=[-5.12], upper=[5.12] gminimum=[0]
        fobj = @F4;
        l=[-5.12];
        u=[5.12];
        g=0;
        d=dim;
        
    case 'F5'
        % F5- Alpine  lower=[0], upper=[10] gminimum=[0]
        fobj = @F5;
        l=[0];
        u=[10];
        g=[0];
        d=dim;
        
    case 'F6'
        % F6- Griewank  lower=[-600], upper=[600] gminimum=[0]
        fobj = @F6;
        l=[-600];
        u=[600];
        g=[0];
        d=dim;
end

end

function z = F1(x)
% F1- Sphere lower=[-100], upper=[100], gminimum=[0]
z=sum(x'.^2)';
end

function z = F2(x)
% F2- SumSquares lower=[-10], upper=[10], gminimum=[0]
[m, n] = size(x);
x2 = x .^2;
I = repmat(1:n, m, 1);
z = sum( I .* x2, 2);
end

function z = F3(x)
% F3- Schwefel 2.22 lower=[-100], upper=[100], gminimum=[0]
absx = abs(x);
z = sum(absx, 2) + prod(absx, 2);
end

function z = F4(x)
% F4- Rastrigin  lower=[-5.12], upper=[5.12] gminimum=[0]
n = size(x, 2);
A = 10;
z = (A * n) + (sum(x .^2 - A * cos(2 * pi .* x), 2));
end

function z = F5(x)
% F5- Alpine 1  lower=[0], upper=[10] gminimum=[0]
z = sum(abs(x .* sin(x) + 0.1 * x), 2);
end

function z = F6(x)
% F6- Griewank  lower=[-600], upper=[600] gminimum=[0]
n = size(x, 2);
sumcomp = 0;
prodcomp = 1;
for i = 1:n
    sumcomp = sumcomp + (x(:, i) .^ 2);
    prodcomp = prodcomp .* (cos(x(:, i) / sqrt(i)));
end
z = (sumcomp / 4000) - prodcomp + 1;
end