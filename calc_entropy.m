function entropy = calc_entropy(emd_segments, R_peaks, sfreq, N)
% 利用generate_emd_segments的输出，计算采样熵。
%
% inputs
%   emd_segments:   和原信号同样长度，由emd提取的IMF1组成，原QRS位置的值为0
%
%   R_peaks:        提取出来的R峰位置，用来标记各emd片段的位置。即R峰的50ms后为一个emd片段的开头
%
%   sfreq:          sample rate, default is 1000.
%
%   N:              选取emd片段前N个的点来计算。默认40000.
%
%
% outputs
%   entropy:        计算结果。提取的前N个点归一化后的采样熵。
%
%
% dependency:
%    SampEN.m:      计算给定数据的采样熵。

bw = 0.05;%R峰前后50ms去除

flag = 1;
thres = 500;
data = zeros(1, length(emd_segments));
Max = zeros(1,length(R_peaks)-1);
for i = 1:length(R_peaks)-1
    if flag>N
        break;%end early.
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
    %Normalization:
    emd_segments(first:last) = mapminmax(emd_segments(first:last), 0, 1);
    data(flag:flag + last - first) = emd_segments(first:last);
    flag = flag + last - first + 1;
end
data = data(1:N);

r=0.15*std(data);
entropy = SampEn(data,r);
end
