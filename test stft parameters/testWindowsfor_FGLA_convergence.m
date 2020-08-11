%clear all

%ltfatstart(); % start the ltfat toolbox
%phaseretstart;

%%
% base_folder = '\\kfsnas08\Denklast\amarafioti\Documents\Datasets\Lakh\new-simple-piano\';
% soundfiles = dir(base_folder);
% soundfiles = soundfiles(4:end);

examples = 32;
base_folder = '\\kfsnas08.kfs.oeaw.ac.at\Denklast\amarafioti\Documents\Datasets\LJSpeech-1.1\wavs\';
%soundfiles = findWavFiles(base_folder);
%soundfiles = soundfiles(1:examples);

%% STFT parameters 

L = 2^13 * 3 * 5;

tfr = 0.6;

red = [32, 16, 8, 4, 2];

d = 32* propdiv(L/32);
M = d(find(d>=64 & d<L/2));

flag = 'timeinv';

M_SNR = 2048;
a_SNR = 128;
win_SNR = {'gauss',a_SNR*M_SNR/L};
win_SNR = gabwin(win_SNR,a_SNR,M_SNR,L);
%% Prepare arrays for results

steps_iteration = 10;
num_iterations = 100;
ODG_gla = zeros(1, steps_iteration, length(red));
SC_gla = zeros(1, steps_iteration, length(red));

%% Reconstruct signals

tic

for k = 1:length(soundfiles)
    toc
    [signal, fs] = audioread(strcat(base_folder, soundfiles(k).name));
    
    if length(signal) < L
        continue
    end
    signal = signal(1:L);
    SC_gla(size(SC_gla, 1)+1, :, :) = 0;
    ODG_gla(size(ODG_gla, 1)+1, :, :) = 0;

    for red0 = red
        M0 = sqrt(tfr*L*red0);
        [val, idx] = min(abs(M-M0));        
        M0 = M(idx);
        a0 = M0 / red0;

        win = {'gauss',a0*M0/L};
        win = gabwin(win,a0,M0,L);
        gamma = a0*M0;
        dual = {'dual',win};

        c_ori = dgtreal(signal,win,a0,M0,L,flag); % DGT of original
        c_amp = abs(c_ori); % Initialize magnitude
        c_rec_gla = c_amp;
        signal_resampled = resample(signal(M0:end-M0), 48000, fs);

        for iteration = 1: num_iterations/steps_iteration
            % FGLA
            [c_rec_gla,f_rec_gla] = gla(c_rec_gla,win,a0,M0, steps_iteration, 'fgla');

            % Measure PEAQ
            gla_resampled = resample(f_rec_gla(M0:end-M0), 48000, fs);

            audiowrite('or.wav', signal_resampled, 48000);
            audiowrite('gla.wav', gla_resampled, 48000);

            [odg, movb] = PQevalAudio_fn('or.wav', 'gla.wav');
            ODG_gla(size(ODG_gla, 1), iteration, red0==red) = odg;

            % Measure spectral divergence

            re_c_amp = abs(dgtreal(signal,win_SNR,a_SNR,M_SNR,L,flag));
            re_c_amp_gla= abs(dgtreal(f_rec_gla,win_SNR,a_SNR,M_SNR,L,flag));

            SC_gla(size(SC_gla, 1), iteration, red0==red) = magnitudeerrdb(re_c_amp_gla, re_c_amp);
        end

    end
end
toc

plotConvergence(1, mean(ODG_gla(2:end, :, :), 1), red, 'Perceptual quality of phaseless reconstruction', 'PEAQ FGLA', [-4,0.5])
plotConvergence(2, mean(SC_gla(2:end, :, :), 1), red, 'Objective quality of phaseless reconstruction', 'SC FGLA', [-60,6])

function d=propdiv(n)
% PROPDIV   - Proper divisors of integer
%
% Usage:      d=propdiv(n)
%
% Input:      n  integer
% Output:     d  vector of proper divisors of n

% N. Kaiblinger, 2000

d=n./(n-1: - 1 : 2);
d=d(d==round(d));
end
