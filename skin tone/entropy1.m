% This function computes the entropy of input matrix, a, which contents decimal
% numbers, according to SHANNON formula.

% entropy = - sum(Pi*log2(Pi)) where Pi is the probability for each element in a.

function e = entropy1(a)
[m,n] = size(a);
% reshape input matrix as a row vector
a = reshape(a,1,m*n);
n = length(a);
b = sort(a);
%define probability matrix
c = zeros(1,n);
% initialize probability matrix members
p = 1;
i = 0;
r=2;
% count the nr. of occurrences
while (i <= n-1 )
count = 1;
i = i +1;
while (i <= n-1 && b(i) == b( i+1) )
count = count + 1;
i = i +1;
end
c(p) = count;
p = p +1;
end
for i = 1:n
c(i) = c(i) / n;
end;
% calculate entropy according to Shannon's formula
entropy = 0;
for i = 1:n
if [c(i) ~= 0]
entropy = entropy - c(i)* r * log2(c(i));
end
end
e = entropy;