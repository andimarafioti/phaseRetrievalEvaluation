clear all 

load('convergence_fgla.mat')

time_gla =   [39.7088   19.9318    9.2643    5.2965    2.9913];

plotConvergence(1, mean(ODG_gla(2:end, :, :), 1), red, 'ODG', [-3,0.5])
plotConvergence(2, -mean(SC_gla(2:end, :, :), 1), red, 'SNR_{MS}', [5, 50])

plotTimedConvergence(3, mean(ODG_gla(2:end, :, :), 1), red, time_gla, 'ODG', [-3,0.5])
plotTimedConvergence(4, -mean(SC_gla(2:end, :, :), 1), red, time_gla, 'SNR_{MS}', [5,50])
