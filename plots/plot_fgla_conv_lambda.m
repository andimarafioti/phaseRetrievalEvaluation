clear all
load('fgla_conver_lambda.mat')

sr = 22050;
tfrs = M.^2/(22080*red0);

means_ODG = [squeeze(mean(ODG_gla(:, 1, :), 1)), squeeze(mean(ODG_gla(:, 6, :), 1)), squeeze(mean(ODG_gla(:, 20, :), 1)), squeeze(mean(ODG_gla(:, 60, :), 1))];
means_SC = [squeeze(mean(SC_gla(:, 1, :), 1)), squeeze(mean(SC_gla(:, 6, :), 1)), squeeze(mean(SC_gla(:, 20, :), 1)), squeeze(mean(SC_gla(:, 60, :), 1))];

plotConvLambda(1, means_ODG , tfrs, 'ODG', [-4, 0.5], false)
plotConvLambda(2, means_SC, tfrs, 'SNR_{MS}', [0, 59], true)

function plotConvLambda(index, means, tfrs, ylabelstr, ylimrange, leg)

f = figure(index);
set(f, 'Position', [10 10 600 800])
lineStyles = { ':', '--', '-.', '-'};

set(gca, 'XScale', 'log');
set(gca,'Fontsize',48);
xlim([1e-3, 2e4])
set(gca, 'XTick', [1e-3,1e-1,1e1,1e3])
% set(gca, 'YTick', [0,20,40,60])

xlabel('\lambda','FontSize',48)
ylim(ylimrange)
box on
hold on
for i=1:size(means,2)
    semilogx(tfrs, means(:, i), lineStyles{i}, 'LineWidth',9, 'Color', [0.9290, 0.6940, 0.1250])
end
ylabel(ylabelstr,'FontSize',48)

if leg
    leg = legend({'5','30', '100', '300'},'Location','northwest','FontSize',48);
    leg.ItemTokenSize = [80,160];
end
exportgraphics(f, strcat("convergence_lambda_", ylabelstr,".png"))
end