load('pghi_gla_ljspeech.mat')
sr = 22050;
tfrs = (M.^2./(L.*red)')';
tfrs = tfrs*L/sr;

plotStats(1, mean(to_save_pghi, 1), M, tfrs, 'Perceptual quality of phaseless reconstruction', 'PEAQ PGHI', [-4,0.5])
plotStats(2, mean(SNR_pghi, 1), M, tfrs, 'Objective quality of phaseless reconstruction', 'SC PGHI', [-60,6])
plotStats(3, mean(to_save_gla, 1), M, tfrs, 'Perceptual quality of phaseless reconstruction', 'PEAQ FGLA', [-4,0.5])
plotStats(4, mean(SNR_gla, 1), M, tfrs, 'Objective quality of phaseless reconstruction', 'SC FGLA', [-60,6])

