%%% 四边形单元刚度矩阵

function k=rectangleElementStiffness(E,miu,h,node_ele,S)

% syms t s;       %定义自然坐标

%---------节点坐标---------
x1=node_ele(1,1);                
y1=node_ele(2,1);
x2=node_ele(1,2);                
y2=node_ele(2,2);
x3=node_ele(1,3);                
y3=node_ele(2,3);
x4=node_ele(1,4);                
y4=node_ele(2,4);

%---------形函数---------
% N1=((1-s)*(1-t))/4;
% N2=((1+s)*(1-t))/4;
% N3=((1+s)*(1+t))/4;
% N4=((1-s)*(1+t))/4;

%---------雅克比因子---------

% xc=[x1 x2 x3 x4];
% yc=[y1 y2 y3 y4];
% J_m=[0 1-t t-s s-1;
%      t-1 0 s+1 -s-t;
%      s-t -s-1 0 t+1;
%      1-s s+t -t-1 0];
% J=xc*J_m*yc'/8;


%---------弹性矩阵---------
if S==1
    D=E/(1-miu^2)*[1 miu 0;
                   miu 1 0;
                   0 0 (1-miu)/2];           %平面应力问题
elseif S==2
    D=E/(1+miu)/(1-2*miu)*[1-miu miu 0;
                           miu 1-miu 0;
                       0 0 (1-2*miu)/2];     %平面应变问题
end

%---------高斯积分---------
% 采用4个高斯积分点

% weight = [1 1 1 1]; % 权重
coor = 1/sqrt(3);
gip_s = [-coor coor coor -coor];
gip_t = [-coor -coor coor coor];
k = zeros(8,8); %单刚


for i = 1:4

    J = ((y1*(x2-x3)+y2*(x4-x1)+y3*(x1-x4)+y4*(x3-x2))*gip_t(i) + ...
        (y1*(x3-x4)+y2*(x4-x3)+y3*(x2-x1)+y4*(x1-x2))*gip_s(i) + ...
        (y1*(x4-x2)+y2*(x1-x3)+y3*(x2-x4)+y4*(x3-x1)))/8;

%---------梯度函数---------
% a=(y1*(s-1)+y2*(-1-s)+y3*(1+s)+y4*(1-s))/4;
% b=(y1*(t-1)+y2*(1-t)+y3*(1+t)+y4*(-1-t))/4;
% c=(x1*(t-1)+x2*(1-t)+x3*(1+t)+x4*(-1-t))/4;
% d=(x1*(s-1)+x2*(-1-s)+x3*(1+s)+x4*(1-s))/4;
% N1s=(t-1)/4;
% N1t=(s-1)/4;
% N2s=(1-t)/4;
% N2t=-(1+s)/4;
% N3s=(1+t)/4;
% N3t=(1+s)/4;
% N4s=-(1+t)/4;
% N4t=(1-s)/4;
% B1=[a*N1s-b*N1t 0;
%     0 c*N1t-d*N1s;
%     c*N1t-d*N1s a*N1s-b*N1t];
% B2=[a*N2s-b*N2t 0;
%     0 c*N2t-d*N2s;
%     c*N2t-d*N2s a*N2s-b*N2t];
% B3=[a*N3s-b*N3t 0;
%     0 c*N3t-d*N3s;
%     c*N3t-d*N3s a*N3s-b*N3t];
% B4=[a*N4s-b*N4t 0;
%     0 c*N4t-d*N4s;
%     c*N4t-d*N4s a*N4s-b*N4t];

    B1 = [((y3-y2)*gip_t(i)+(y4-y3)*gip_s(i)+y2-y4)/8 0;
           0 ((x2-x3)*gip_t(i)+(x3-x4)*gip_s(i)+x4-x2)/8;
           ((x2-x3)*gip_t(i)+(x3-x4)*gip_s(i)+x4-x2)/8 ((y3-y2)*gip_t(i)+(y4-y3)*gip_s(i)+y2-y4)/8];

    B2 = [((y3-y4)*gip_s(i)+(y1-y4)*gip_t(i)+y3-y1)/8 0;
           0 ((x4-x3)*gip_s(i)+(x4-x1)*gip_t(i)+x1-x3)/8;
           ((x4-x3)*gip_s(i)+(x4-x1)*gip_t(i)+x1-x3)/8 ((y3-y4)*gip_s(i)+(y1-y4)*gip_t(i)+y3-y1)/8];

    B3 = [((y1-y2)*gip_s(i)+(y4-y1)*gip_t(i)+y4-y2)/8 0;
           0 ((x2-x1)*gip_s(i)+(x1-x4)*gip_t(i)+x2-x4)/8;
           ((x2-x1)*gip_s(i)+(x1-x4)*gip_t(i)+x2-x4)/8 ((y1-y2)*gip_s(i)+(y4-y1)*gip_t(i)+y4-y2)/8];

    B4 = [((y2-y1)*gip_s(i)+(y2-y3)*gip_t(i)+y1-y3)/8 0;
          0 ((x1-x2)*gip_s(i)+(x3-x2)*gip_t(i)+x3-x1)/8;
          ((x1-x2)*gip_s(i)+(x3-x2)*gip_t(i)+x3-x1)/8 ((y2-y1)*gip_s(i)+(y2-y3)*gip_t(i)+y1-y3)/8];

    B=[B1 B2 B3 B4]/J;

    BD=B'*D*B*J;
    
    k = k + BD;

end

k=double(h*k);    %单刚

