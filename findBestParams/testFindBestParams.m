clear all

% ltfatstart(); % start the ltfat toolbox
% phaseretstart;

base_folder = '\\kfsnas08.kfs.oeaw.ac.at\Denklast\amarafioti\Documents\Datasets\LJSpeech-1.1\wavs\';
soundfiles = dir(base_folder);
soundfiles = soundfiles(3:end);
examples = 64;
array_of_signal_paths = strings(examples,1);

index = 0;
for k = 1:examples
    array_of_signal_paths(k) = strcat(base_folder, soundfiles(k).name);
end

L = 2^13 * 3 * 5;

d = 32* propdiv(L/32);

Ms = d(find(d>=256 & d<L/16));
Ds = [32, 16, 8, 4];

odg_threshold = 0.3;
SNR_threshold = 15;

[best_M_pghi, best_D_pghi] = findBestParams(@pghi_func, array_of_signal_paths, Ms, Ds, L, odg_threshold, SNR_threshold);


Ms = d(find(d>=128 & d<L/16));
Ds = [8, 4];

odg_threshold = 0.3;
SNR_threshold = 10;

[best_M_fgla, best_D_fgla] = findBestParams(@fgla_func, array_of_signal_paths, Ms, Ds, L, odg_threshold, SNR_threshold);
[best_M_spsi, best_D_spsi] = findBestParams(@spsi_func, array_of_signal_paths, Ms, Ds, L, odg_threshold, SNR_threshold);


function c_amp_pghi = pghi_func(c_amp, a, M)
    gamma = a*M;
    c_amp_pghi = pghi(c_amp,gamma,a,M,'timeinv', 'tol', 1e-7);
end

function c_amp_fgla = fgla_func(c_amp, a, M)
    L = size(c_amp, 2)*a;
    win = {'gauss',a*M/L};
    win = gabwin(win,a,M,L);
    c_amp_fgla = gla(c_amp,win,a,M,'fgla');
end

function c_amp_spsi = spsi_func(c_amp, a, M)
    c_amp_spsi = spsi(c_amp,a,M,'timeinv');
end