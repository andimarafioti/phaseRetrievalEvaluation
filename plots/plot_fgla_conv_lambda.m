clear all
load('fgla_conver_lambda.mat')

sr = 22050;
tfrs = M.^2/(22080*red0);

means_ODG = [squeeze(mean(ODG_gla(:, 1, :), 1)), squeeze(mean(ODG_gla(:, 6, :), 1)), squeeze(mean(ODG_gla(:, 20, :), 1)), squeeze(mean(ODG_gla(:, 60, :), 1))];
means_SC = [squeeze(mean(SC_gla(:, 1, :), 1)), squeeze(mean(SC_gla(:, 6, :), 1)), squeeze(mean(SC_gla(:, 20, :), 1)), squeeze(mean(SC_gla(:, 60, :), 1))];

plotConvLambda(1, means_ODG , tfrs, 'ODG', [-4, 0.5], false)
plotConvLambda(2, means_SC, tfrs, 'SNR_{MS}', [0, 60], true)

function plotConvLambda(index, means, tfrs, ylabelstr, ylimrange, leg)

f = figure(index);
set(f, 'Position', [10 10 600 900])
Markers = {'d','+','s','^', 'o','*','x','v',};

set(gca, 'XScale', 'log');
set(gca,'Fontsize',32);
xlim([1e-3, 2e4])
set(gca, 'XTick', [1e-3,1e-1,1e1,1e3])
xlabel('\lambda','FontSize',32)
ylim(ylimrange)
box on
hold on
for i=1:size(means,2)
    semilogx(tfrs, means(:, i), strcat('-',Markers{i}),'MarkerSize',8, 'LineWidth',5, 'Color', [0.9290, 0.6940, 0.1250])
end
ylabel(ylabelstr,'FontSize',32)

if leg
    legend({'iter = 5','iter = 30', 'iter = 100', 'iter = 300'},'Location','northeast','FontSize',24)
end
end