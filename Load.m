%%% 施加载荷
% 函数返回载荷向量

function F = Load(node_xy,dnode_idx,lnode_idx,load_x,load_y)


if(length(lnode_idx)==2&&length(load_x)==1&&length(load_y)==1)
   
    [rlnode_idx,rnode_num] = nodeTransfer(node_xy,dnode_idx,lnode_idx,1); 
    F = zeros(2*rnode_num,1); %节点载荷
    num = length(rlnode_idx);

    F(2*rlnode_idx-1) = load_x/num; % 施加x均布载荷
    F(2*rlnode_idx) = load_y/num; % 施加y均布载荷
    

else
    
    [rlnode_idx,rnode_num] = nodeTransfer(node_xy,dnode_idx,lnode_idx,2); 
    F = zeros(2*rnode_num,1);
    
    %%% 节点载荷处理
    while(~isempty(rlnode_idx))
        
        idx = find(rlnode_idx==rlnode_idx(1));
        
        % 没有出现重复转移节点
        if(length(idx)==1)
            F(2*rlnode_idx(idx)-1) = load_x(idx);
            F(2*rlnode_idx(idx)) = load_y(idx);
        
        % 出现重复转移节点,叠加其载荷
        else
       
            F(2*rlnode_idx(idx(1))-1) = sum(load_x(idx));
            F(2*rlnode_idx(idx(1))) = sum(load_y(idx));

        end
        
        load_x(idx) = [];
        load_y(idx) = [];
        rlnode_idx(idx) = []; % 删除已存储的节点载荷
    end
            
end


%%% 调试代码（显示载荷节点）
% figure('Name','载荷节点')
% hold on
% plot(node_xy(1,:),node_xy(2,:),'o')
% plot(node_xy(1,dnode_idx),node_xy(2,dnode_idx),'ob','MarkerFacecolor','blue')
% node_xy(:,dnode_idx) = [];
% plot(node_xy(1,rlnode_idx),node_xy(2,rlnode_idx),'or','MarkerFaceColor','red')
% axis tight
% hold off
