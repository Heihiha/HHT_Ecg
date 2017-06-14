function [ entropy, lfhf ] = direct_calc( data )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
r=0.15*std(data);
entropy = 0;
% figure();
nnspe(data);
% entropy = SampEn(data,r);
[Pxx, F] = pwelch(data,[],[],[],1000);
lfhf = calc_lfhf(F, Pxx);
figure();
plot(F,10*log10(Pxx));
% savefig('pwelch2.fig');
end

