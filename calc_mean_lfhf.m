function lfhf = calc_mean_lfhf(emd_segments, R_peaks, sfreq, N, debug)
%计算前N段emd片段低频高频比的均值。
%对每个片段求lf/hf 再求N段的均值，作为这一信号的lf/hf
%
% inputs
%   emd_segments:   和原信号同样长度，由emd提取的IMF1组成，原QRS位置的值为0
%
%   R_peaks:        提取出来的R峰位置，用来标记各emd片段的位置。即R峰的50ms后为一个emd片段的开头
%
%   sfreq:          sample rate, default is 1000.
%
%   N:              计算前N段lfhf的均值。默认100.
%
%   debug:          plot if debug is 1. default is 0.
%
% outputs
%   lfhf:        lf/hf.低频段为100~250hz，高频段为250~400hz。
%
%
% dependency:
%    calc_lfhf.m: Changed from G.Clifford program.

bw = 0.05;%R峰前后50ms去除
% N = 100;
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
    Max(i) = max(abs(emd_segments(left:right)));
    if (Max(i) > thres)
        continue;%ignore Interference.
    end
    [f,a] = fa(emd_segments(left:right), 0.001,'hilbert');
    tmp = calc_lfhf(f,a);
    if tmp > thres_lfhf
        continue;
    end
    lfhf_table(i) = tmp;
    M = M + 1;
end


lfhf = sum(lfhf_table)/M;%M maybe is smaller than N considering Interference.



if debug == 1
    start = 4;
    first = R_peaks(start)+bw*sfreq;
    last = R_peaks(start+1)-bw*sfreq;
    [f,a] = fa(emd_segments(first:last), 0.001,'hilbert');
    figure();
    ax(1) = subplot(2,1,1);
    plot(TIME(first:last),ecgsig(first:last));
    ax(2) = subplot(2,1,2);
    plot(TIME(first:last),emd_segments(first:last));
    linkaxes(ax,'x');
    figure();
    plot(f,a,'*');
    xlim([0 500]);
    figure();
    bx(1) = subplot(2,1,1);
    plot(TIME,ecgsig);
    bx(2) = subplot(2,1,2);
    linkaxes(bx,'x');
    plot(TIME,emd_segments)
%     figure();
%     plot(1:N,Max,'*');
end
end
