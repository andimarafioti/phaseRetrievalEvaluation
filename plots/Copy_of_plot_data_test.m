load('final_final_diff_data.mat')
Markers = {'d','+','s','>','<','^', 'o','*','x','v',};

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

colors = [[0, 0.4470, 0.7410]; [0.8500, 0.3250, 0.0980]; [0.9290, 0.6940, 0.1250]; [0.4940, 0.1840, 0.5560]; [0.4660, 0.6740, 0.1880]];

for index = 1:length(red)
    plotDiffData(1, -means_SC_PGHI(1:3, :, index), M, tfrs(:, index), 'SC PGHI', [0, 60], colors(2*index-1, :))
end

for index = 2
    plotDiffData(2, -means_SC_SPSI(1:3, :, index), M, tfrs(:, index), 'SC SPSI', [0, 60], colors(2*index-1, :))
end

for index = 1:length(red)
    plotDiffData(3, means_ODG_PGHI(1:3, :, index), M, tfrs(:, index), 'ODG PGHI', [-4, 0.5], colors(2*index-1, :))
end

for index = 2
    plotDiffData(4, means_ODG_SPSI(1:3, :, index), M, tfrs(:, index), 'ODG SPSI', [-4, 0.5], colors(2*index-1, :))
end


% plotStats(1, means_SC_midi, M, tfrs, 'Objective quality of phaseless reconstruction', 'SC PGHI', [-60,6])
% plotStats(2, means_SC_speech, M, tfrs, 'Objective quality of phaseless reconstruction', 'SC PGHI', [-60,6])
