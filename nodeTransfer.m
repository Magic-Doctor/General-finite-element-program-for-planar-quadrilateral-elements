%%% 节点转移
% 若有无网格节点,删除后,约束和载荷节点编号需要更改
% 若没有无网格节点,约束和载荷节点编号直接返回
% 节点转移通过识别

function [rlcnode_idx,rnode_num] = nodeTransfer(node_xy,dnode_idx,lcnode_idx,type)


%%% 找到端节点间的所有约束节点
if(type==1)
    
    bnode_idx1 = boundaryNodeNumber(node_xy);
    index1 = find(bnode_idx1==lcnode_idx(1));
    index2 = find(bnode_idx1==lcnode_idx(2));

    if(index1 < index2 || index1 == index2)

        lcnode_idx = bnode_idx1(index1:index2);
    else

        lcnode_idx = [bnode_idx1(index1:end) bnode_idx1(1:index2)];
    end
end

%%% 判断是否需要进行节点转移
if(~isempty(dnode_idx))

    lcnode_xy = node_xy(:,lcnode_idx);
    node_xy(:,dnode_idx) = []; % 删除无网格节点

    bnode_idx2 = boundaryNodeNumber(node_xy); % 识别包含转移节点的边界节点
    bnode_xy2 = node_xy(:,bnode_idx2);

    %%% 匹配节点和转移节点
    for i = 1:size(lcnode_xy,2)

        delta_x = bnode_xy2(1,:)-lcnode_xy(1,i);
        delta_y = bnode_xy2(2,:)-lcnode_xy(2,i);
        [~,idx] = min(sqrt(delta_x.^2 + delta_y.^2)); % 根据坐标距离来进行匹配
        
        lcnode_idx(i) = bnode_idx2(idx); % 节点编号转移
    end

end

if(type==1)
    rlcnode_idx = unique(lcnode_idx);
elseif(type==2)
    rlcnode_idx = lcnode_idx;
end

rnode_num = size(node_xy,2);
