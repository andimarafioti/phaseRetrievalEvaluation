red = [32, 16, 8, 4, 2];

L = 2^13 * 3 * 5;

d = 32* propdiv(L/32);
M = d(find(d>=64 & d<L/2));
M = [32 M];

examples = 64;
to_save_peaq_real_full = zeros(length(M), length(red));
to_save_pemoq_real_full = zeros(length(M), length(red));
SNR_real_full = zeros(length(M), length(red));

to_save_peaq_pghi_full = zeros(length(M), length(red));
to_save_pemoq_pghi_full = zeros(length(M), length(red));
SNR_pghi_full = zeros(length(M), length(red));

to_save_peaq_fgla_full = zeros(length(M), length(red));
to_save_pemoq_fgla_full = zeros(length(M), length(red));
SNR_fgla_full = zeros(length(M), length(red));

to_save_peaq_spsi_full = zeros(length(M), length(red));
to_save_pemoq_spsi_full = zeros(length(M), length(red));
SNR_spsi_full = zeros(length(M), length(red));


for redundancy = red
    load(strcat('magnitudeProcessingTest-red', num2str(redundancy), '.mat'))
    size(reshape(nonzeros(to_save_peaq_fgla), [], length(M)), 1)
    
    to_save_peaq_real_full(:, redundancy==red) = mean(reshape(nonzeros(to_save_peaq_real), [], length(M))).';
    to_save_pemoq_real_full(:, redundancy==red) =  mean(reshape(nonzeros(to_save_pemoq_real), [], length(M))).';
    SNR_real_full(:, redundancy==red) =  mean(reshape(nonzeros(SNR_real), [], length(M))).';

    to_save_peaq_pghi_full(:, redundancy==red) = mean(reshape(nonzeros(to_save_peaq_pghi), [], length(M))).';
    to_save_pemoq_pghi_full(:, redundancy==red) = mean(reshape(nonzeros(to_save_pemoq_pghi), [], length(M))).';
    SNR_pghi_full(:, redundancy==red) = mean(reshape(nonzeros(SNR_pghi), [], length(M))).';

    to_save_peaq_fgla_full(:, redundancy==red) = mean(reshape(nonzeros(to_save_peaq_fgla), [], length(M))).';
    to_save_pemoq_fgla_full(:, redundancy==red) = mean(reshape(nonzeros(to_save_pemoq_fgla), [], length(M))).';
    SNR_fgla_full(:, redundancy==red) = mean(reshape(nonzeros(SNR_fgla), [], length(M))).';

    to_save_peaq_spsi_full(:, redundancy==red) = mean(reshape(nonzeros(to_save_peaq_spsi), [], length(M))).';
    to_save_pemoq_spsi_full(:, redundancy==red) = mean(reshape(nonzeros(to_save_pemoq_spsi), [], length(M))).';
    SNR_spsi_full(:, redundancy==red) = mean(reshape(nonzeros(SNR_spsi), [], length(M))).';
end


tfrs = (M.^2./(L.*red)')';

plotSeveralMethodsComparison(1, permute(cat(3, SNR_real_full, SNR_pghi_full, SNR_fgla_full), [3, 1, 2]), tfrs, "SNR_{MS}", [""; ""; ""], [0, 60])
plotSeveralMethodsComparison(2, permute(cat(3, to_save_peaq_real_full, to_save_peaq_pghi_full, to_save_peaq_fgla_full), [3, 1, 2]), tfrs, "ODG", ["Original Phase"; "PGHI"; "FGLA"], [-4, 0.5])
%plotSeveralMethodsComparison(3, permute(cat(3, to_save_pemoq_real_full, to_save_pemoq_pghi_full, to_save_pemoq_fgla_full, to_save_pemoq_spsi_full), [3, 1, 2]), tfrs, "ODG (PEMO-Q)", [""; ""; ""; ""], [-4, 0.5])

