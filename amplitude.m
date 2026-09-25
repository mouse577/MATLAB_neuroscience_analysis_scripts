

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

figure
tiledlayout(5,2,'TileSpacing','compact','Padding','compact')

nexttile
plot(Tfold,group1_fold(:,1))
hold on
plot(Tfold,group1_fold(:,2))
plot(Tfold,group1_fold(:,3))
plot(Tfold,group1_fold(:,4))
plot(Tfold,group1_fold(:,5))
plot(Tfold,group1_fold(:,6))
hold off
ylim([-20,15])
title('Group1 Sham')
xlabel('ms')
ylabel('uV')

nexttile
plot(Tfold,group1_fold_avg)
ylim([-20,15])
title('Group1 Sham avg')
xlabel('ms')
ylabel('uV')

nexttile
plot(Tfold,group2_fold(:,1))
hold on
plot(Tfold,group2_fold(:,2))
plot(Tfold,group2_fold(:,3))
plot(Tfold,group2_fold(:,4))
plot(Tfold,group2_fold(:,5))
plot(Tfold,group2_fold(:,6))
plot(Tfold,group2_fold(:,7))
plot(Tfold,group2_fold(:,8))
plot(Tfold,group2_fold(:,9))
hold off
ylim([-20,15])
title('Group2 0.7J TBI')
xlabel('ms')
ylabel('uV')

nexttile
plot(Tfold,group2_fold_avg)
ylim([-20,15])
title('Group2 0.7J TBI avg')
xlabel('ms')
ylabel('uV')

nexttile
plot(Tfold,group3_fold(:,1))
hold on
plot(Tfold,group3_fold(:,2))
plot(Tfold,group3_fold(:,3))
plot(Tfold,group3_fold(:,4))
plot(Tfold,group3_fold(:,5))
plot(Tfold,group3_fold(:,6))
hold off
ylim([-20,15])
title('Group3 TBI+2XNSC')
xlabel('ms')
ylabel('uV')

nexttile
plot(Tfold,group3_fold_avg)
ylim([-20,15])
title('Group3 TBI+2XNSC avg')
xlabel('ms')
ylabel('uV')

nexttile
plot(Tfold,group4_fold(:,1))
hold on
plot(Tfold,group4_fold(:,2))
plot(Tfold,group4_fold(:,3))
plot(Tfold,group4_fold(:,4))
plot(Tfold,group4_fold(:,5))
plot(Tfold,group4_fold(:,6))
plot(Tfold,group4_fold(:,7))
plot(Tfold,group4_fold(:,8))
hold off
ylim([-20,15])
title('Group4 0.5J2XTBI')
xlabel('ms')
ylabel('uV')

nexttile
plot(Tfold,group4_fold_avg)
ylim([-20,15])
title('Group4 0.5J2XTBI avg')
xlabel('ms')
ylabel('uV')

nexttile
plot(Tfold,group5_fold(:,1))
hold on
plot(Tfold,group5_fold(:,2))
plot(Tfold,group5_fold(:,3))
plot(Tfold,group5_fold(:,4))
plot(Tfold,group5_fold(:,5))
plot(Tfold,group5_fold(:,6))
hold off
ylim([-20,15])
title('Group5 0.5X2TBI+2XNSC')
xlabel('ms')
ylabel('uV')

nexttile
plot(Tfold,group5_fold_avg)
ylim([-20,15])
title('Group5 0.5X2TBI+2XNSC avg')
xlabel('ms')
ylabel('uV')





