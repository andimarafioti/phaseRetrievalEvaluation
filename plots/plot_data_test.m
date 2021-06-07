load('final_final_diff_data.mat')
Markers = {'d','+','s','>','<','^', 'o','*','x','v',};
colors = [[0, 0.4470, 0.7410]; [0.8500, 0.3250, 0.0980]; [0.9290, 0.6940, 0.1250]; [0.4940, 0.1840, 0.5560]; [0.4660, 0.6740, 0.1880]];

sr = 22050;

tfrs = (M.^2./(sr.*red)')';

SC_midi_PGHI(any(isnan(ODG_midi_PGHI), [2,3]), :, :) = [];
ODG_midi_PGHI(any(isnan(ODG_midi_PGHI), [2,3]), :, :) = [];

SC_midi_SPSI(any(isnan(ODG_midi_SPSI), [2,3]), :, :) = [];
ODG_midi_SPSI(any(isnan(ODG_midi_SPSI), [2,3]), :, :) = [];

means_SC_PGHI = [mean(SC_midi_PGHI, 1); mean(SC_speech_PGHI, 1); mean(SC_electronic_PGHI, 1); mean(SC_rock_PGHI, 1)];
means_SC_SPSI = [mean(SC_midi_SPSI, 1); mean(SC_speech_SPSI, 1); mean(SC_electronic_SPSI, 1); mean(SC_rock_SPSI, 1)];

means_ODG_PGHI = [mean(ODG_midi_PGHI, 1); mean(ODG_speech_PGHI, 1); mean(ODG_electronic_PGHI, 1); mean(ODG_rock_PGHI, 1)];
means_ODG_SPSI = [mean(ODG_midi_SPSI, 1); mean(ODG_speech_SPSI, 1); mean(ODG_electronic_SPSI, 1); mean(ODG_rock_SPSI, 1)];

load('fgla_diff_data.mat')

tfrs = (M.^2./(sr.*red)')';

SC_midi_FGLA(any(isnan(ODG_midi_FGLA), [2,3]), :, :) = [];
ODG_midi_FGLA(any(isnan(ODG_midi_FGLA), [2,3]), :, :) = [];


means_SC_FGLA = [mean(SC_midi_FGLA, 1); mean(SC_speech_FGLA, 1); mean(SC_electronic_FGLA, 1)];
means_ODG_FGLA = [mean(ODG_midi_FGLA, 1); mean(ODG_speech_FGLA, 1); mean(ODG_electronic_FGLA, 1)];

f = figure(1);
set(f, 'Position', [10 10 1800 800])

for index = 1:length(red)
    plotDiffData(1, -means_SC_PGHI(1:3, :, index), M, tfrs(:, index), 'SNR_{MS}', ' ', [0, 59], colors(2*index-1, :), 'SNR_{MS} PGHI')
end

for index = 2
    plotDiffData(3, -means_SC_SPSI(1:3, :, index), M, tfrs(:, index), ' ', ' ', [0, 59], colors(2*index-1, :), 'SNR_{MS} SPSI')
end

for index = 1:length(red)
    plotDiffData(2, -means_SC_FGLA(:, 1:end-1, index), M, tfrs(1:end-1, index), ' ', ' ', [0, 59], colors(2*(index+1)-1, :), 'SNR_{MS} FGLA')
end

exportgraphics(f, strcat("data_dependencies_SNR.png"))


f = figure(2);
set(f, 'Position', [10 10 1800 680])

for index = 1:length(red)
    plotDiffData(1, means_ODG_PGHI(1:3, :, index), M, tfrs(:, index), 'ODG_{1}', 'PGHI', [-4, 0.5], colors(2*index-1, :), 'ODG PGHI')
end

for index = 2
    plotDiffData(3, means_ODG_SPSI(1:3, :, index), M, tfrs(:, index), ' ', 'SPSI', [-4, 0.5], colors(2*index-1, :), 'ODG SPSI')
end

for index = 1:length(red)
    plotDiffData(2, means_ODG_FGLA(:, 1:end-1, index), M, tfrs(1:end-1, index), ' ', 'FGLA', [-4, 0.5], colors(2*(index+1)-1, :), 'ODG FGLA')
end

exportgraphics(f, strcat("data_dependencies_ODG.png"))

