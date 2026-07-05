function u = dispTransfer(d)

nodeNum = length(d)/2;
u = zeros(3,nodeNum);

for i = 1:nodeNum
    
    u(1,i) = d(2*i-1); % xÎ»ÒÆ
    u(2,i) = d(2*i); % yÎ»ÒÆ
    u(3,i) = sqrt(d(2*i-1)^2+d(2*i)^2);
end