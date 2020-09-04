
function plotStats(index, means, M, tfrs, titlestr, ylabelstr, ylimrange)
sr = 22050;

figure(index);

%First
ax1 = subplot(121);
hold on
set(gca, 'XScale', 'log');
for i=1:size(means,3)
    semilogx(M, means(1, :, i),'LineWidth',4)
end

% 
% semilogx(1024, means(1, find(M==1024), 1), '+','LineWidth',3, 'Color','black','MarkerSize',20)
% semilogx(1024, means(1, find(M==1024), 2), '+','LineWidth',3, 'Color','black','MarkerSize',20)
% semilogx(512, means(1, find(M==512), 3), '+','LineWidth',3, 'Color','black','MarkerSize',20)
% 
% if size(means, 3) > 4
%     semilogx(512, means(1, find(M==512), 4), '+','LineWidth',3, 'Color','black','MarkerSize',20)
%     semilogx(256, means(1, find(M==256), 5), '+','LineWidth',3, 'Color','black','MarkerSize',20)
% end
xlabel('M','FontSize',24)
ylabel(ylabelstr,'FontSize',24)
set(gca, 'XTick', [1e2, 1e3, 1e4, 1e5])

%legend({'red = 32','red = 16', 'red = 8', 'red = 4', 'red = 2'},'Location','southeast','FontSize',24)
set(gca,'Fontsize',24);

ylim(ylimrange)

ax1_pos = get(ax1,'Position');

%Second
ax2 = subplot(122);

hold on
set(gca, 'XScale', 'log');

for i=1:size(means,3)
    semilogx(tfrs(:, i), means(1, :, i),'LineWidth',4)
end

% semilogx(M(find(M==1024))^2/(sr*32), means(1, find(M==1024), 1), '+','LineWidth',3, 'Color','black','MarkerSize',20)
% semilogx(M(find(M==1024))^2/(sr*16), means(1, find(M==1024), 2), '+','LineWidth',3, 'Color','black','MarkerSize',20)
% semilogx(M(find(M==512))^2/(sr*8), means(1, find(M==512), 3), '+','LineWidth',3, 'Color','black','MarkerSize',20)
% 
% if size(means, 3) > 4
%     semilogx(M(find(M==512))^2/(sr*4), means(1, find(M==512), 4), '+','LineWidth',3, 'Color','black','MarkerSize',20)
%     semilogx(M(find(M==256))^2/(sr*2), means(1, find(M==256), 5), '+','LineWidth',3, 'Color','black','MarkerSize',20)
% end


xlabel('\lambda','FontSize',24)
%ylabel('PEAQ','FontSize',24)
set(gca, 'XTick', [1e-2,1,1e2,1e4])
set(gca,'YTickLabel',[]);
legend({'red = 32','red = 16', 'red = 8', 'red = 4', 'red = 2'},'Location','southeast','FontSize',24)
set(gca,'Fontsize',24);
ylim(ylimrange)

hold off

subplot(121);
sgtitle(titlestr,'FontSize',24);

end