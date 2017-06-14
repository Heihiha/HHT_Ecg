%% 
load('Acquisition 02.mat');
result02 = zeros(128,2);
sfreq = 1000;
%% 
for i = 1:128
    i
    ecgsig = ECGdata(i,:);
    tic;
    [emd_segments, R_peaks] = generate_emd_segments(ecgsig, sfreq, 0);
    result02(i,1) = calc_entropy(emd_segments, R_peaks, sfreq, 40000);
    result02(i,2) = calc_mean_lfhf(emd_segments, R_peaks, sfreq, 100, 0);
    toc;
end
%% 
save('result02.mat','result02');
