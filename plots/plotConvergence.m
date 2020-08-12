
function plotConvergence(index, means, red, titlestr, ylabelstr, ylimrange)
sr = 22050;

figure(index);

%First
hold on
for i=1:size(means,3)
    plot(10:100/size(means, 2):100, means(1, :, i),'LineWidth',4)
end

xlabel('iterations','FontSize',24)
ylabel(ylabelstr,'FontSize',24)
set(gca, 'XTick', [1e1, 5e1, 1e2])
%legend({'red = 32','red = 16', 'red = 8', 'red = 4', 'red = 2'},'Location','southeast','FontSize',24)
set(gca,'Fontsize',24);

ylim(ylimrange)

sgtitle(titlestr,'FontSize',24);

end