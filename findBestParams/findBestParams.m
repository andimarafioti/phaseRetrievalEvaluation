function [bestMs, bestDs]= findBestParams(phaseretfunc, array_of_signal_paths, Ms, Ds, L, odg_threshold, SNR_threshold)

ODGs = zeros(length(array_of_signal_paths), length(Ms), length(Ds));
SNRs_ms = zeros(size(ODGs));

M_SNR = 2048;
a_SNR = 128;
win_SNR = {'gauss',a_SNR*M_SNR/L};
win_SNR = gabwin(win_SNR,a_SNR,M_SNR,L);

for signal_path = array_of_signal_paths
   [signal, sr] = audioread(signal_path);
   
   if length(signal) < L
        continue
   end
   
   signal = signal(1:L);

   for M0 = Ms
        for D = Ds
            
            a0 = M0 / D;
            
            win = {'gauss',a0*M0/L};
            win = gabwin(win,a0,M0,L);
            dual = {'dual',win};

            c_ori = dgtreal(signal,win,a0,M0,L,flag); % DGT of original
            c_amp = abs(c_ori); % Initialize magnitude

            % phase ret
            c_amp_phase_ret = phaseretfunc(c_amp,a0,M0);
            f_amp_phase_ret = idgtreal(c_amp_phase_ret,dual,a0,M0,flag);

            % Measure PEAQ
            signal_resampled = resample(signal(M0:end-M0), 48000, fs);
            phase_ret_resampled = resample(f_amp_phase_ret(M0:end-M0), 48000, fs);

            audiowrite('or_findBestParams.wav', signal_resampled, 48000);
            audiowrite('phaseret_findBestParams.wav', phase_ret_resampled, 48000);

            [odg, movb] = PQevalAudio_fn('or_findBestParams.wav', 'phaseret_findBestParams.wav');
            ODGs(index, M0==Ms, D==Ds) = odg;
            
            % Measure spectral divergence

            re_c_amp = abs(dgtreal(signal,win_SNR,a_SNR,M_SNR,L,flag));
            re_c_amp_phase_ret= abs(dgtreal(f_amp_phase_ret,win_SNR,a_SNR,M_SNR,L,flag));

            SNRs_ms(index, M0==Ms, D==Ds) = magnitudeerrdb(re_c_amp_phase_ret, re_c_amp);

        end
    end
end
 
mean_ODGs = mean(ODGs, 1);
max_ODGs = max(mean_ODGs);
% good_ODGs = mean_ODGs(mean_ODGs > max_ODGs-odg_threshold);

mean_SNRs_ms = mean(SNRs_ms, 1);
min_SNRs_ms = min(mean_SNRs_ms);
% good_SNRs_ms = mean_SNRs_ms(mean_SNRs_ms < min_SNRs_ms + SNR_threshold);

good_on_both_measures = find((mean_ODGs > max_ODGs-odg_threshold) & (mean_SNRs_ms < min_SNRs_ms + SNR_threshold));

rep_M = repmat(Ms, [length(Ms), length(Ds)]);
rep_Ds = repmat(Ds, [length(Ms), length(Ds)]);

bestMs = nonzeros(rep_M(good_on_both_measures));
bestDs = nonzeros(rep_Ds(good_on_both_measures));

end