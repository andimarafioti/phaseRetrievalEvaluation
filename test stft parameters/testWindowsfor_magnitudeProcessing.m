
addpath('utils', genpath('ltfat'), genpath('phaseret'), 'test stft parameters', genpath('PEASS-Software-v2.0.1'), genpath('PEAQ'))

%ltfatstart(); % start the ltfat toolboxphaseretstart;

%%
% base_folder = '\\kfsnas08\Denklast\amarafioti\Documents\Datasets\Lakh\new-simple-piano\';
% soundfiles = dir(base_folder);
% soundfiles = soundfiles(4:end);

base_folder = 'LJSpeech-1.1/wavs/';
soundfiles = dir(base_folder);
soundfiles = soundfiles(3:end);

git ad
%% STFT parameters 

L = 2^13 * 3 * 5;

d = 32* propdiv(L/32);

M = d(find(d>=64 & d<L/2));
M = [32 M];
M = M(1:end);
%red = [32, 8, 2];

%red = [4,16];
%M=[512, 1024, 2048];
flag = 'timeinv';

%% Prepare arrays for results

examples = 1;
to_save_peaq_real = zeros(examples, length(M), length(red));
to_save_pemoq_real = zeros(examples, length(M), length(red));
SNR_real = zeros(examples, length(M), length(red));

to_save_peaq_pghi = zeros(examples, length(M), length(red));
to_save_pemoq_pghi = zeros(examples, length(M), length(red));
SNR_pghi = zeros(examples, length(M), length(red));

to_save_peaq_fgla = zeros(examples, length(M), length(red));
to_save_pemoq_fgla = zeros(examples, length(M), length(red));
SNR_fgla = zeros(examples, length(M), length(red));

to_save_peaq_spsi = zeros(examples, length(M), length(red));
to_save_pemoq_spsi = zeros(examples, length(M), length(red));
SNR_spsi = zeros(examples, length(M), length(red));


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

            % Consistent amplitude processing
            
            tf_signal = fft(signal, L);
            
            t = linspace(0, L/fs/2, L/2+1);
            filter = 0.1 + cos(2*pi*5*t);
            filter(filter<0.1) = 0.1;
            filter(filter>1) = 1;
            filter = [filter fliplr(filter(2:end-1))];
            
            filtered_signal = ifft(tf_signal.*filter.', L);
            
            % Inconsistent amplitude processing (real phase)
            sampled_filterbank = filter(1:L/M0:end/2+1).';

            c_ori = dgtreal(signal,win,a0,M0,L,flag); % DGT of original
            c_amp = abs(c_ori); % Initialize magnitude
            c_phase = angle(c_ori);
            
            c_ori_proc = c_ori.*sampled_filterbank;
            f_amp_rec = idgtreal(c_ori_proc,dual,a0,M0,flag);
          
            % Inconsistent amplitude processing (PGHI)
            c_amp_pghi = pghi(c_amp.*sampled_filterbank,gamma,a0,M0,flag, 'tol', 1e-7);
            f_amp_pghi = idgtreal(c_amp_pghi,dual,a0,M0,flag);

            % Inconsistent amplitude processing (FGLA)
            [c_rec_gla,f_rec_gla] = gla(c_amp.*sampled_filterbank,win,a0,M0,'fgla');

            % Inconsistent amplitude processing (SPSI)
            c_amp_spsi = spsi(c_amp.*sampled_filterbank,a0,M0,flag);
            f_amp_spsi = idgtreal(c_amp_spsi,dual,a0,M0,flag);

            % Measure similarity
            [SNR, PEAQ, PEMOQ] = measureSimilarity(filtered_signal, f_amp_rec, fs, M0, L);          
            to_save_peaq_real(index, M0==M, red0==red) = PEAQ;
            to_save_pemoq_real(index, M0==M, red0==red) = PEMOQ;
            SNR_real(index, M0==M, red0==red) = SNR;

            [SNR, PEAQ, PEMOQ] = measureSimilarity(filtered_signal, f_amp_pghi, fs, M0, L);          
            to_save_peaq_pghi(index, M0==M, red0==red) = PEAQ;
            to_save_pemoq_pghi(index, M0==M, red0==red) = PEMOQ;
            SNR_pghi(index, M0==M, red0==red) = SNR;

            [SNR, PEAQ, PEMOQ] = measureSimilarity(filtered_signal, f_rec_gla, fs, M0, L);          
            to_save_peaq_fgla(index, M0==M, red0==red) = PEAQ;
            to_save_pemoq_fgla(index, M0==M, red0==red) = PEMOQ;
            SNR_fgla(index, M0==M, red0==red) = SNR;
 
            [SNR, PEAQ, PEMOQ] = measureSimilarity(filtered_signal, f_amp_spsi, fs, M0, L);          
            to_save_peaq_spsi(index, M0==M, red0==red) = PEAQ;
            to_save_pemoq_spsi(index, M0==M, red0==red) = PEMOQ;
            SNR_spsi(index, M0==M, red0==red) = SNR;
            toc
        end
    end
    save(strcat("magnitudeProcessingTest-red", num2str(red), ".mat"), "to_save_peaq_real", "to_save_pemoq_real", "SNR_real", "to_save_peaq_pghi", "to_save_pemoq_pghi", "SNR_pghi", "to_save_peaq_fgla", "to_save_pemoq_fgla", "SNR_fgla", "to_save_peaq_spsi", "to_save_pemoq_spsi", "SNR_spsi", "M", "L")
end
toc


tfrs = (M.^2./(L.*red)')';

plotStats(1, mean(SNR_real, 1), tfrs, 'Real phase SNR_{MS}', [0,60])
plotStats(2, mean(to_save_peaq_real, 1), tfrs, 'Real phase PEAQ', [-4,0.5])
plotStats(3, mean(to_save_pemoq_real, 1), tfrs, 'Real phase PEMO-Q', [-4,0.5])

plotStats(4, mean(SNR_pghi, 1), tfrs, 'PGHI SNR_{MS}', [0,60])
plotStats(5, mean(to_save_peaq_pghi, 1), tfrs, 'PGHI PEAQ', [-4,0.5])
plotStats(6, mean(to_save_pemoq_pghi, 1), tfrs, 'PGHI PEMO-Q', [-4,0.5])

plotStats(7, mean(SNR_fgla, 1), tfrs, 'FGLA SNR_{MS}', [0,60])
plotStats(8, mean(to_save_peaq_fgla, 1), tfrs, 'FGLA PEAQ', [-4,0.5])
plotStats(9, mean(to_save_pemoq_fgla, 1), tfrs, 'FGLA PEMO-Q', [-4,0.5])

plotStats(10, mean(SNR_spsi, 1), tfrs, 'SPSI SNR_{MS}', [0,60])
plotStats(11, mean(to_save_peaq_spsi, 1), tfrs, 'SPSI PEAQ', [-4,0.5])
plotStats(12, mean(to_save_pemoq_spsi, 1), tfrs, 'SPSI PEMO-Q', [-4,0.5])

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
