load('hann_ljspeech.mat')
sr = 22050;
tfrs = (M.^2./(sr.*red)')';

plotThreeMethodComparison(3, [mean(to_save_pghi, 1); mean(to_save_gla, 1); mean(to_save_spsi, 1)], tfrs, 'ODG', ['PGHI';'FGLA';'SPSI'], [-4,0.5])
plotThreeMethodComparison(4, [-mean(SNR_pghi, 1); -mean(SNR_gla, 1); -mean(SNR_spsi, 1)], tfrs, 'SNR_{MS}', [' ';' ';' '], [0, 60])
