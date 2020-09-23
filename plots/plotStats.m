
function plotStats(index, means, tfrs, ylabelstr, ylimrange)
sr = 22050;

f = figure(index);
set(f, 'Position', [10 10 750 1000])

hold on
set(gca, 'XScale', 'log');

for i=1:size(means,3)
    semilogx(tfrs(:, i), means(1, :, i),'LineWidth',6)
end

xlabel('\lambda','FontSize',32)
set(gca, 'XTick', [1e-2,1,1e2,1e4])
legend({'red = 32','red = 16', 'red = 8', 'red = 4', 'red = 2'},'Location','northeast','FontSize',24)
set(gca,'Fontsize',32);
ylabel(ylabelstr,'FontSize',32)
ylim(ylimrange)
box on
hold off

end