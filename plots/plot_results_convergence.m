clear all 

load('convergence_fgla.mat')

time_gla =   [39.7088   19.9318    9.2643    5.2965    2.9913];

plotConvergence(1, mean(ODG_gla(2:end, :, :), 1), red, 'Perceptual convergence of FGLA', 'PEAQ', [-3,0.5])
plotConvergence(2, mean(SC_gla(2:end, :, :), 1), red, 'Objective convergence of FGLA', 'SC', [-30,-5])

plotTimedConvergence(3, mean(ODG_gla(2:end, :, :), 1), red, time_gla, 'Perceptual convergence of FGLA', 'PEAQ', [-3,0.5])
plotTimedConvergence(4, mean(SC_gla(2:end, :, :), 1), red, time_gla, 'Objective convergence of FGLA', 'SC', [-30,-5])
