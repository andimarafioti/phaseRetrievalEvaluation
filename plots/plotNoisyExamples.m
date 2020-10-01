clear all

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
tfrs = tfrs(:, 1:2:length(red));

means_SC_01 = mean(SNR_01, 1);
means_SC_05 = mean(SNR_05, 1);
means_SC_1 = mean(SNR_1, 1);

means_ODG_01 = mean(to_save_01, 1);
means_ODG_05 = mean(to_save_05, 1);
means_ODG_1 = mean(to_save_1, 1);

means_SC = [means_SC_01;means_SC_05;means_SC_1];
means_SC = means_SC(:, :, 1:2:length(red));
means_ODG = [means_ODG_01; means_ODG_05; means_ODG_1];
means_ODG = means_ODG(:, :, 1:2:length(red));

Markers = {'d','+','s','>','<','^', 'o','*','x','v',};

for index = 1:3
    index = 4-index;
    plotNoiseInfluence(1, squeeze(-means_SC(index, :, :)), M, tfrs, 'SNR_{MS}', [0, 60], Markers{index})
end

for index = 1:3
    index = 4-index;
    plotNoiseInfluence(2, squeeze(means_ODG(index, :, :)), M, tfrs, 'ODG', [-4, 0.5], Markers{index})
end
