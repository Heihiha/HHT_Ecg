% 

function [ lfhf ] = calc_mean_lfhf( ecgsig, test_mode )

sfreq = 1000;
lfhf = 0;
TIME=(0:(length(ecgsig)-1))/sfreq;
R_peaks = qrs_detect2(ecgsig, 0.25, 0.6, sfreq);
if nargin < 2
    test_mode = 0;
end

bw = 0.05;
rslt = zeros(1, length(ecgsig));

% N = length(R_peaks)-1;
N = 100;
M = 0;
Max = zeros(1,N);
thres = 500;
thres_lfhf = 50;

lfhf_table = zeros(1,N);

for i = 1:N
    if i >= length(R_peaks)-1
        break;
    end
    first = R_peaks(i)+bw*sfreq;
    last = R_peaks(i+1)-bw*sfreq;
    if (last <= first)
        continue;
    end
    left = first;
    right = last;
    emd = eemd(ecgsig(left:right), 0, 1);
    rslt(left:right) = emd(:,2);
    Max(i) = max(abs(rslt(left:right)));
    if (Max(i) > thres)
        continue;
    end
    [f,a] = fa(rslt(left:right), 0.001,'hilbert');
    tmp = calc_lfhf(f,a);
    if tmp > thres_lfhf
        continue;
    end
    lfhf_table(i) = tmp;
    M = M + 1;

end

lfhf = sum(lfhf_table)/M;


%% 
% if test_mode == 1
%     figure();
%     ax(1) = subplot(3,1,1);
%     plot(TIME,ecgsig);
%     ax(2) = subplot(3,1,2);
%     plot(TIME,ecg_rmQRS);
%     ax(3) = subplot(3,1,3);
%     plot(TIME,rslt);
%     linkaxes(ax,'x');
% %     savefig('ecgsig.fig');
% %     figure();
% %     plot(F,10*log10(Pxx));
% %     savefig('pwelch.fig');


if test_mode == 1
    start = 4;
    first = R_peaks(start)+bw*sfreq;
    last = R_peaks(start+1)-bw*sfreq;
    [f,a] = fa(rslt(first:last), 0.001,'hilbert');
    figure();
    ax(1) = subplot(2,1,1);
    plot(TIME(first:last),ecgsig(first:last));
    ax(2) = subplot(2,1,2);
    plot(TIME(first:last),rslt(first:last));
    linkaxes(ax,'x');
    figure();
    plot(f,a,'*');
    xlim([0 500]);
    figure();
    bx(1) = subplot(2,1,1);
    plot(TIME,ecgsig);
    bx(2) = subplot(2,1,2);
    linkaxes(bx,'x');
    plot(TIME,rslt)
%     figure();
%     plot(1:N,Max,'*');
end

% end
% %% 
% year = (left:right);
% plot(year,emd(:,1));
% hold on;
% plot(year,emd(:,2)-100);
% plot(year,emd(:,3)-200);
% plot(year,emd(:,4)-300);
% plot(year,emd(:,5)-400);
% plot(year,sum(emd(:,6:8),2)-600,'r-');
% hold off

end

