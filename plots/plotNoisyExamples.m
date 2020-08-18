load('random_1_ljspeech.mat')

SNR_1 = SNR;
to_save_1 = to_save;

load('random_05_ljspeech.mat')

SNR_05 = SNR;
to_save_05 = to_save;

load('random_01_ljspeech.mat')

SNR_01 = SNR;
to_save_01 = to_save;

sr = 22050;
tfrs = (M.^2./(sr.*red)')';

means_SC_01 = mean(SNR_01, 1);
means_SC_05 = mean(SNR_05, 1);
means_SC_1 = mean(SNR_1, 1);

means_ODG_01 = mean(to_save_01, 1);
means_ODG_05 = mean(to_save_05, 1);
means_ODG_1 = mean(to_save_1, 1);

means_SC = [means_SC_01;means_SC_05;means_SC_1];
means_ODG = [means_ODG_01; means_ODG_05; means_ODG_1];

colors = [[0, 0.4470, 0.7410]; [0.8500, 0.3250, 0.0980]; [0.9290, 0.6940, 0.1250]; [0.4940, 0.1840, 0.5560]];

for index = 1:2:length(red)
    plotNoiseInfluence(1, means_SC(:, :, index), colors((index+1)/2, :), M, tfrs(:, index), 'Noisy influence at different redundancies', 'SC PGHI', [-50, 0])
end

for index = 1:2:length(red)
    plotNoiseInfluence(1, means_ODG(:, :, index), colors((index+1)/2, :), M, tfrs(:, index), 'Noisy influence at different redundancies', 'PEAQ PGHI', [-4, 0.5])
end
