function plotDiffWindows(index, means, M, tfrs, ylabelstr, titles, ylimrange, faceColor, line_style)

for i=1:size(means,1)
    semilogx(tfrs(:), means(i, :), 'LineWidth',9, 'LineStyle', line_styles{i}, 'Color', faceColor)
end

xlim([1e-3, 2e4])
set(gca, 'XTick', [1e-3,1e-1,1e1,1e3])

ylim(ylimrange)
xlabel('\lambda','FontSize',48)
ylabel(ylabelstr,'FontSize',48)
title(titles,'FontSize',48)

legend({'gauss','Blackman', 'Hann', 'Bartlett'},'Location','northwest','FontSize',48)
set(gca,'Fontsize',48);

% hold off

box on
end