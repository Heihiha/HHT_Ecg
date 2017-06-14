test_mode = 0;

entropy = 0;
lfhf = 0;


TIME=(0:(length(ecgsig)-1))/sfreq;
R_peaks = qrs_detect2(ecgsig, 0.25, 0.6, sfreq);

win = 0.1;
bw = 0.05;
rslt = zeros(1, length(ecgsig));
ecg_rmQRS = ecgsig;
flag = 1;
for i = 1:length(R_peaks)-1
    i
    if test_mode == 0 & flag>40000
        break;
    end
    first = R_peaks(i)+bw*sfreq;
    last = R_peaks(i+1)-bw*sfreq;
    if (last <= first)
        continue;
    end
    steps = floor((last - first)/(win*sfreq));
    left = first;
    for j = 1:steps-1
        right = left + win*sfreq;
        emd = eemd(ecgsig(left:right), 0, 1);
        rslt(left:right) = emd(:,2);
        left = right;
    end
    right = last;
    emd = eemd(ecgsig(left:right), 0, 1);
    rslt(left:right) = emd(:,2);
    rslt(first:last) = mapminmax(rslt(first:last), 0, 1);
    data(flag:flag + last - first) = rslt(first:last);
    flag = flag + last - first + 1;
%     ecg_rmQRS(abs(R_peaks(i)-bw*sfreq)+1:min(R_peaks(i)+bw*sfreq, length(ecgsig))) = nan;
end
ecg_rmQRS((R_peaks(end)-bw*sfreq)+1:min(R_peaks(end)+bw*sfreq, length(ecgsig))) = nan;
data = data(1:40000);

r=0.15*std(data);
entropy = SampEn(data,r);
[Pxx, F] = pwelch(data);
lfhf = calc_lfhf(F, Pxx);

if test_mode == 1
    ax(1) = subplot(3,1,1);
    plot(TIME,ecgsig);
    ax(2) = subplot(3,1,2);
    plot(TIME,ecg_rmQRS);
    ax(3) = subplot(3,1,3);
    plot(TIME,rslt);
    linkaxes(ax,'x');
end
