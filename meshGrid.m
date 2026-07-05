%%% 划分四边形网格
% 利用像素点的三个领域生成四边形网格
% 三个领域分别为正右、右上和正上

function [eleInfo,dnode_idx] =  meshGrid(node_xy)


nodeNum = size(node_xy,2);
eleInfo = zeros(nodeNum,4); % 单元信息(预分配内存)
dnode_idx = []; % 删除节点编号集合

pixel = unique(node_xy(1,:));
spacing = pixel(2) - pixel(1); % 像素节点间距

dir = [spacing,0;
       spacing,spacing;
       0,spacing]; % 三领域方向码

eleNum = 1; % 记录单元个数


% for node1_idx = 1:nodeNum
    
%     node1_x = node_xy(1,node1_idx);
%     node1_y = node_xy(2,node1_idx);
%     
%     for dirNum = 1:3
%         
%         searchPtx = node1_x + dir(dirNum,1);
%         searchPty = node1_y + dir(dirNum,2);
%         
%         if(dirNum==1)
%             node2_idx = find(node_xy(1,:)==searchPtx&node_xy(2,:)==searchPty);
%         elseif(dirNum==2)
%             node3_idx = find(node_xy(1,:)==searchPtx&node_xy(2,:)==searchPty);
%         else
%             node4_idx = find(node_xy(1,:)==searchPtx&node_xy(2,:)==searchPty);
%         end
%     end
%     
%     if(~isempty(node2_idx) && ~isempty(node3_idx) && ~isempty(node4_idx))
%     
%         eleInfo(eleNum,:) = [node1_idx node2_idx node3_idx node4_idx];
%         
%         eleNum = eleNum + 1;
%     else
%         
%         if(~ismember(node1_idx,eleInfo))
%             dnode_idx = [dnode_idx node1_idx];
%         end
%     end
% end

for node1_idx = 1:nodeNum
    
%     disp(node1_idx)
    node1_x = node_xy(1,node1_idx);
    node1_y = node_xy(2,node1_idx);

    node2_x = node1_x + dir(1,1);
    node2_y = node1_y + dir(1,2); % 正右节点
    node3_x = node1_x + dir(2,1);
    node3_y = node1_y + dir(2,2); % 右上节点
    node4_x = node1_x + dir(3,1);
    node4_y = node1_y + dir(3,2); % 正上节点
     
    node2_idx = find(node_xy(1,:)==node2_x&node_xy(2,:)==node2_y); % 正右节点编号


    % 三个领域都有值代表node1能够划分四边形网格
    % node1编号: node1_idx
    % node2编号: node2_idx
    % node3编号: node2_idx+1
    % node4编号: node1_idx+1
    % 异常处理：处理索引超出数组或者空索引的情况，这些情况代表节点已经不能生成新网格
    % 只需要判断其是否为无网格节点
    try

        if(~isempty(node2_idx) && node_xy(1,node2_idx+1)==node3_x ...
           && node_xy(2,node2_idx+1)==node3_y && node_xy(1,node1_idx+1)==node4_x ...
           && node_xy(2,node1_idx+1)==node4_y)

             eleInfo(eleNum,1:4) = [node1_idx node2_idx ...
                                               node2_idx+1 node1_idx+1];
             eleNum = eleNum + 1;

        % 否则认为node1不能划分四边形网格
        else
            % 先判断node1是否已经被划分在前面的四边形网格中
            % 若已划分的四边形网格均没有包含node1,则认为node1是无网格节点
            if(~ismember(node1_idx,eleInfo))

                dnode_idx = [dnode_idx node1_idx]; % 记录需要删除节点的编号

            end
        end
        
    catch
            if(~ismember(node1_idx,eleInfo))

                dnode_idx = [dnode_idx node1_idx]; % 记录需要删除节点的编号

            end
    end
        

end

eleInfo(eleNum:nodeNum,:) = []; % 删除预分配的多余空间


% 如果存在无网格节点，将其删除并修正单元信息中的节点编号
if(~isempty(dnode_idx))
    
    for dNum = length(dnode_idx):-1:1
        
        eleInfo(eleInfo>dnode_idx(dNum)) = ...
                            eleInfo(eleInfo>dnode_idx(dNum)) - 1;
    end
    
end

% 存储无网格节点的坐标
% dnode_xy = node_xy(:,dnode_idx);
% save('dnode_xy.mat','dnode_xy')


%%% 调试代码(显示网格面)
% figure('Name','网格划分')
% node_xy(:,dnode_idx) = [];
% for i = 1:size(eleInfo,1)
%     grid_idx = eleInfo(i,:);
%     grid_xy = node_xy(:,grid_idx); 
%     patch(grid_xy(1,:),grid_xy(2,:),[0 1 1],'EdgeColor',[1 1 1],'LineWidth',0.1)
% end
% axis tight


%%% 调试代码(显示网格线)
% figure('Name','网格划分')
% node_xy(:,dnode_idx) = [];
% hold on
% for i = 1:size(eleInfo,1)
%     grid_idx = eleInfo(i,:);
%     grid_xy = node_xy(:,grid_idx); 
%     plot([grid_xy(1,:),grid_xy(1,1)],[grid_xy(2,:),grid_xy(2,1)],'red',...
%         grid_xy(1,:),grid_xy(2,:),'or','MarkerFaceColor','red');
% end
% hold off
% axis tight
% axis off

%%% 调试代码(显示无网格像素节点)
% figure('Name','无网格像素节点')
% hold on
% plot(node_xy(1,:),node_xy(2,:),'o')
% plot(node_xy(1,dnode_idx),node_xy(2,dnode_idx),'ob','MarkerFacecolor','blue')
% hold off

