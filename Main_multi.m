clc
clear

tic
%————————节点坐标————————
% load check
% load test1
load DISP_Brwg_1
% load test2
node_xy = x1;

%————————问题类型————————
% 1为平面应力问题，2为平面应变问题
S = 1; 

%————————物理参数———————— 
DPP = 60/930; % 单位像素距离所对应的真实距离
E = 2.3e3;  % 弹性模量
T = 6;  % 模型厚度
PR = 0.35;  % 泊松比


%————————划分单元————————
tic
[eleInfo,dnode_idx] = meshGrid(node_xy);
disp("网格划分时间")
toc



%————————施加约束————————
% 定义约束始节点和末节点，给这两点及其之间的节点施加约束
% cnode_idx填写的第一个节点编号为约束始节点编号
% cnode_idx: [cnode1_idx cnode2_idx]
% 约束从始节点开始按照x-y方向走向末节点
% const_dir: 约束方向,0约束x 1约束y 2约束xy
cnode1_xy = [743 77];
cnode2_xy = [1723 77];
cnode_idx = [find(node_xy(1,:)==cnode1_xy(1)&node_xy(2,:)==cnode1_xy(2)) ...
             find(node_xy(1,:)==cnode2_xy(1)&node_xy(2,:)==cnode2_xy(2))];

const_dir = 2;
d = Constraint(node_xy,dnode_idx,cnode_idx,const_dir);

[ix,iy,K] = assemRectangle(node_xy,dnode_idx,eleInfo,d,DPP,E,PR,T,S); %总体刚度


x1(:,dnode_idx) = [];
x = x1;

%---------------------------------------------------------------------------
snode_xy = [1718,82];
enode_xy = [748,82];


snode_idx = find(node_xy(1,:)==snode_xy(1)&node_xy(2,:)==snode_xy(2));
enode_idx = find(node_xy(1,:)==enode_xy(1)&node_xy(2,:)==enode_xy(2));

lcnode_idx = [snode_idx enode_idx];

bnode_idx1 = boundaryNodeNumber(node_xy);
index1 = find(bnode_idx1==lcnode_idx(1));
index2 = find(bnode_idx1==lcnode_idx(2));

if(index1 < index2 || index1 == index2)

    lcnode_idx = bnode_idx1(index1:index2);
else

    lcnode_idx = [bnode_idx1(index1:end) bnode_idx1(1:index2)];
end


% % 
% figure('Name','循环载荷节点')
% hold on
% plot(node_xy(1,:),node_xy(2,:),'o')
% plot(node_xy(1,lcnode_idx),node_xy(2,lcnode_idx),'or')
% hold off


%---------------------------------------------------------------------------

for bnode = 1:length(lcnode_idx)
    %————————施加载荷————————
    % 定义载荷始节点和末节点，给这两点及其之间的节点施加约束
    % lnode_idx: [lnode1_idx lnode2_idx]
    % 载荷默认从始节点开始按照逆时针方向进行
    % 也可自选节点输入载荷
    % load_x: x总载荷  load_y: y总载荷
    % lnode_idx = [find(node_xy(1,:)==1818&node_xy(2,:)==402) ...
    %              find(node_xy(1,:)==1818&node_xy(2,:)==402)];
    % lnode_idx = [60 50];
    lnode_idx = [lcnode_idx(bnode) lcnode_idx(bnode)];
    for idx = 1:2

        if(idx==1)
            load_x = 1;
            load_y = 0;
        else
            load_x = 0;
            load_y = 1;
        end


        F = Load(node_xy,dnode_idx,lnode_idx,load_x,load_y);
    
        %—————————求解——————————
%         [ix,iy,K] = assemRectangle(node_xy,dnode_idx,eleInfo,d,DPP,E,PR,T,S); %总体刚度

        d = sparse(iy,ix,K,length(d),length(d))\F; %节点位移
        
%         ————————位移场绘制—————————
        Disp_Cloud_Plot(node_xy,dnode_idx,d,bnode,idx)
        
        u = dispTransfer(d);

        if(idx==1)
            save(strcat('C:\Users\Admin\Desktop\Blade_root_wheel_groove1\x\',string(bnode),'.mat')...
                ,'x','u')
        else
            save(strcat('C:\Users\Admin\Desktop\Blade_root_wheel_groove1\y\',string(bnode),'.mat')...
                ,'x','u')
        end
    end
%     
    close all
end

disp("计算总时长：")
toc