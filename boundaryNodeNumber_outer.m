%%% 八领域边界追踪算法
% 通过节点的八个领域位置对边界节点进行查找
% 返回边界节点的编号

function [bnode_idx,dir_set,empty_set] = boundaryNodeNumber_outer(node_xy)

node_x = node_xy(1,:);
node_y = node_xy(2,:);

pixel = unique(node_x);
spacing = pixel(2) - pixel(1);%得到像素点间距


%%%找到八领域追踪算法起始点
% startPtX = node_x(1);%起始点X
% startPtY = node_y(1);%起始点Y
startPtX = 344;%起始点X
startPtY = 235;%起始点Y
bnode_idx = find(node_x==startPtX&node_y==startPtY, 1);%起始点编号

%%%八领域追踪算法
d = spacing;%方向码移动距离
dir = [d,0;d,-d;
       0,-d;-d,-d;
       -d,0;-d,d;
       0,d;d,d];%定义8个方向码

dirNum = 1;%定义起始方向码（左）

dir_set = [];
empty_set = [];

while(true)
    
    
    searchPtX = startPtX + dir(dirNum,1);%搜索点X
    searchPtY = startPtY + dir(dirNum,2);%搜索点Y
    
    searchIdx = find(node_x==searchPtX&node_y==searchPtY, 1);
    %%% 判断搜索点是否为边界点
    if(~isempty(searchIdx))
        %先判断是否已经找完了所有边界点
        if(searchIdx == bnode_idx(1))
            

            %%% 判断最后一点是否为角点/拐点
            count = 0;
            for i=1:8

                X = startPtX + dir(i,1);%搜索点X
                Y = startPtY + dir(i,2);%搜索点Y

                Idx = find(node_x==X&node_y==Y, 1);
                if(isempty(Idx))

                   count = count + 1; 

                end
            end

            empty_set = [empty_set count];
            
            break
            
        else
            %%%判断是不是重复点
            %若不是则记录，若是则不记录
            if(~ismember(searchIdx,bnode_idx))
         
                bnode_idx = [bnode_idx searchIdx];%存储边界点
                
                dir_set = [dir_set dirNum];

% %                 figure('Name','边界像素节点')
%                 hold on
%                 plot(node_xy(1,bnode_idx),node_xy(2,bnode_idx),'or','MarkerFaceColor','red');
% %                 plot(node_xy(1,:),node_xy(2,:),'ob');
%                 axis tight
%                 hold off

    
                %%% 判断凸包角点/拐点
                count = 0;
                for i=1:8

                    X = startPtX + dir(i,1);%搜索点X
                    Y = startPtY + dir(i,2);%搜索点Y

                    Idx = find(node_x==X&node_y==Y, 1);
                    if(isempty(Idx))

                       count = count + 1; 
                       
                    end
                end
                
                empty_set = [empty_set count];
                
                
            end
            
            startPtX = searchPtX;
            startPtY = searchPtY;%将搜索点定为下次搜索的起始点

            if(dirNum==8)
                dirNum = 2;
            elseif(dirNum==7)
                dirNum = 1;
            else
                dirNum = dirNum + 2;%搜索到原始点后，将搜索方向逆时针旋转90°
            end
            
        end

    else
        
        if(dirNum==1)
            dirNum = 8;%搜索到右边时dirNum=1，为了保证继续搜索，要令dirNum=8
        else
            dirNum = dirNum - 1;
        end
    end

end

% %%%调试代码(显示边界节点)
% figure('Name','边界像素节点')
% hold on
% plot(node_xy(1,bnode_idx),node_xy(2,bnode_idx),'or','MarkerFaceColor','red');
% % plot(node_xy(1,:),node_xy(2,:),'ob');
% axis tight
% hold off
