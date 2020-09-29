clear all

%ltfatstart(); % start the ltfat toolbox
%phaseretstart;

%% STFT parameters 

L = 2^13 * 3 * 5;

d = 8* propdiv(L/8);

M = d(find(d>=16 & d<L/2));
M = [8 M];

red = [8];
%M=[512, 1024, 2048];

flag = 'timeinv';
M_SNR = 2048;
a_SNR = 128;
win_SNR = {'gauss',a_SNR*M_SNR/L};
win_SNR = gabwin(win_SNR,a_SNR,M_SNR,L);

%% Prepare arrays for results

examples = 3;
SNR_pghi = zeros(examples, length(M), length(red));

%% Reconstruct signals

tic

fs = 22050;
t = 0:1/fs:(L-1)/fs;

% FIRST ALL HARMONIC

harmonics = 64;
harmonic_signal = zeros(1, L);

for harmonic = 1:harmonics
    freq = (harmonic/(harmonics))*(fs/(2));
    harmonic_signal = harmonic_signal + 0.5 * sin(2*pi*t*freq);
end

if max(harmonic_signal) ~= 0
    harmonic_signal = harmonic_signal/max(abs(harmonic_signal));
end
    
SNR_pghi(1, :, :) = analyse(harmonic_signal, red, M, L);

%SECOND mixture harmonics and time

harmonics = 16;

mixed_signal = zeros(1, L);
harmonic_length = L/(harmonics);

harmonic_start = 1;
for harmonic = 1:harmonics
    freq = (harmonic/(harmonics))*(fs/(2));
    mixed_signal(harmonic_start:harmonic_start+harmonic_length-1) = mixed_signal(harmonic_start:harmonic_start+harmonic_length-1) + 0.5 * sin(2*pi*t(harmonic_start:harmonic_start+harmonic_length-1)*freq);
    harmonic_start = harmonic_start + harmonic_length;
end

mixed_signal = mixed_signal/max(abs(mixed_signal));

SNR_pghi(2, :, :) = analyse(mixed_signal, red, M, L);

%THIRD time focused signal

number_of_pulses = 180;
pulse_signal =  zeros(1, L);

pulse_signal(1:int32(L/number_of_pulses):end) = 1;
pulse_signal(2:int32(L/number_of_pulses):end) = 1;

SNR_pghi(3, :, :) = analyse(pulse_signal, red, M, L);


figure(1);

ax1 = subplot(231);
plotdgtreal(dgtreal(harmonic_signal, {'gauss',a_SNR*M_SNR/L}, a_SNR, M_SNR),  a_SNR, M_SNR, fs, 50)
set(gca,'Fontsize',24);

ax2 = subplot(232);
plotdgtreal(dgtreal(mixed_signal, {'gauss',a_SNR*M_SNR/L}, a_SNR, M_SNR),  a_SNR, M_SNR, fs, 50)
set(gca,'Fontsize',24);
ylabel('')
yticklabels('')

ax3 = subplot(233);
plotdgtreal(dgtreal(pulse_signal, {'gauss',a_SNR*M_SNR/L}, a_SNR, M_SNR),  a_SNR, M_SNR, fs, 50)
set(gca,'Fontsize',24);
ylabel('')
yticklabels('')


tfrs = (M.^2./(L.*red)')';

ax4 = subplot(234);
semilogx(tfrs, -SNR_pghi(1, :, :),'LineWidth',3)
set(gca,'Fontsize',24);
ylim([5, 100])
xlim([5e-5, 2000])
xlabel('\lambda','FontSize',24)
ylabel('SC','FontSize',24)
set(gca,'xtick',[1e-3, 1e0, 2e3], 'xticklabels', {'1e-3', '1e0', '2e3'})

ax5 = subplot(235);
semilogx(tfrs, -SNR_pghi(2, :, :),'LineWidth',3)
set(gca,'Fontsize',24);
ylim([5, 100])
xlim([5e-5, 2000])
xlabel('\lambda','FontSize',24)
set(gca,'ytick',[-100, -50, 0], 'yticklabels', [])
set(gca,'xtick',[1e-3, 1e0, 2e3], 'xticklabels', {'1e-3', '1e0', '2e3'})

ax6 = subplot(236);
semilogx(tfrs, -SNR_pghi(3, :, :),'LineWidth',3)
set(gca,'Fontsize',24);
ylim([5, 100])
xlim([5e-5, 2000])
xlabel('\lambda','FontSize',24)
% ylabel('SC','FontSize',24)
yticklabels('')
set(gca,'xtick',[1e-3, 1e0, 2e3], 'xticklabels', {'1e-3', '1e0', '2e3'})

% for k = 1:examples
% k
% semilogx(M, SNR_pghi(k, :, :))
% ylim([-180, 0])
% xlim([5, 10500])
% pause(5)
% end


function SNR_pghi = analyse(test_signal, red, M, L)
flag = 'timeinv';
M_SNR = 2048;
a_SNR = 128;
win_SNR = {'gauss',a_SNR*M_SNR/L};
win_SNR = gabwin(win_SNR,a_SNR,M_SNR,L);

SNR_pghi =  zeros(length(M), length(red));

for M0 = M
    for red0 = red
        a0 = M0 / red0;

        win = {'gauss',a0*M0/L};
        win = gabwin(win,a0,M0,L);
        gamma = a0*M0; 
        dual = {'dual',win};

        c_ori = dgtreal(test_signal,win,a0,M0,L,flag); % DGT of original
        c_amp = abs(c_ori); % Initialize magnitude

        % PGHI
        c_amp_pghi = pghi(c_amp,gamma,a0,M0,flag, 'tol', 1e-7);
        f_amp_pghi = idgtreal(c_amp_pghi,dual,a0,M0,flag);

        % Measure spectral divergence

        re_c_amp = abs(dgtreal(test_signal,win_SNR,a_SNR,M_SNR,L,flag));
        re_c_amp_pghi = abs(dgtreal(f_amp_pghi,win_SNR,a_SNR,M_SNR,L,flag));

        SNR_pghi(M0==M, red0==red) = magnitudeerrdb(re_c_amp_pghi, re_c_amp);
    end
end

end
    
