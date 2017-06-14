load('Acquisition 02.mat');
% rslt1 = zeros(2,128);
%% 
sfreq = 1000;
% ecgsig = ECGdata(12,:);
data1 = zeros(128,40000);
%% 
for i = 81:128
    i
    ecgsig = ECGdata(i,:);
    [a, b, d] = calc_entropy_lfhf(ecgsig, sfreq, 0);
    rslt1(1,i) = a;
    rslt1(2,i) = b;
    data1(i,:) = d;
end
%% 
% save('data1.mat','data1');

%% 

for i = 81:128
    i
    ecgsig = ECGdata(i,:);
    [a, b] = calc_entropy_lfhf(ecgsig, sfreq, 0);
    rslt1(1,i) = a;
    rslt1(2,i) = b;
end
%% 

% save('data1.mat','rslt1');
%% 
load('Acquisition 16.mat');
rslt2 = zeros(2,128);
data2 = zeros(128,40000);
%% 

for i = 101:128
    i
    ecgsig = ECGdata(i,:);
    [a, b, d] = calc_entropy_lfhf(ecgsig, sfreq, 0);
    rslt2(1,i) = a;
    rslt2(2,i) = b;
    data2(i,:) = d;
end
%% 

% save('rslt2.mat','rslt2');
% save('data2.mat','data2');
%% 
figure();
plot(rslt1(1,:),rslt1(2,:),'r *');
hold on;
plot(rslt2(1,:),rslt2(2,:),'b *');
hold on;
plot(rslt3(1,:),rslt3(2,:),'y o');
hold on;
plot(rslt4(1,:),rslt4(2,:),'m o');
xlabel('SampEntropy');
ylabel('LF/HF');
legend('02 +','03 +', '16 -', '18 -');
savefig('classification.fig');

%% 
figure();
scatter([1:length(data2(1,:))],data2(1,:));

%% 
load('Acquisition 03.mat');
sfreq = 1000;
rslt3 = zeros(2,128);
data3 = zeros(128,40000);
%% 

for i = 81:128
    i
    ecgsig = ECGdata(i,:);
    [a, b, d] = calc_entropy_lfhf(ecgsig, sfreq, 0);
    rslt3(1,i) = a;
    rslt3(2,i) = b;
    data3(i,:) = d;
end
%% 
for i = 21:128
    i
    d = data3(i,:);
    [a, b] = direct_calc(d);
    rslt3(1,i) = a;
    rslt3(2,i) = b;
end
%% 


save('rslt3.mat','rslt3');
save('data3.mat','data3');

%% 
load('Acquisition 18.mat');
sfreq = 1000;
rslt4 = zeros(2,128);
data4 = zeros(128,40000);
%% 

for i = 81:128
    i
    ecgsig = ECGdata(i,:);
    [a, b, d] = calc_entropy_lfhf(ecgsig, sfreq, 0);
    rslt4(1,i) = a;
    rslt4(2,i) = b;
    data4(i,:) = d;
end
%% 
for i = 1:128
    i
    d = data4(i,:);
    [a, b] = direct_calc(d);
    rslt4(1,i) = a;
    rslt4(2,i) = b;
end
%% 


save('rslt4.mat','rslt4');
save('data4.mat','data4');



%% 
for i = 1:128
    i
    d = data1(i,:);
    [a, b] = meanfr;
    rslt4(1,i) = a;
    rslt4(2,i) = b;
end
%% 


save('rslt4.mat','rslt4');
save('data4.mat','data4');