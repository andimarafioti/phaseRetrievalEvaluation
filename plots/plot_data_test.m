load('pghi_midi_speech_electronic_rock.mat')

sr = 22050;
tfrs = (M.^2./(sr.*red)')';

SC_midi(any(isnan(ODG_midi), [2,3]), :, :) = [];
ODG_midi(any(isnan(ODG_midi), [2,3]), :, :) = [];

means_SC_midi = mean(SC_midi, 1);
means_SC_speech = mean(SC_speech, 1);
means_SC_electronic = mean(SC_electronic, 1);
means_SC_rock = mean(SC_rock, 1);

means_SC = [means_SC_midi;means_SC_speech;means_SC_electronic;means_SC_rock];

for index = 1:2:length(red)
    plotDiffData(1, means_SC(:, :, index), M, tfrs(:, index), 'Data dependency at different redundancies', 'SC PGHI', [-60, 0])
end

means_ODG_midi = mean(ODG_midi, 1);
means_ODG_speech = mean(ODG_speech, 1);
means_ODG_electronic = mean(ODG_electronic, 1);
means_ODG_rock = mean(ODG_rock, 1);

means_ODG = [means_ODG_midi;means_ODG_speech;means_ODG_electronic;means_ODG_rock];

for index = 1:2:length(red)
    plotDiffData(3, means_ODG(:, :, index), M, tfrs(:, index), 'Data dependency at different redundancies', 'PEAQ PGHI', [-4, 0])
end


% plotStats(1, means_SC_midi, M, tfrs, 'Objective quality of phaseless reconstruction', 'SC PGHI', [-60,6])
% plotStats(2, means_SC_speech, M, tfrs, 'Objective quality of phaseless reconstruction', 'SC PGHI', [-60,6])
