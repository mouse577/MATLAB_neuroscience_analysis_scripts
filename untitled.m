

figure
plot(G1CC349885M1RPUNCH_left_fold)
plot(step1T,step1L)
xlim([-50,300])
ylim([-200000,300000])
title('CC349885M3NOPUNCH Left Eye step1 scotopic 0.01 cd/m^2')
xlabel('ms')
ylabel('nV')
yline(step1TLmin)
yline(step1TLmax)
xline(step1_LE_latency)
xline(step1_LE_ImplicitTime+step1_LE_latency)
xline(0)

G1M1rightraw=G1CC349885M1RPUNCH_right_raw(:,3)
G1M1righfold=G1CC349885M1RPUNCH_right_fold(:,3)
G1M1leftraw=G1CC349885M1RPUNCH_left_raw(:,3)
G1M1leftfold=G1CC349885M1RPUNCH_left_fold(:,3)

G1M1_together_raw=horzcat(Traw,G1M1rightraw,G1M1leftraw)

group5_fold_avg=mean(group5_fold,2)
group5_raw_avg=mean(group5_raw,2)

%amplitude
group3_amp = max(group3_fold_avg)-min(group3_fold_avg)

for i=1:6
    y(i)=max(group5_fold(:,i))-min(group5_fold(:,i))
end



