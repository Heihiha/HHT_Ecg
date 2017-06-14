%% 
figure();
plot(lfhf_fixed(:,1),'r *');
hold on;
plot(lfhf_fixed(:,2),'b *');
plot(lfhf_fixed(:,3),'y o');
plot(lfhf_fixed(:,4),'m o');
xlabel('Leads');
ylabel('lf/hf');
legend('02 +','03 +', '16 -', '18 -');
%% 
figure();
plot(1,lfhf_fixed(:,1),'r *');
hold on;
plot(2,lfhf_fixed(:,2),'b *');
plot(3,lfhf_fixed(:,3),'y o');
plot(4,lfhf_fixed(:,4),'m o');

%% 
mean_lfhf = nanmean(lfhf_fixed);
save('mean_lfhf.mat','mean_lfhf');

%% 
figure();
plot(entropy(:,1),'r *');
hold on;
plot(entropy(:,2),'b *');
plot(entropy(:,3),'y o');
plot(entropy(:,4),'m o');
xlabel('Leads');
ylabel('lf/hf');
legend('02 +','03 +', '16 -', '18 -');
%% 
mean_entro = nanmean(entropy);
save('mean_entro.mat','mean_entro');
%% 
figure();
plot(entropy(:,1),lfhf_fixed(:,1),'r *');
hold on;
plot(entropy(:,2),lfhf_fixed(:,2),'b *');
plot(entropy(:,3),lfhf_fixed(:,3),'y o');
plot(entropy(:,4),lfhf_fixed(:,4),'m o');
xlabel('SampEntropy');
ylabel('LF/HF');
legend('02 +','03 +', '16 -', '18 -');
savefig('classification2.fig');
