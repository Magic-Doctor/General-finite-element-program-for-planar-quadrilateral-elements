%%% 绘制位移场云图
% 任意形状的封闭区域均适用

function Disp_Cloud_Plot(node_xy,dnode_idx,d,bnode,idx)


node_xy(:,dnode_idx) = [];
x1 = node_xy(1,:) - node_xy(1,1);
y1 = node_xy(2,:) - min(node_xy(2,:));

x = unique(x1);
y = unique(y1);
spacing = x(2) - x(1); % 像素采样间距
xNum = length(x);
yNum = length(y);
[mesh_x,mesh_y] = meshgrid(x,y);

disp_x = NaN*zeros(yNum,xNum); 
disp_y = NaN*zeros(yNum,xNum);
disp_xy = NaN*zeros(yNum,xNum);

node_num = size(node_xy,2);

%%% 位移向量写入矩阵
for i = 1:node_num
    
    pos_x = x1(i)/spacing + 1;
    pos_y = y1(i)/spacing + 1;
    disp_x(pos_y,pos_x) = d(2*i-1); % x位移
    disp_y(pos_y,pos_x) = d(2*i); % y位移
    disp_xy(pos_y,pos_x) = sqrt(d(2*i-1)^2 + d(2*i)^2); % 总位移
    
end

figure('Name','位移场结果')
set(gcf,'position',[150 100 1400 600])
subplot(1,3,1,'position',[0.1,0.3,0.25,0.4])
surf(mesh_x,mesh_y,disp_x)
% set(gca,'xtick',[],'ytick',[])
title("x\_displacement")
colormap jet
shading interp 
% shading flat
% shading faceted
view(0,-90)
axis tight
axis off
colorbar

subplot(1,3,2,'position',[0.4,0.3,0.25,0.4])
surf(mesh_x,mesh_y,disp_y)
% set(gca,'xtick',[],'ytick',[])
title("y\_displacement")
colormap jet
shading interp 
% shading flat
% shading faceted
view(0,-90)
axis tight
axis off
colorbar

subplot(1,3,3,'position',[0.7,0.3,0.25,0.4])
surf(mesh_x,mesh_y,disp_xy)
% set(gca,'xtick',[],'ytick',[])
title("total\_displacement")
colormap jet
shading interp
% shading flat
% shading faceted
view(0,-90)
axis tight
axis off
colorbar


% if(idx==1)
%     saveas(gcf, strcat('C:\Users\Admin\Desktop\Blade_root_wheel_groove1\x_f\',string(bnode),'.jpg')); %保存当前窗口的图像
% else
%     saveas(gcf, strcat('C:\Users\Admin\Desktop\Blade_root_wheel_groove1\y_f\',string(bnode),'.jpg')); %保存当前窗口的图像
% end
% 


