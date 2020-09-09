function [ODG_PGHI, SC_PGHI, ODG_SPSI, SC_SPSI]= evalPGHIOnFolder(soundfiles, M, red, L)

%% STFT parameters 
flag = 'timeinv';

M_SNR = 2048;
a_SNR = 128;
win_SNR = {'gauss',a_SNR*M_SNR/L};
win_SNR = gabwin(win_SNR,a_SNR,M_SNR,L);
%% Prepare arrays for results

ODG_PGHI = zeros(1, length(M), length(red));
SC_PGHI = zeros(1, length(M), length(red));

ODG_SPSI = zeros(1, length(M), length(red));
SC_SPSI = zeros(1, length(M), length(red));

%% Reconstruct signals


for index = 1:length(soundfiles)
    try
        [signal, fs] = audioread(strcat(soundfiles(index).folder, '\', soundfiles(index).name));
    catch
        continue
    end
    signal = resample(signal, 22050, fs);
    fs = 22050;

    if length(signal) < L
        continue
    end
    SC_PGHI(size(SC_PGHI, 1)+1, :, :) = 0;
    ODG_PGHI(size(ODG_PGHI, 1)+1,  :, :) = 0;
    SC_SPSI(size(SC_SPSI, 1)+1, :, :) = 0;
    ODG_SPSI(size(ODG_SPSI, 1)+1,  :, :) = 0;
   
    signal = signal(1:L, 1);
    
    if max(abs(signal)) > 1
        signal = signal/max(abs(signal));
    end

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

            % SPSI
            c_amp_spsi = spsi(c_amp,a0,M0,flag);
            f_amp_spsi = idgtreal(c_amp_spsi,dual,a0,M0,flag);

            % Measure PEAQ
            signal_resampled = resample(signal(M0:end-M0), 48000, fs);
            pghi_resampled = resample(f_amp_pghi(M0:end-M0), 48000, fs);
            spsi_resampled = resample(f_amp_spsi(M0:end-M0), 48000, fs);

            audiowrite('or_eval.wav', signal_resampled, 48000);
            audiowrite('pghi_eval.wav', pghi_resampled, 48000);
            audiowrite('spsi_eval.wav', spsi_resampled, 48000);

            [odg, movb] = PQevalAudio_fn('or_eval.wav', 'pghi_eval.wav');
            ODG_PGHI(size(ODG_PGHI, 1), M0==M, red0==red) = odg;

            [odg, movb] = PQevalAudio_fn('or_eval.wav', 'spsi_eval.wav');
            ODG_SPSI(size(ODG_SPSI, 1), M0==M, red0==red) = odg;

            % Measure spectral divergence

            re_c_amp = abs(dgtreal(signal,win_SNR,a_SNR,M_SNR,L,flag));
            re_c_amp_pghi = abs(dgtreal(f_amp_pghi,win_SNR,a_SNR,M_SNR,L,flag));
            re_c_amp_spsi = abs(dgtreal(f_amp_spsi,win_SNR,a_SNR,M_SNR,L,flag));

            SC_PGHI(size(SC_PGHI, 1), M0==M, red0==red) = magnitudeerrdb(re_c_amp_pghi, re_c_amp);
            SC_SPSI(size(SC_SPSI, 1), M0==M, red0==red) = magnitudeerrdb(re_c_amp_spsi, re_c_amp);

        end
    end
end

SC_PGHI = SC_PGHI(2:end, :, :);
ODG_PGHI = ODG_PGHI(2:end, :, :);
SC_SPSI = SC_SPSI(2:end, :, :);
ODG_SPSI = ODG_SPSI(2:end, :, :);

end
