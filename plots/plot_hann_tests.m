colors = [[0, 0.4470, 0.7410]; [0.8500, 0.3250, 0.0980]; [0.9290, 0.6940, 0.1250]; [0.4940, 0.1840, 0.5560]; [0.4660, 0.6740, 0.1880]];
line_styles = { '-','-.','--',':'};

sr = 22050;

f1 = figure(1);
set(f1, 'Position', [0 0 750 1000])

hold on
set(gca, 'XScale', 'log');

load('new_pghi_gla_ljspeech.mat')
load('new_spsi_ljspeech.mat')

gauss_odg_pghi = mean(to_save_peaq_pghi, 1);
tfrs = (M.^2./(sr.*red)')';

for index = 1:2:5
        semilogx(tfrs(:, index), gauss_odg_pghi(:, :, index), 'LineWidth',9, 'LineStyle', line_styles{1}, 'Color', colors(index, :))
end

load('blackman_ljspeech.mat')
blackman_odg_pghi = mean(to_save_pghi, 1);
tfrs = (M.^2./(sr.*red)')';

for index = 1:2:5
        semilogx(tfrs(:, index), blackman_odg_pghi(:, :, index), 'LineWidth',9, 'LineStyle', line_styles{2}, 'Color', colors(index, :))
end


load('hann_ljspeech.mat')
hann_odg_pghi = mean(to_save_pghi, 1);
tfrs = (M.^2./(sr.*red)')';

for index = 1:2:5
        semilogx(tfrs(:, index), hann_odg_pghi(:, :, index), 'LineWidth',9, 'LineStyle', line_styles{3}, 'Color', colors(index, :))
end

load('bartlett_ljspeech.mat')
bartlett_odg_pghi = mean(to_save_pghi, 1);
tfrs = (M.^2./(sr.*red)')';

for index = 1:2:5
        semilogx(tfrs(:, index), bartlett_odg_pghi(:, :, index), 'LineWidth',9, 'LineStyle', line_styles{4}, 'Color', colors(index, :))
end


xlim([1e-3, 2e4])
set(gca, 'XTick', [1e-3,1e-1,1e1,1e3])

ylim([-4, 0.5])
xlabel('\lambda','FontSize',48)
ylabel("ODG",'FontSize',48)
title("PGHI",'FontSize',48)

set(gca,'Fontsize',48);

% hold off
box on
exportgraphics(f1, "windows_ODG_PGHI.png")

%%
f2 = figure(2);
set(f2, 'Position', [0 0 750 1000])

hold on
set(gca, 'XScale', 'log');

load('new_pghi_gla_ljspeech.mat')
load('new_spsi_ljspeech.mat')

gauss_odg_fgla = mean(to_save_peaq_gla, 1);
tfrs = (M.^2./(sr.*red)')';

for index = 3:2:5
        semilogx(tfrs(:, index), gauss_odg_fgla(:, :, index), 'LineWidth',9, 'LineStyle', line_styles{1}, 'Color', colors(index, :))
end

load('blackman_ljspeech.mat')
blackman_odg_fgla = mean(to_save_gla, 1);
tfrs = (M.^2./(sr.*red)')';

for index = 3:2:5
        semilogx(tfrs(:, index), blackman_odg_fgla(:, :, index), 'LineWidth',9, 'LineStyle', line_styles{2}, 'Color', colors(index, :))
end


load('hann_ljspeech.mat')
hann_odg_fgla = mean(to_save_gla, 1);
tfrs = (M.^2./(sr.*red)')';

for index = 3:2:5
        semilogx(tfrs(:, index), hann_odg_fgla(:, :, index), 'LineWidth',9, 'LineStyle', line_styles{3}, 'Color', colors(index, :))
end

load('bartlett_ljspeech.mat')
bartlett_odg_fgla = mean(to_save_gla, 1);
tfrs = (M.^2./(sr.*red)')';

for index = 3:2:5
        semilogx(tfrs(:, index), bartlett_odg_fgla(:, :, index), 'LineWidth',9, 'LineStyle', line_styles{4}, 'Color', colors(index, :))
end


xlim([1e-3, 2e4])
set(gca, 'XTick', [1e-3,1e-1,1e1,1e3])

ylim([-4, 0.5])
xlabel('\lambda','FontSize',48)
%ylabel("ODG",'FontSize',48)
title("FGLA",'FontSize',48)

set(gca,'Fontsize',48);

% hold off

box on
exportgraphics(f2, "windows_ODG_FGLA.png")

%%
f3 = figure(3);
set(f3, 'Position', [0 0 750 1000])

hold on
set(gca, 'XScale', 'log');


plot(NaN,NaN,line_styles{1},'LineWidth',10, 'Color', colors(3, :),'LineWidth',4);
plot(NaN,NaN,line_styles{2},'LineWidth',10, 'Color', colors(3, :),'LineWidth',4);
plot(NaN,NaN,line_styles{3},'LineWidth',10, 'Color', colors(3, :),'LineWidth',4);
plot(NaN,NaN,line_styles{4},'LineWidth',10, 'Color', colors(3, :),'LineWidth',4);

load('new_pghi_gla_ljspeech.mat')
load('new_spsi_ljspeech.mat')

gauss_odg_spsi = mean(to_save_spsi, 1);
tfrs = (M.^2./(sr.*red)')';

for index = 3
        semilogx(tfrs(:, index), gauss_odg_spsi(:, :, index), 'LineWidth',9, 'LineStyle', line_styles{1}, 'Color', colors(index, :))
end

load('blackman_ljspeech.mat')
blackman_odg_spsi = mean(to_save_spsi, 1);
tfrs = (M.^2./(sr.*red)')';

for index = 3
        semilogx(tfrs(:, index), blackman_odg_spsi(:, :, index), 'LineWidth',9, 'LineStyle', line_styles{2}, 'Color', colors(index, :))
end


load('hann_ljspeech.mat')
hann_odg_spsi = mean(to_save_spsi, 1);
tfrs = (M.^2./(sr.*red)')';

for index = 3
        semilogx(tfrs(:, index), hann_odg_spsi(:, :, index), 'LineWidth',9, 'LineStyle', line_styles{3}, 'Color', colors(index, :))
end

load('bartlett_ljspeech.mat')
bartlett_odg_spsi= mean(to_save_spsi, 1);
tfrs = (M.^2./(sr.*red)')';

for index = 3
        semilogx(tfrs(:, index), bartlett_odg_spsi(:, :, index), 'LineWidth',9, 'LineStyle', line_styles{4}, 'Color', colors(index, :))
end


xlim([1e-3, 2e4])
set(gca, 'XTick', [1e-3,1e-1,1e1,1e3])

ylim([-4, 0.5])
xlabel('\lambda','FontSize',48)
%ylabel("ODG",'FontSize',48)
title("SPSI",'FontSize',48)

set(gca,'Fontsize',48);

% hold off
legend({'gauss','Blackman', 'Hann', 'Bartlett'},'Location','northeast','FontSize',48)

box on
exportgraphics(f3, "windows_ODG_SPSI.png")

%%

f4 = figure(4);
set(f4, 'Position', [0 0 750 1000])

hold on
set(gca, 'XScale', 'log');

load('new_pghi_gla_ljspeech.mat')
load('new_spsi_ljspeech.mat')

gauss_snr_pghi = -mean(SNR_pghi, 1);
tfrs = (M.^2./(sr.*red)')';

for index = 1:2:5
        semilogx(tfrs(:, index), gauss_snr_pghi(:, :, index), 'LineWidth',9, 'LineStyle', line_styles{1}, 'Color', colors(index, :))
end

load('blackman_ljspeech.mat')
blackman_snr_pghi = -mean(SNR_pghi, 1);
tfrs = (M.^2./(sr.*red)')';

for index = 1:2:5
        semilogx(tfrs(:, index), blackman_snr_pghi(:, :, index), 'LineWidth',9, 'LineStyle', line_styles{2}, 'Color', colors(index, :))
end


load('hann_ljspeech.mat')
hann_snr_pghi = -mean(SNR_pghi, 1);
tfrs = (M.^2./(sr.*red)')';

for index = 1:2:5
        semilogx(tfrs(:, index), hann_snr_pghi(:, :, index), 'LineWidth',9, 'LineStyle', line_styles{3}, 'Color', colors(index, :))
end

load('bartlett_ljspeech.mat')
bartlett_snr_pghi = -mean(SNR_pghi, 1);
tfrs = (M.^2./(sr.*red)')';

for index = 1:2:5
        semilogx(tfrs(:, index), bartlett_snr_pghi(:, :, index), 'LineWidth',9, 'LineStyle', line_styles{4}, 'Color', colors(index, :))
end


xlim([1e-3, 2e4])
set(gca, 'XTick', [1e-3,1e-1,1e1,1e3])

ylim([0, 60])
xlabel('\lambda','FontSize',48)
ylabel("SNR_{MS}",'FontSize',48)
title("PGHI",'FontSize',48)

set(gca,'Fontsize',48);

% hold off
box on
exportgraphics(f4, "windows_SNR_PGHI.png")
%%
f5 = figure(5);
set(f5, 'Position', [0 0 750 1000])

hold on
set(gca, 'XScale', 'log');

load('new_pghi_gla_ljspeech.mat')
load('new_spsi_ljspeech.mat')

gauss_snr_fgla = -mean(SNR_gla, 1);
tfrs = (M.^2./(sr.*red)')';

for index = 3:2:5
        semilogx(tfrs(:, index), gauss_snr_fgla(:, :, index), 'LineWidth',9, 'LineStyle', line_styles{1}, 'Color', colors(index, :))
end

load('blackman_ljspeech.mat')
blackman_snr_fgla = -mean(SNR_gla, 1);
tfrs = (M.^2./(sr.*red)')';

for index = 3:2:5
        semilogx(tfrs(:, index), blackman_snr_fgla(:, :, index), 'LineWidth',9, 'LineStyle', line_styles{2}, 'Color', colors(index, :))
end


load('hann_ljspeech.mat')
hann_snr_fgla = -mean(SNR_gla, 1);
tfrs = (M.^2./(sr.*red)')';

for index = 3:2:5
        semilogx(tfrs(:, index), hann_snr_fgla(:, :, index), 'LineWidth',9, 'LineStyle', line_styles{3}, 'Color', colors(index, :))
end

load('bartlett_ljspeech.mat')
bartlett_snr_fgla = -mean(SNR_gla, 1);
tfrs = (M.^2./(sr.*red)')';

for index = 3:2:5
        semilogx(tfrs(:, index), bartlett_snr_fgla(:, :, index), 'LineWidth',9, 'LineStyle', line_styles{4}, 'Color', colors(index, :))
end


xlim([1e-3, 2e4])
set(gca, 'XTick', [1e-3,1e-1,1e1,1e3])

ylim([0, 60])
xlabel('\lambda','FontSize',48)
%ylabel("SNR_{MS}",'FontSize',48)
title("FGLA",'FontSize',48)

set(gca,'Fontsize',48);

% hold off

box on
exportgraphics(f5, "windows_SNR_FGLA.png")

%%
f6 = figure(6);
set(f6, 'Position', [0 0 750 1000])

hold on
set(gca, 'XScale', 'log');


plot(NaN,NaN,line_styles{1},'LineWidth',10, 'Color', colors(3, :),'LineWidth',4);
plot(NaN,NaN,line_styles{2},'LineWidth',10, 'Color', colors(3, :),'LineWidth',4);
plot(NaN,NaN,line_styles{3},'LineWidth',10, 'Color', colors(3, :),'LineWidth',4);
plot(NaN,NaN,line_styles{4},'LineWidth',10, 'Color', colors(3, :),'LineWidth',4);

load('new_pghi_gla_ljspeech.mat')
load('new_spsi_ljspeech.mat')

gauss_odg_spsi = -mean(SNR_spsi, 1);
tfrs = (M.^2./(sr.*red)')';

for index = 3
        semilogx(tfrs(:, index), gauss_odg_spsi(:, :, index), 'LineWidth',9, 'LineStyle', line_styles{1}, 'Color', colors(index, :))
end

load('blackman_ljspeech.mat')
blackman_odg_spsi = -mean(SNR_spsi, 1);
tfrs = (M.^2./(sr.*red)')';

for index = 3
        semilogx(tfrs(:, index), blackman_odg_spsi(:, :, index), 'LineWidth',9, 'LineStyle', line_styles{2}, 'Color', colors(index, :))
end


load('hann_ljspeech.mat')
hann_odg_spsi = -mean(SNR_spsi, 1);
tfrs = (M.^2./(sr.*red)')';

for index = 3
        semilogx(tfrs(:, index), hann_odg_spsi(:, :, index), 'LineWidth',9, 'LineStyle', line_styles{3}, 'Color', colors(index, :))
end

load('bartlett_ljspeech.mat')
bartlett_odg_spsi= -mean(SNR_spsi, 1);
tfrs = (M.^2./(sr.*red)')';

for index = 3
        semilogx(tfrs(:, index), bartlett_odg_spsi(:, :, index), 'LineWidth',9, 'LineStyle', line_styles{4}, 'Color', colors(index, :))
end


xlim([1e-3, 2e4])
set(gca, 'XTick', [1e-3,1e-1,1e1,1e3])

ylim([0, 60])
xlabel('\lambda','FontSize',48)
%ylabel("ODG",'FontSize',48)
title("SPSI",'FontSize',48)

set(gca,'Fontsize',48);

% hold off
legend({'gauss','Blackman', 'Hann', 'Bartlett'},'Location','northeast','FontSize',48)

box on
exportgraphics(f6, "windows_SNR_SPSI.png")
