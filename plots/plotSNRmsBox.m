function plotSNRmsBox(index, means, tfrs)

%% Prepare figure
f = figure(index);
set(f, 'Position', [10 10 750 500])
hold on
set(gca, 'XScale', 'log');
colors = [[0, 0.4470, 0.7410]; [0.8500, 0.3250, 0.0980]; [0.9290, 0.6940, 0.1250]; [0.4940, 0.1840, 0.5560]; [0.4660, 0.6740, 0.1880]];

%% Prepare Data

flatten_dim = size(means, 2) * size(means, 4);
data_to_plot = zeros([size(means, 1), flatten_dim, size(means,3)]);

for i=1:size(means, 4)
    data_to_plot(:, 1+(i-1)*size(means, 2):i*size(means, 2), :) = means(:, :, :, i);
end

size(data_to_plot)
size(tfrs)

xlim([1e-3, 2e4])
for i=1:size(data_to_plot,3)
    boxplot(data_to_plot(:, :, i).', tfrs(:, i), "Colors", colors(2*i-1, :))
    %boxplot(data_to_plot(:, :, i).', "positions", tfrs(:, i), "labels", tfrs(:, i), "Colors", colors(2*i-1, :))
end
ylim auto
xlim auto
%xlim([1e-3, 2e4])
%set(gca, 'XTick', [1e-3,1e-1,1e1,1e3])
end