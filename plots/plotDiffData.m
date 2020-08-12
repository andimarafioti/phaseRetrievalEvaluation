function plotDiffData(index, means, M, tfrs, titlestr, ylabelstr, ylimrange)
sr = 22050;

figure(index);

hold on
set(gca, 'XScale', 'log');

for i=1:size(means,1)
    semilogx(tfrs(:), means(i, :),'LineWidth',4)
end

ylim(ylimrange)
xlabel('a*M/sr','FontSize',24)
ylabel(ylabelstr,'FontSize',24)
set(gca, 'XTick', [1e-2,1,1e2,1e4])
legend({'midi','speech', 'electronic', 'rock'},'Location','southeast','FontSize',24)
set(gca,'Fontsize',24);

hold off

sgtitle(titlestr,'FontSize',24);

end