function [ODG, SC]= evalPGHIOnFolder(soundfiles, M, red, L)

%% STFT parameters 
flag = 'timeinv';

M_SNR = 2048;
a_SNR = 128;
win_SNR = {'gauss',a_SNR*M_SNR/L};
win_SNR = gabwin(win_SNR,a_SNR,M_SNR,L);
%% Prepare arrays for results

ODG = zeros(1, length(M), length(red));
SC = zeros(1, length(M), length(red));

%% Reconstruct signals


for index = 1:length(soundfiles)
    [signal, fs] = audioread(strcat(soundfiles(index).folder, '\', soundfiles(index).name));
    signal = resample(signal, 22050, fs);
    fs = 22050;

    if length(signal) < L
        continue
    end
    SC(size(SC, 1)+1, :, :) = 0;
    ODG(size(ODG, 1)+1,  :, :) = 0;
   
    signal = signal(1:L, 1);

    for M0 = M
        for red0 = red
            a0 = M0 / red0;

            win = {'gauss',a0*M0/L};
            win = gabwin(win,a0,M0,L);
            gamma = a0*M0;
            dual = {'dual',win};

            c_ori = dgtreal(signal,win,a0,M0,L,flag); % DGT of original
            c_amp = abs(c_ori); % Initialize magnitude

            % PGHI
            c_amp_pghi = pghi(c_amp,gamma,a0,M0,flag, 'tol', 1e-7);
            f_amp_pghi = idgtreal(c_amp_pghi,dual,a0,M0,flag);

            % Measure PEAQ
            signal_resampled = resample(signal(M0:end-M0), 48000, fs);
            pghi_resampled = resample(f_amp_pghi(M0:end-M0), 48000, fs);

            audiowrite('or.wav', signal_resampled, 48000);
            audiowrite('pghi.wav', pghi_resampled, 48000);

            [odg, movb] = PQevalAudio_fn('or.wav', 'pghi.wav');
            ODG(size(ODG, 1), M0==M, red0==red) = odg;
            
            % Measure spectral divergence

            re_c_amp = abs(dgtreal(signal,win_SNR,a_SNR,M_SNR,L,flag));
            re_c_amp_pghi = abs(dgtreal(f_amp_pghi,win_SNR,a_SNR,M_SNR,L,flag));

            SC(size(SC, 1), M0==M, red0==red) = magnitudeerrdb(re_c_amp_pghi, re_c_amp);

        end
    end
end

SC = SC(2:end, :, :);
ODG = ODG(2:end, :, :);

end
