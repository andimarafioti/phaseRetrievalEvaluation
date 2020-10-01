load('hann_ljspeech.mat')
sr = 22050;
tfrs = (M.^2./(sr.*red)')';

plotThreeMethodComparison(3, [mean(to_save_pghi, 1); mean(to_save_gla, 1); mean(to_save_spsi, 1)], tfrs, 'ODG', ['PGHI';'FGLA';'SPSI'], [-4,0.5])
plotThreeMethodComparison(4, [-mean(SNR_pghi, 1); -mean(SNR_gla, 1); -mean(SNR_spsi, 1)], tfrs, 'SNR_{MS}', [' ';' ';' '], [0, 60])
% 
% plotStats(1, mean(to_save_pghi, 1), tfrs, 'PEAQ PGHI', [-4,0.5])
% plotStats(2, mean(SNR_pghi, 1), tfrs, 'SC PGHI', [-60,6])
% plotStats(3, mean(to_save_gla, 1), tfrs, 'PEAQ FGLA', [-4,0.5])
% plotStats(4, mean(SNR_gla, 1), tfrs, 'SC FGLA', [-60,6])
% plotStats(5, mean(to_save_spsi, 1), tfrs, 'PEAQ SPSI', [-4,0.5])
% plotStats(6, mean(SNR_spsi, 1), tfrs, 'SC SPSI', [-60,6])
