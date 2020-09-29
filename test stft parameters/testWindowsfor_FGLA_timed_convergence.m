%clear all

%ltfatstart(); % start the ltfat toolbox
%phaseretstart;

%%
% base_folder = '\\kfsnas08\Denklast\amarafioti\Documents\Datasets\Lakh\new-simple-piano\';
% soundfiles = dir(base_folder);
% soundfiles = soundfiles(4:end);

examples = 128;
base_folder = '\\kfsnas08.kfs.oeaw.ac.at\Denklast\amarafioti\Documents\Datasets\LJSpeech-1.1\wavs\';
soundfiles = findWavFiles(base_folder);
soundfiles = soundfiles(1:examples);

%% STFT parameters 

L = 2^13 * 3 * 5;
tfr = 0.6;

d = 32* propdiv(L/32);

M = d(find(d>=64 & d<L/3));

red = [32, 16, 8, 4, 2];

flag = 'timeinv';

M_SNR = 2048;
a_SNR = 128;
win_SNR = {'gauss',a_SNR*M_SNR/L};
win_SNR = gabwin(win_SNR,a_SNR,M_SNR,L);
%% Prepare arrays for results

base_steps_iteration = 6;
base_num_iterations = 240;

ODG_gla = zeros(1, base_num_iterations/base_steps_iteration, length(red));
SC_gla = zeros(1, base_num_iterations/base_steps_iteration, length(red));

time_gla = zeros(1, length(red));

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
    time_gla(size(time_gla, 1)+1, :, :) = 0;

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
        c_start = c_amp;
        signal_resampled = resample(signal(M0:end-M0), 48000, fs);
        % FGLA
        tic
        multiplier = 16/red0;
        num_iterations = base_num_iterations*multiplier;
        steps_iteration = base_steps_iteration*multiplier;
        
        [c_rec_gla, f_rec_gla] = modGla(c_amp,win,a0,M0, 'print', 'fgla', 'maxit', num_iterations, 'printstep', steps_iteration);
        time_gla(size(time_gla, 1), red0==red) = toc;

        for iteration = 1: num_iterations/steps_iteration
            % Measure PEAQ
            gla_resampled = resample(f_rec_gla(iteration, M0:end-M0), 48000, fs);

            audiowrite('or_con.wav', signal_resampled, 48000);
            audiowrite('gla_con.wav', gla_resampled, 48000);

            [odg, movb] = PQevalAudio_fn('or_con.wav', 'gla_con.wav');
            ODG_gla(size(ODG_gla, 1), iteration, red0==red) = odg;

            % Measure spectral divergence

            re_c_amp = abs(dgtreal(signal,win_SNR,a_SNR,M_SNR,L,flag));
            re_c_amp_gla= abs(dgtreal(f_rec_gla(iteration, :),win_SNR,a_SNR,M_SNR,L,flag));

            SC_gla(size(SC_gla, 1), iteration, red0==red) = magnitudeerrdb(re_c_amp_gla, re_c_amp);
        end      

    end
end
toc

ODG_gla = ODG_gla(2:end, :, :);
SC_gla = SC_gla(2:end, :, :);

timed_gla = mean(time_gla(2,:), 1);

plotTimedConvergence(3, mean(ODG_gla, 1), red, timed_gla, 'ODG', [-3,0.5])
plotTimedConvergence(4, -mean(SC_gla, 1), red, timed_gla, 'SC', [5,50])

save('convergence_fgla_timed_ljspeech.mat', 'ODG_gla', 'SC_gla', 'M', 'red', 'L', 'timed_gla')
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
