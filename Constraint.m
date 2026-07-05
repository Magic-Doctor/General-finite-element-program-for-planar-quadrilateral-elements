%%% 边界约束
% 四边形单元的节点仅有x和y两个方向的自由度
% 函数返回节点位移向量

function d = Constraint(node_xy,dnode_idx,cnode_idx,dir)

[rcnode_idx,rnode_num] = nodeTransfer(node_xy,dnode_idx,cnode_idx,1); %转移节点

d = ones(2*rnode_num,1); %节点位移

if(dir == 0)

    d(2*rcnode_idx-1) = 0; %约束x方向
    
elseif(dir == 1)

    d(2*rcnode_idx) = 0; %约束y方向
    
elseif(dir == 2)
    
    d(2*rcnode_idx-1) = 0; 
    d(2*rcnode_idx) = 0; %约束xy方向
    
end

%%% 存储约束节点的坐标
% node_xy(:,dnode_idx) = [];
% cnode_xy = node_xy(:,rcnode_idx);
% save('cnode_xy.mat','cnode_xy')

%%% 调试代码（显示约束节点）
% figure('Name','约束节点')
% hold on
% plot(node_xy(1,:),node_xy(2,:),'o')
% plot(node_xy(1,dnode_idx),node_xy(2,dnode_idx),'ob','MarkerFacecolor','blue')
% node_xy(:,dnode_idx) = [];
% plot(node_xy(1,rcnode_idx),node_xy(2,rcnode_idx),'or','MarkerFaceColor','red')
% axis tight
% hold off
% 



