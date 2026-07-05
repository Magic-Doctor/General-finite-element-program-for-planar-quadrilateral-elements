%%% 标记一维向量存储位置与二维坐标的关系
% 元胞数组记录每个节点在一维向量的起始位置以及小于该节点编号的其他节点
% 左上，正左，左下，正下四个位置的节点编号均小于中心节点

function markInfo = markAlgorithm(node_xy)


nodeNum = size(node_xy,2);
markInfo = cell(nodeNum+1,2);
address = zeros(1,nodeNum+1); % 最后一列记录的是一维向量的总存储大小

pixel = unique(node_xy(1,:));

spacing = pixel(2) - pixel(1); 

dir = [0 spacing;
       -spacing spacing;
       -spacing 0;
       -spacing -spacing;
       0 -spacing]; % 方向码
   

% tic
   
for node1_idx = 1:nodeNum
    
    node1_x = node_xy(1,node1_idx);
    node1_y = node_xy(2,node1_idx);
    
    node2_xy = [node1_x+dir(1,1) node1_y+dir(1,2)]; % 正上节点
    node3_xy = [node1_x+dir(2,1) node1_y+dir(2,2)]; % 左上节点
    node4_xy = [node1_x+dir(3,1) node1_y+dir(3,2)]; % 正左节点
    node5_xy = [node1_x+dir(4,1) node1_y+dir(4,2)]; % 左下节点
    node6_xy = [node1_x+dir(5,1) node1_y+dir(5,2)]; % 正下节点
    
    node2_idx = find(node_xy(1,:)==node4_xy(1)&node_xy(2,:)==node4_xy(2),1);
    
    % 左上节点编号: node2_idx+1
    % 正左节点编号: node2_idx
    % 左下节点编号: node2_idx-1
    % 正下节点编号: node1_idx-1
    % 正上节点编号: node1_idx+1
    
    ndx = [];
    
    if(~isempty(node2_idx))
        
        ndx = [ndx node2_idx];
        
        try
            if(node_xy(1,node2_idx+1)==node3_xy(1)&&node_xy(2,node2_idx+1)==node3_xy(2) ...
               && node_xy(1,node1_idx+1)==node2_xy(1) && node_xy(2,node1_idx+1)==node2_xy(2))

                ndx = [ndx node2_idx+1]; % 记录左上节点

            end

            if(node_xy(1,node2_idx-1)==node5_xy(1)&&node_xy(2,node2_idx-1)==node5_xy(2) ...
               && node_xy(1,node1_idx-1)==node6_xy(1) && node_xy(2,node1_idx-1)==node6_xy(2))

                ndx = [ndx node2_idx-1 node1_idx-1]; % 记录左下和正下节点

            elseif(node_xy(1,node1_idx-1)==node6_xy(1) && node_xy(2,node1_idx-1)==node6_xy(2))

                ndx = [ndx node1_idx-1]; % 记录正下节点

            end
            
        catch
            
            if(node2_idx == 1)
                
                if(node_xy(1,node1_idx-1)==node6_xy(1) && node_xy(2,node1_idx-1)==node6_xy(2))
                    
                     ndx = [ndx node1_idx-1]; % 记录正下节点
                end
            
            elseif(node1_idx == nodeNum)
                
                if(node_xy(1,node2_idx-1)==node5_xy(1)&&node_xy(2,node2_idx-1)==node5_xy(2) ...
               && node_xy(1,node1_idx-1)==node6_xy(1) && node_xy(2,node1_idx-1)==node6_xy(2))

                   ndx = [ndx node2_idx-1 node1_idx-1]; % 记录左下和正下节点

                elseif(node_xy(1,node1_idx-1)==node6_xy(1) && node_xy(2,node1_idx-1)==node6_xy(2))

                   ndx = [ndx node1_idx-1]; % 记录正下节点
                   
                end

            else
                    
               continue
               
            end
            
        end
        
    else
        
        % 异常处理：1号节点下方没有节点（6号节点），那么node1_idx-1会造成异常
        try
            
            if(node_xy(1,node1_idx-1)==node6_xy(1)&&node_xy(2,node1_idx-1)==node6_xy(2))
                    
                ndx = [ndx node1_idx-1];
                
            end
        
        % 只有1号节点才进catch
        catch
            
            address(node1_idx+1) = address(node1_idx) + length(ndx) * 4 + 1;
            markInfo(node1_idx,:) = {address(node1_idx),ndx}; 
            
            continue
        end
    end
    
%     ndx = [ndx i]; % 记录该节点的编号
    
    ndx = sort(ndx); % 对编号排序
   
    markInfo(node1_idx,:) = {address(node1_idx),ndx}; 
    
    address(node1_idx+1) = address(node1_idx) + length(ndx) * 4 + 1;
    
end

markInfo(node1_idx+1,1) = {address(node1_idx+1)} ;

% disp("图号时长")
% toc

% 
% tic
% 
% for i =1:nodeNum
%     
%     q=[];
%     for j =1:size(eleInfo,1)
%         
%         a = eleInfo(j,:);
%         if(ismember(i,a))
%             b = a(i>a|i==a);
%             q =[q b];
%             if(length(unique(q))==5)
%                 break;
%             end
%         end
%     end
%     u = unique(q);
%     u(i==u) = [];
%     
%     address(i+1) = address(i) + length(u) * 4 + 1;
%     
%     markInfo(i,:) = {address(i),u}; 
%     
% end
% disp("循环时长")
% toc



