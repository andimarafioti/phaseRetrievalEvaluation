clear all

load('new_random_1_ljspeech.mat')

SNR_1 = squeeze(SNR(:, :, M==2048, :, 2));
meaned_SNR_1 = mean(SNR, 1);
to_save_1_peaq = to_save_peaq;
to_save_1_pemoq = to_save_pemoq;

load('new_random_05_ljspeech.mat')

SNR_05 = squeeze(SNR(:, :, M==2048, :, 2));
meaned_SNR_05 = mean(SNR, 1);
to_save_05_peaq = to_save_peaq;
to_save_05_pemoq = to_save_pemoq;

load('new_random_01_ljspeech.mat')

SNR_01 = squeeze(SNR(:, :, M==2048, :, 2));
meaned_SNR_01 = mean(SNR, 1);
to_save_01_peaq = to_save_peaq;
to_save_01_pemoq = to_save_pemoq;

red = [32, 8, 2];

sr = 22050;
tfrs = (M.^2./(sr.*red)')';
%tfrs = tfrs(:, 1:2:length(red));

means_SC_01 = mean(SNR_01, 1);
means_SC_05 = mean(SNR_05, 1);
means_SC_1 = mean(SNR_1, 1);

means_ODG_01 = mean(to_save_01_peaq, 1);
means_ODG_05 = mean(to_save_05_peaq, 1);
means_ODG_1 = mean(to_save_1_peaq, 1);

means_PEMOQ_ODG_1 = mean(to_save_1_pemoq, 1);
means_PEMOQ_ODG_01 = mean(to_save_01_pemoq, 1);
means_PEMOQ_ODG_05 = mean(to_save_05_pemoq, 1);
%means_ODG_1 = mean(to_save_1, 1);

means_SC = [means_SC_01;means_SC_05; means_SC_1];
means_SNR = [meaned_SNR_01; meaned_SNR_05; meaned_SNR_1];
means_ODG = [means_ODG_01; means_ODG_05; means_ODG_1];
means_PEMOQ_ODG = [means_PEMOQ_ODG_01; means_PEMOQ_ODG_05; means_PEMOQ_ODG_1];

Markers = {'d','+','s','>','<','^', 'o','*','x','v',};

%for index = 1:3
%    index = 4-index;
%    plotNoiseInfluence(1, squeeze(means_SC(index, :, :)), M, tfrs, 'SNR_{MS}', [0, 60], Markers{index})
%end

for index = 1:3
    index = 4-index;
    plotNoiseInfluence(2, squeeze(means_ODG(index, :, :)), M, tfrs, 'ODG', [-4, 0.5], Markers{index})
end

for index = 1:3
    index = 4-index;
    plotNoiseInfluence(3, squeeze(means_PEMOQ_ODG(index, :, :)), M, tfrs, 'ODG_{PEMO}', [-4, 0.5], Markers{index})
end

for index = 1:3
    index = 4-index;
    plotSNRmsTest(4, squeeze(means_SNR(index, :, :, :, :)), tfrs, 'SNR_{MS}', [0, 60], Markers{index})
end
