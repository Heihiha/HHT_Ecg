function [emd_segments R_peaks] = generate_emd_segments(ecgsig, sfreq, debug)
% 本函数从心电信号中提取去除QRS波群后做emd的第一层IMF片段。
%
% inputs
%   ecgsig:         one ecg channel
%
%   sfreq:          sample rate, default is 1000.
%
%   debug:          plot if debug is 1. default is 0.
%
% outputs
%   emd_segments:   和原信号同样长度，由emd提取的IMF1组成，原QRS位置的值为0
%
%   R_peaks:        提取出来的R峰位置，用来标记各emd片段的位置。即R峰的50ms后为一个emd片段的开头
%
% dependency:
%    qrs_detect2.m: R peaks detector.
%    eemd.m: from the Matlab runcode.

TIME=(0:(length(ecgsig)-1))/sfreq;
R_peaks = qrs_detect2(ecgsig, 0.25, 0.6, sfreq);

win = 0.1;
bw = 0.05;%R峰前后50ms去除
emd_segments = zeros(1, length(ecgsig));

ecg_rmQRS = ecgsig;
flag = 1;

% N = length(R_peaks)-1;%如果没有必要全部计算所有周期的emd，可以只设置N=150，可大幅提高速度。
N = 150;

for i = 1:N
% % performance trick:
%     if debug == 0 && flag>40000
%         break;
%     end
    first = R_peaks(i)+bw*sfreq;% the beginning of a segment.
    last = R_peaks(i+1)-bw*sfreq;% the end of a segment.
    if (last <= first)
        continue;% ignore if two peaks are too close.
    end
    left = first;
% %   The following loop is to do a narrower emd. But it is slower.
%     steps = floor((last - first)/(win*sfreq));
%     for j = 1:steps-1
%         right = left + win*sfreq;
%         emd = eemd(ecgsig(left:right), 0, 1);
%         emd_segments(left:right) = emd(:,2);
%         left = right;
%     end
    right = last;
    emd = eemd(ecgsig(left:right), 0, 1);
    emd_segments(left:right) = emd(:,2);

    flag = flag + last - first + 1;
    ecg_rmQRS(abs(R_peaks(i)-bw*sfreq)+1:min(R_peaks(i)+bw*sfreq, length(ecgsig))) = nan;
end
ecg_rmQRS((R_peaks(end)-bw*sfreq)+1:min(R_peaks(end)+bw*sfreq, length(ecgsig))) = nan;

if debug == 1
    figure();
    ax(1) = subplot(3,1,1);
    plot(TIME,ecgsig);
    ax(2) = subplot(3,1,2);
    plot(TIME,ecg_rmQRS);
    ax(3) = subplot(3,1,3);
    plot(TIME,emd_segments);
    linkaxes(ax,'x');
    savefig('ecgsig.fig');
end
end
