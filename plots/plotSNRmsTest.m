function plotSNRmsTest(index, means, tfrs, ylabelstr, ylimrange, marker)

    colors = [[0, 0.4470, 0.7410]; [0.9290, 0.6940, 0.1250]; [0.4660, 0.6740, 0.1880]];

    f = figure(index);
    set(f, 'Position', [0 0 900 900])
    set(gca,'Fontsize',32);

    hold on
    set(gca, 'XScale', 'log');

    flatten_dim = size(means, 2) * size(means, 4);
    data_to_plot = zeros([size(means, 1), flatten_dim, size(means,3)]);

    for i=1:size(means, 4)
        data_to_plot(:, 1+(i-1)*size(means, 2):i*size(means, 2), :) = means(:, :, :, i);
    end
    
    for i=1:size(data_to_plot,3)
        means_data_to_plot = mean(squeeze(data_to_plot(:, :, i)), 2).';
        stds_data_to_plot = std(squeeze(data_to_plot(:, :, i)), 0, 2).';
        x = [tfrs(:, i).', fliplr(tfrs(:, i).')];
        %y = cat(2,  means_data_to_plot-stds_data_to_plot, stds_data_to_plot);
        y = [means_data_to_plot+stds_data_to_plot, fliplr(means_data_to_plot-stds_data_to_plot)];
        patch = fill(x, y, min(colors(i, :)*1.1, 1),'HandleVisibility','off');
        set(patch, 'edgecolor', 'none');
        set(patch, 'FaceAlpha', 0.3);
        semilogx(tfrs(:, i), means_data_to_plot, strcat('-',marker),'MarkerSize',12, 'LineWidth',4, 'Color', colors(i, :))
    end
    set(gca, 'XTick', [1e-2,1,1e2,1e4])
    xlim([1e-4, 4e4])
    ylim(ylimrange)
    xlabel('\lambda','FontSize',64)
    ylabel(ylabelstr,'FontSize',48)
    xlim([1e-3, 6e4])
    set(gca, 'XTick', [1e-3,1e-1,1e1,1e3])
    legend({'D = 32','D = 8', 'D = 2'},'Location','northeast','FontSize',32)
    box on
exportgraphics(f, strcat("noise_influence_", ylabelstr, ".png"))

end