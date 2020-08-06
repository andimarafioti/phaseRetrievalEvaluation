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

%red = [4, 8, 16];
%M=[512, 1024, 2048];
flag = 'timeinv';

M1_SNR = 2048;
a1_SNR = 128;
win1_SNR = {'gauss',a1_SNR*M1_SNR/L};
win1_SNR = gabwin(win1_SNR,a1_SNR,M1_SNR,L);

M2_SNR = 1024;
a2_SNR = 64;
win2_SNR = {'gauss',a2_SNR*M2_SNR/L};
win2_SNR = gabwin(win2_SNR,a2_SNR,M2_SNR,L);

M3_SNR = 512;
a3_SNR = 32;
win3_SNR = {'gauss',a3_SNR*M3_SNR/L};
win3_SNR = gabwin(win3_SNR,a3_SNR,M3_SNR,L);

%% Prepare arrays for results

examples = 16;
SNR1 = zeros(examples, length(M), length(red));
SNR2 = zeros(examples, length(M), length(red));
SNR3 = zeros(examples, length(M), length(red));

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
            
            re_c_amp_rec = abs(dgtreal(f_amp_rec,win1_SNR,a1_SNR,M1_SNR,L,flag));
            re_c_amp = abs(dgtreal(signal,win1_SNR,a1_SNR,M1_SNR,L,flag));

            SNR1(index, M0==M, red0==red) = magnitudeerrdb(re_c_amp_rec, re_c_amp);

            re_c_amp_rec = abs(dgtreal(f_amp_rec,win2_SNR,a2_SNR,M2_SNR,L,flag));
            re_c_amp = abs(dgtreal(signal,win2_SNR,a2_SNR,M2_SNR,L,flag));

            SNR2(index, M0==M, red0==red) = magnitudeerrdb(re_c_amp_rec, re_c_amp);

            re_c_amp_rec = abs(dgtreal(f_amp_rec,win3_SNR,a3_SNR,M3_SNR,L,flag));
            re_c_amp = abs(dgtreal(signal,win3_SNR,a3_SNR,M3_SNR,L,flag));

            SNR3(index, M0==M, red0==red) = magnitudeerrdb(re_c_amp_rec, re_c_amp);

        end
    end
end
toc

tfrs = (M.^2./(L.*red)')';

plotStats(1, mean(SNR1, 1), M, tfrs, 'Objective quality of phaseless reconstruction', 'SC random 2048-128', [-60,6])
plotStats(2, mean(SNR2, 1), M, tfrs, 'Objective quality of phaseless reconstruction', 'SC random 1024-64', [-60,6])
plotStats(3, mean(SNR3, 1), M, tfrs, 'Objective quality of phaseless reconstruction', 'SC random 512-32', [-60,6])



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