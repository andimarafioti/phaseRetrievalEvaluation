clear all

%ltfatstart(); % start the ltfat toolbox
%phaseretstart;

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

M_SNR = 2048;
a_SNR = 128;
win_SNR = {'gauss',a_SNR*M_SNR/L};
win_SNR = gabwin(win_SNR,a_SNR,M_SNR,L);

%% Prepare arrays for results

examples = 2;
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
            c_amp_rec = c_amp .* exp(1i*(c_phase + normrnd(0, 1, size(c_amp))));

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

del_indexes = [];
for index = 1:length(to_save)
    if length(find(isnan(to_save(index, :,  :)))) > 0
        del_indexes(length(del_indexes) + 1) = index;
    end
end
to_save(del_indexes, :, :) = [];


del_indexes_SNR = [];
for index = 1:length(SNR)
    if length(find(isnan(SNR(index, :,  :)))) > 0
        del_indexes_SNR(length(del_indexes_SNR) + 1) = index;
    end
end
SNR(del_indexes_SNR, :, :) = [];



[red_S,M_S] = meshgrid(red, M);

figure(1)
hold on
surf(M_S, red_S, squeeze(mean(to_save, 1)))
xlabel('M')
ylabel('red')
zlabel('PEAQ')

figure(2)

tfrs = (M.^2./(L.*red)')';

means = mean(to_save, 1);
semilogx(tfrs(:, 1), means(1, :, 1), tfrs(:, 2), means(1, :, 2), tfrs(:, 3), means(1, :, 3), tfrs(:, 4), means(1, :, 4), tfrs(:, 5), means(1, :, 5),'LineWidth',5)
hold on
semilogx(M(find(M==512))^2/(L*4), means(1, find(M==512), 4), '*','LineWidth',10, 'Color','black')
text(M(find(M==512))^2/(L*4)+0.3, means(1, find(M==512), 4)+0.04, '\leftarrow M = 512','FontSize',24)

semilogx(M(find(M==1024))^2/(L*16), means(1, find(M==1024), 2), '*','LineWidth',10, 'Color','black')
text(M(find(M==1024))^2/(L*16)+0.25, means(1, find(M==1024), 2)+0.04, '\leftarrow M = 1024','FontSize',24)

xlabel('tfr','FontSize',24)
ylabel('PEAQ','FontSize',24)
legend({'red = 32','red = 16', 'red = 8', 'red = 4', 'red = 2'},'Location','southwest','FontSize',24)
set(gca,'Fontsize',24);
figure(3)
semilogx(M_S(:, 1), means(1, :, 1), M_S(:, 2), means(1, :, 2), M_S(:, 3), means(1, :, 3), M_S(:, 4), means(1, :, 4), M_S(:, 5), means(1, :, 5),'LineWidth',5)
xlabel('M')
ylabel('PEAQ')
legend({'red = 32','red = 16', 'red = 8', 'red = 4', 'red = 2'},'Location','southwest')

figure(4)
stds = std(to_save, 1);
semilogx(tfrs(:, 1), stds(1, :, 1), tfrs(:, 2), stds(1, :, 2), tfrs(:, 3), stds(1, :, 3), tfrs(:, 4), stds(1, :, 4), tfrs(:, 5), stds(1, :, 5),'LineWidth',5)
xlabel('tfr')
ylabel('PEAQ')
legend({'red = 32','red = 16', 'red = 8', 'red = 4', 'red = 2'},'Location','southwest')


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
