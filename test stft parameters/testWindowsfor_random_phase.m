clear all

ltfatstart(); % start the ltfat toolbox
phaseretstart;

%%
% base_folder = '\\kfsnas08\Denklast\amarafioti\Documents\Datasets\Lakh\new-simple-piano\';
% soundfiles = dir(base_folder);
% soundfiles = soundfiles(4:end);

base_folder = '\\kfsnas08\Denklast\amarafioti\Documents\Datasets\LJSpeech-1.1\wavs\';
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

%% Prepare arrays for results

examples = 16;
to_save = zeros(examples, length(M), length(red));
SNR = zeros(examples, length(M), length(red));

M_SNR = 2048;
a_SNR = 128;
win_SNR = {'gauss',a_SNR*M_SNR/L};
win_SNR = gabwin(win_SNR,a_SNR,M_SNR,L);

%% Reconstruct signals
tic

index = 0;
for k = 1:length(soundfiles)
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
            gamma = a0*M0;
            dual = {'dual',win};

            c_ori = dgtreal(signal,win,a0,M0,L,flag); % DGT of original
            c_amp = abs(c_ori); % Initialize magnitude
            c_phase = angle(c_ori);

            % Amplitude (random phase)
            c_amp_rec = c_amp .* exp(1i*(c_phase + normrnd(0, 0.1, size(c_amp))));

            %c_amp_pgla = gla(c_amp_pghi,dual,a,M,flag,'fgla','input');

            f_amp_rec = idgtreal(c_amp_rec,dual,a0,M0,flag);

            signal_resampled = resample(signal(M0:end-M0), 48000, fs);
            output_resampled = resample(f_amp_rec(M0:end-M0), 48000, fs);

            audiowrite('test.wav', output_resampled, 48000);
            audiowrite('or.wav', signal_resampled, 48000);

            [odg, movb] = PQevalAudio_fn('or.wav', 'test.wav');
            to_save(index, M0==M, red0==red) = odg;
            
            re_c_amp_rec = abs(dgtreal(f_amp_rec,win_SNR,a_SNR,M_SNR,L,flag));
            re_c_amp = abs(dgtreal(signal,win_SNR,a_SNR,M_SNR,L,flag));

            SNR(index, M0==M, red0==red) = magnitudeerrdb(re_c_amp_rec, re_c_amp);

        end
    end
end
toc


tfrs = (M.^2./(L.*red)')';

plotStats(1, mean(SNR, 1), M, tfrs, 'Objective quality of phaseless reconstruction', 'SC', [-60,6])
plotStats(1, mean(to_save, 1), M, tfrs, 'Subjective quality of phaseless reconstruction', 'PEAQ', [-4,0.5])


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
