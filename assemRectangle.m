%%% 组集总体刚度矩阵
% 对于大型对称稀疏的总体刚度矩阵进行压缩存储
% 将总体刚度矩阵下三角的非零元素及其坐标用一维向量存储（三元组法）
% 采用标记算法对一维向量的存储顺序进行排序

function [ix,iy,K] = assemRectangle(node_xy,dnode_idx,eleInfo,d,DPP,E,PR,T,S)


node_xy(:,dnode_idx) = [];
markInfo = markAlgorithm(node_xy); % 获得标记

cdof_idx = find(d==0);
vectNum = markInfo{end,1}; % 一维向量大小
diagNum = 2*size(node_xy,2);
eleNum = size(eleInfo,1); 

%%% 创建三元组
ix = zeros(1,vectNum); % 记录总刚中下三角非零元素的列坐标 (预分配内存)
iy = zeros(1,vectNum); % 记录总刚中下三角非零元素的行坐标 (预分配内存)
K = zeros(1,vectNum); % 记录总刚非零元素的值 (预分配内存)
 
ixx = zeros(1,diagNum); % 记录总刚主对角元的列坐标 (预分配内存)
iyy = zeros(1,diagNum); % 记录总刚主对角元的行坐标 (预分配内存)
KK = zeros(1,diagNum); % 记录主对角元的值 (预分配内存)

node_xy(1,:) = (node_xy(1,:) - node_xy(1,1)) * DPP;
node_xy(2,:) = (node_xy(2,:) - node_xy(2,1)) * DPP; % 真实物理世界坐标


for num = 1:eleNum
    
     disp(num)
%     tic
    node_idx = eleInfo(num,:);
    k = rectangleElementStiffness(E,PR,T,node_xy(:,node_idx),S); % 单刚

    
    %%% 约束处理
    [~,ia,~] = intersect(2*node_idx-1,cdof_idx,'stable'); % 单刚中约束自由度的编号
    [~,ib,~] = intersect(2*node_idx,cdof_idx,'stable'); % 单刚中约束自由度的编号
    k(2*ia-1,1:end) = 0;
    k(1:end,2*ia-1) = 0; % 单刚约束自由度的行列置0（主对角元先按0处理）
    k(2*ib,1:end) = 0;
    k(1:end,2*ib) = 0; % 单刚约束自由度的行列置0（主对角元先按0处理）
%     disp("单刚计算")
%     toc
    
%     tic
    %%% 存储总体刚度阵的下三角元素
    % 只记录单刚中行节点编号大于或等于列节点编号的方块矩阵元素
    for m = 1:4
        
        for n = 1:4

            if(node_idx(m)>node_idx(n) || node_idx(m)==node_idx(n))
                
                % 记录单刚中的方块矩阵
                block_matrix = zeros(3,4);

                block_matrix(1,:) = [2*node_idx(n)-1 2*node_idx(n) ...
                                    2*node_idx(n)-1 2*node_idx(n)];
                block_matrix(2,:) = [2*node_idx(m)-1 2*node_idx(m)-1 ...
                                    2*node_idx(m) 2*node_idx(m)];
                block_matrix(3,:) = [k(2*m-1,2*n-1) k(2*m-1,2*n) ...
                                    k(2*m,2*n-1) k(2*m,2*n)];
                                
                if(node_idx(m)>node_idx(n))
                                
                    firmark = markInfo{node_idx(m),1}; % 第一标记点
                    
                    secmark = 4*(find(markInfo{node_idx(m),2}==node_idx(n))-1); % 第二标记点
                    
                    
                    % 单刚组集
                    for t = 1:4
                        
                        ix(firmark+secmark+t) = block_matrix(1,t);
                        
                        iy(firmark+secmark+t) = block_matrix(2,t);
                                                    
                        K(firmark+secmark+t) =  K(firmark+secmark+t) + ...
                                                        block_matrix(3,t);
                        
                    end
  
                elseif(node_idx(m)==node_idx(n))
                     
                    % 单刚组集
                    for t = [1 3 4]
                        
                        firmark = markInfo{node_idx(m),1}; % 第一标记点
                    
                        secmark = 4*length(markInfo{node_idx(m),2}); % 第二标记点
                        % 单独存储主对角元素
                        if(t==1 || t==4)

                            ixx(block_matrix(1,t)) = block_matrix(1,t);
                            iyy(block_matrix(2,t)) = block_matrix(2,t);
                            KK(block_matrix(2,t)) = KK(block_matrix(2,t)) + ...
                                                    block_matrix(3,t);

                        else
                            
                            disp(firmark+secmark+1)
                            ix(firmark+secmark+1) = block_matrix(1,t);
                            iy(firmark+secmark+1) = block_matrix(2,t);
                            K(firmark+secmark+1) = K(firmark+secmark+1) + ...
                                                    block_matrix(3,t);

                        end
                    end
                end
                
            end
        end
    end
%     disp("单刚组集时长")
%     toc
end


s_tool = ix;
ix = [ix iy];
iy = [iy s_tool]; % 扩充得到上三角元素坐标
K = [K K]; % 扩充得到上三角元素值

KK(cdof_idx) = 1; % 约束自由度的主对角元置1

ix = [ix ixx];
iy = [iy iyy]; 
K = [K KK]; % 扩充得到主对角元素值

    