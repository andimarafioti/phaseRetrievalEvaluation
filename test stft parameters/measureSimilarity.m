function [SNR, PEAQ, PEMOQ] = measureSimilarity(ref, signal, fs, M0, L)
            % Measure PEAQ
            ref48k = resample(ref(M0:end-M0), 48000, fs);
            signal48k = resample(signal(M0:end-M0), 48000, fs);
            
            audiowrite('ref.wav', ref48k, 48000);
            audiowrite('signal.wav', signal48k, 48000);
            [PEAQ, movb] = PQevalAudio_fn('ref.wav', 'signal.wav');
            
            % Measure PEMO-Q
            [m_rec,fr] = pemo_internal(signal(M0:end-M0), fs, "fb");
            m_ref = pemo_internal(ref(M0:end-M0), fs, "fb");
            PSMt = pemo_metric(m_ref,m_rec,fr);
            PEMOQ = psmt2pemoq(PSMt);

            % Measure spectral divergence
            flag = 'timeinv';
            M_SNR = 2048;
            a_SNR = 128;
            win_SNR = {'gauss',a_SNR*M_SNR/L};
            win_SNR = gabwin(win_SNR,a_SNR,M_SNR,L);           
            re_c_amp_rec = abs(dgtreal(signal,win_SNR,a_SNR,M_SNR,L,flag));
            re_c_ref = abs(dgtreal(ref,win_SNR,a_SNR,M_SNR,L,flag));
            SNR = - magnitudeerrdb(re_c_amp_rec, re_c_ref);
