function plotNoiseInfluence(index, means, color, M, tfrs, titlestr, ylabelstr, ylimrange)
sr = 22050;
Markers = {'d','+','s','>','<','^', 'o','*','x','v',};

figure(index);

hold on
set(gca, 'XScale', 'log');

for i=1:size(means,1)
    semilogx(tfrs(:), means(i, :), strcat('-',Markers{i}),'MarkerSize',12, 'LineWidth',4, 'Color', color)
end

ylim(ylimrange)
xlabel('a*M/sr','FontSize',24)
ylabel(ylabelstr,'FontSize',24)
set(gca, 'XTick', [1e-2,1,1e2,1e4])
legend({'\sigma = 01','\sigma = 05', '\sigma = 1'},'Location','southeast','FontSize',24)
set(gca,'Fontsize',24);

hold off

sgtitle(titlestr,'FontSize',24);
box on
end