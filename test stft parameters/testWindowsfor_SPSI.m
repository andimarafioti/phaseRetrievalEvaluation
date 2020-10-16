clear all

%ltfatstart(); % start the ltfat toolbox
%phaseretstart;

%%
% base_folder = '\\kfsnas08\Denklast\amarafioti\Documents\Datasets\Lakh\new-simple-piano\';
% soundfiles = dir(base_folder);
% soundfiles = soundfiles(4:end);

base_folder = '\\kfsnas08.kfs.oeaw.ac.at\Denklast\amarafioti\Documents\Datasets\LJSpeech-1.1\wavs\';
soundfiles = dir(base_folder);
soundfiles = soundfiles(3:end);


%% STFT parameters 

L = 2^13 * 3 * 5;

d = 32* propdiv(L/32);

M = d(find(d>=64 & d<L/2));
M = [32 M];
red = [32, 16, 8, 4, 2];

%red = [4,16];
%M=[512, 1024, 2048];
flag = 'timeinv';

M_SNR = 2048;
a_SNR = 128;
win_SNR = {'gauss',a_SNR*M_SNR/L};
win_SNR = gabwin(win_SNR,a_SNR,M_SNR,L);
%% Prepare arrays for results

examples = 1;
to_save_spsi = zeros(examples, length(M), length(red));
SNR_spsi = zeros(examples, length(M), length(red));

%% Reconstruct signals

tic

index = 0;
for k = 1:length(soundfiles)
    index
    toc
    if index >= examples
        break
    end
    [signal, fs] = audioread(strcat(base_folder, soundfiles(k).name));
    
    if length(signal) < L
        continue
    end
   
    index = index + 1;
    signal = signal(1:L);

    for M0 = M
        for red0 = red
            a0 = M0 / red0;

            win = {'gauss',a0*M0/L};
            win = gabwin(win,a0,M0,L);
            dual = {'dual',win};

            c_ori = dgtreal(signal,win,a0,M0,L,flag); % DGT of original
            c_amp = abs(c_ori); % Initialize magnitude

            % SPSI
            c_amp_spsi = spsi(c_amp,a0,M0,flag);
            f_amp_spsi = idgtreal(c_amp_spsi,dual,a0,M0,flag);

            % Measure PEAQ
            signal_resampled = resample(signal(M0:end-M0), 48000, fs);
            spsi_resampled = resample(f_amp_spsi(M0:end-M0), 48000, fs);

            audiowrite('or.wav', signal_resampled, 48000);
            audiowrite('spsi.wav', spsi_resampled, 48000);

            [odg, movb] = PQevalAudio_fn('or.wav', 'spsi.wav');
            to_save_spsi(index, M0==M, red0==red) = odg;
            
            % Measure spectral divergence

            re_c_amp = abs(dgtreal(signal,win_SNR,a_SNR,M_SNR,L,flag));
            re_c_amp_spsi = abs(dgtreal(f_amp_spsi,win_SNR,a_SNR,M_SNR,L,flag));

            SNR_spsi(index, M0==M, red0==red) = magnitudeerrdb(re_c_amp_spsi, re_c_amp);

        end
    end
end
toc

tfrs = (M.^2./(L.*red)')';

plotStats(1, mean(to_save_spsi, 1), tfrs, 'PEAQ SPSI', [-4,0.5])
plotStats(2, mean(SNR_spsi, 1), tfrs, 'SC SPSI', [-60,6])


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
