function showCornerScale(corrner)
%SHOWSCALE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
plot(corrner(:,1),corrner(:,2),'*g','MarkerSize',8);
for i=1:length(corrner)
    rectangle('Position',[corrner(i,1)-corrner(i,3),corrner(i,2)-corrner(i,3),2*corrner(i,3),2*corrner(i,3)],...
              'Curvature',[1,1],...
              'EdgeColor',[0.3 0.3 1],...
              'LineWidth',1);
end
end

