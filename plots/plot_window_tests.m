load('new_pghi_gla_ljspeech.mat')
load('new_spsi_ljspeech.mat')
sr = 22050;
tfrs = (M.^2./(sr.*red)')';

plotThreeMethodComparison(1, [mean(to_save_peaq_pghi, 1); mean(to_save_peaq_gla, 1); mean(to_save_spsi, 1)], tfrs, 'ODG', ['PGHI';'FGLA';'SPSI'], [-4,0.5])
plotThreeMethodComparison(2, [mean(to_save_pemoq_pghi, 1); mean(to_save_pemoq_gla, 1); mean(to_save_pemoq, 1)], tfrs, 'ODG_{PEMO}', [' ';' ';' '], [-4,0.5])
plotThreeMethodComparison(3, [-mean(SNR_pghi, 1); -mean(SNR_gla, 1); -mean(SNR_spsi, 1)], tfrs, 'SNR_{MS}', [' ';' ';' '], [0, 60])


