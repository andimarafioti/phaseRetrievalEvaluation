function [ODG_FGLA, SC_FGLA]= evalFGLAOnFolder(soundfiles, M, red, L)

%% STFT parameters 
flag = 'timeinv';

M_SNR = 2048;
a_SNR = 128;
win_SNR = {'gauss',a_SNR*M_SNR/L};
win_SNR = gabwin(win_SNR,a_SNR,M_SNR,L);
%% Prepare arrays for results

ODG_FGLA = zeros(1, length(M), length(red));
SC_FGLA = zeros(1, length(M), length(red));

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
    SC_FGLA(size(SC_FGLA, 1)+1, :, :) = 0;
    ODG_FGLA(size(ODG_FGLA, 1)+1,  :, :) = 0;
    
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

            % FGLA
            [c_rec_gla,f_rec_gla] = gla(c_amp,win,a0,M0,'fgla');

            % Measure PEAQ
            signal_resampled = resample(signal(M0:end-M0), 48000, fs);
            fgla_resampled = resample(f_rec_gla(M0:end-M0), 48000, fs);

            audiowrite('or_eval.wav', signal_resampled, 48000);
            audiowrite('fgla_eval.wav', fgla_resampled, 48000);

            [odg, movb] = PQevalAudio_fn('or_eval.wav', 'fgla_eval.wav');
            ODG_FGLA(size(ODG_FGLA, 1), M0==M, red0==red) = odg;

            % Measure spectral divergence

            re_c_amp = abs(dgtreal(signal,win_SNR,a_SNR,M_SNR,L,flag));
            re_c_amp_fgla = abs(dgtreal(f_rec_gla,win_SNR,a_SNR,M_SNR,L,flag));

            SC_FGLA(size(SC_FGLA, 1), M0==M, red0==red) = magnitudeerrdb(re_c_amp_fgla, re_c_amp);
            
        end
    end
end

SC_FGLA = SC_FGLA(2:end, :, :);
ODG_FGLA = ODG_FGLA(2:end, :, :);

end
