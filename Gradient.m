load DISP_Brwg_2

node_xy = x1;

[eleInfo,dnode_idx] = meshGrid(node_xy);

snode_xy = [6637,491];
enode_xy = [2957,491];
snode_idx = find(node_xy(1,:)==snode_xy(1)&node_xy(2,:)==snode_xy(2));
enode_idx = find(node_xy(1,:)==enode_xy(1)&node_xy(2,:)==enode_xy(2));

lcnode_idx = [snode_idx enode_idx];

type = 1;

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

rlcnode_idx = lcnode_idx;
lnode_xy = node_xy(:,rlcnode_idx);

% 存储载荷节点的坐标
% save('lnode_xy.mat','lnode_xy')

fitNum = 40; %拟合点数(取偶数)
gapNum = fitNum/2 + 1;
nodeNum = size(lnode_xy,2);
s = []; %斜率

for i = 1:nodeNum

    disp(i)
    if(i>gapNum+1 && i+gapNum<nodeNum)
        
        p = polyfit(lnode_xy(2,i-gapNum:i+gapNum-1),lnode_xy(1,i-gapNum:i+gapNum-1),3);
%     
%         y1 = linspace(lnode_xy(2,i-gapNum),lnode_xy(2,i+gapNum-1),20);
%         x1 = polyval(p,y1);
%         plot(lnode_xy(1,:),lnode_xy(2,:),'ob')
%         hold on
%         plot(x1,y1,'Color','red','LineWidth',3)
%         plot(lnode_xy(1,i),lnode_xy(2,i),'or','MarkerFaceColor','g')
%         hold off
%         saveas(gcf, strcat('C:\Users\Admin\Desktop\Blade_root_wheel_groove1\Slope\',...
%             string(i),'.jpg')); %保存当前窗口的图像
    elseif(i<gapNum+2)
        
        p = polyfit(lnode_xy(2,1:fitNum),lnode_xy(1,1:fitNum),3);
        y1 = linspace(lnode_xy(2,1),lnode_xy(2,fitNum),20);
        x1 = polyval(p,y1);
        plot(lnode_xy(1,:),lnode_xy(2,:),'ob')
        hold on
        plot(x1,y1,'Color','red','LineWidth',3)
        plot(lnode_xy(1,i),lnode_xy(2,i),'or','MarkerFaceColor','g')
        hold off
%         saveas(gcf, strcat('C:\Users\Admin\Desktop\Blade_root_wheel_groove1\Slope\',...
%             string(i),'.jpg')); %保存当前窗口的图像
    else
        
        p = polyfit(lnode_xy(2,nodeNum-fitNum+1:nodeNum),...
            lnode_xy(1,nodeNum-fitNum+1:nodeNum),3);
%         y1 = linspace(lnode_xy(2,nodeNum-fitNum+1),lnode_xy(2,nodeNum),20);
%         x1 = polyval(p,y1);
%         plot(lnode_xy(1,:),lnode_xy(2,:),'ob')
%         hold on
%         plot(x1,y1,'Color','red','LineWidth',3)
%         plot(lnode_xy(1,i),lnode_xy(2,i),'or','MarkerFaceColor','g')
%         hold off
%         saveas(gcf, strcat('C:\Users\Admin\Desktop\Blade_root_wheel_groove1\Slope\',...
%             string(i),'.jpg')); %保存当前窗口的图像
    end
    
%     close all
    s = [s 1/(3*p(1)*lnode_xy(2,i)^2+2*p(2)*lnode_xy(2,i)+p(3))];
    
    
end

save('Gradient_40.mat','s')
