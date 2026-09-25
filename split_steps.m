%Dark-adapted ERG analysis%

M=CC349892M1RPUNCH
%step1%
step1=M(:,1:5)
step1T=step1(:,1)
step1L=step1(:,2)
step1R=step1(:,3)

%step2%
step2=M(:,6:10)
step2T=step2(:,1)
step2L=step2(:,2)
step2R=step2(:,3)

%step3%
step3=M(:,11:15)
step3T=step3(:,1)
step3L=step3(:,2)
step3R=step3(:,3)

%step4%
step4=M(:,16:28)
step4T=step4(:,1)
step4L=mean([step4(:,2),step4(:,3),step4(:,4)],2)
step4R=mean([step4(:,5),step4(:,6),step4(:,7)],2)

%step5%
step5=M(:,29:41)
step5T=step5(:,1)
step5L=mean([step5(:,2),step5(:,3),step5(:,4)],2)
step5R=mean([step5(:,5),step5(:,6),step5(:,7)],2)

%step6%
step6=M(:,42:44)
step6T=step6(:,1)
step6L=step6(:,2)
step6R=step6(:,3)


%compute measurements step 1 

%find A wave and latency step 1 Left eye
step1TL=horzcat(step1T,step1L)
[step1TLmin,idx]=min(step1TL(121:209,2),[],1)
step1_LE_latency=step1TL(121+(idx-1),1)
step1_LE_Awave=step1TL(101,2)-step1TLmin

%find B wave and implicit time step 1 Left eye
[step1TLmax,idx]=max(step1TL(201:end,2),[],1)
step1_LE_Bwave=step1TLmax-step1_LE_Awave
step1_LE_ImplicitTime=step1TL(201+(idx-1),1)-step1_LE_latency

figure
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


%find A wave and latency step 1 Right eye
step1TR=horzcat(step1T,step1R)
[step1TRmin,idx]=min(step1TR(121:209,2),[],1)
step1_RE_latency=step1TR(121+(idx-1),1)
step1_RE_Awave=step1TR(101,2)-step1TRmin

%find B wave and implicit time step 1 Right eye
[step1TRmax,idx]=max(step1TR(201:401,2),[],1)
step1_RE_Bwave=step1TRmax-step1_RE_Awave
step1_RE_ImplicitTime=step1TR(201+(idx-1),1)-step1_RE_latency

figure
plot(step1T,step1R)
xlim([-50,300])
ylim([-200000,300000])
title('CC349885M3NOPUNCH Right Eye step1 scotopic 0.01 cd/m^2')
xlabel('ms')
ylabel('nV')
yline(step1TRmin)
yline(step1TRmax)
xline(step1_RE_latency)
xline(step1_RE_ImplicitTime+step1_RE_latency)
xline(0)



%compute measurements step 2 

%find A wave and latency step 2 Left eye
step2TL=horzcat(step2T,step2L)
[step2TLmin,idx]=min(step2TL(101:301,2),[],1)
step2_LE_latency=step2TL(101+(idx-1),1)
step2_LE_Awave=step2TL(101,2)-step2TLmin

%find B wave and implicit time step 2 Left eye
[step2TLmax,idx]=max(step2TL(261:end,2),[],1)
step2_LE_Bwave=step2TLmax-step2_LE_Awave
step2_LE_ImplicitTime=step2TL(261+(idx-1),1)-step2_LE_latency

figure
plot(step2T,step2L)
xlim([-50,300])
ylim([-200000,300000])
title('CC349885M3NOPUNCH Left Eye step2 scotopic 0.1 cd/m^2')
xlabel('ms')
ylabel('nV')
yline(step2TLmin)
yline(step2TLmax)
xline(step2_LE_latency)
xline(step2_LE_ImplicitTime+step2_LE_latency)
xline(0)


%find A wave and latency step 2 Right eye
step2TR=horzcat(step2T,step2R)
[step2TRmin,idx]=min(step2TR(121:209,2),[],1)
step2_RE_latency=step2TR(121+(idx-1),1)
step2_RE_Awave=step2TR(101,2)-step2TRmin

%find B wave and implicit time step 2 Right eye
[step2TRmax,idx]=max(step2TR(261:361,2),[],1)
step2_RE_Bwave=step2TRmax-step2_RE_Awave
step2_RE_ImplicitTime=step2TR(261+(idx-1),1)-step2_RE_latency

figure
plot(step2T,step2R)
xlim([-50,300])
ylim([-200000,300000])
title('CC349885M3NOPUNCH Right Eye step2 scotopic 0.1 cd/m^2')
xlabel('ms')
ylabel('nV')
yline(step2TRmin)
yline(step2TRmax)
xline(step2_RE_latency)
xline(step2_RE_ImplicitTime+step2_RE_latency)
xline(0)

%compute measurements step 3 

%find A wave and latency step 3 Left eye
step3TL=horzcat(step3T,step3L)
[step3TLmin,idx]=min(step3TL(101:501,2),[],1)
step3_LE_latency=step3TL(101+(idx-1),1)
step3_LE_Awave=step3TL(101,2)-step3TLmin

%find B wave and implicit time step 3 Left eye
[step3TLmax,idx]=max(step3TL(221:end,2),[],1)
step3_LE_Bwave=step3TLmax-step3_LE_Awave
step3_LE_ImplicitTime=step3TL(221+(idx-1),1)-step3_LE_latency

figure
plot(step3T,step3L)
xlim([-50,300])
ylim([-200000,300000])
title('CC349885M3NOPUNCH Left Eye step3 mesopic 1.0 cd/m^2')
xlabel('ms')
ylabel('nV')
yline(step3TLmin)
yline(step3TLmax)
xline(step3_LE_latency)
xline(step3_LE_ImplicitTime+step3_LE_latency)
xline(0)


%find A wave and latency step 3 Right eye
step3TR=horzcat(step3T,step3R)
[step3TRmin,idx]=min(step3TR(101:209,2),[],1)
step3_RE_latency=step3TR(101+(idx-1),1)
step3_RE_Awave=step3TR(101,2)-step3TRmin

%find B wave and implicit time step 3 Right eye
[step3TRmax,idx]=max(step3TR(221:401,2),[],1)
step3_RE_Bwave=step3TRmax-step3_RE_Awave
step3_RE_ImplicitTime=step3TR(221+(idx-1),1)-step3_RE_latency

figure
plot(step3T,step3R)
xlim([-50,300])
ylim([-200000,300000])
title('CC349885M3NOPUNCH Right Eye step3 mesopic 1.0 cd/m^2')
xlabel('ms')
ylabel('nV')
yline(step3TRmin)
yline(step3TRmax)
xline(step3_RE_latency)
xline(step3_RE_ImplicitTime+step3_RE_latency)
xline(0)


%compute measurements step 4 

%find A wave and latency step 4 Left eye
step4TL=horzcat(step4T,step4L)
[step4TLmin,idx]=min(step4TL(101:221,2),[],1)
step4_LE_latency=step4TL(101+(idx-1),1)
step4_LE_Awave=step4TL(101+(idx-1),2)-step4TL(101,2)


%find B wave and implicit time step 4 Left eye
[step4TLmax,idx]=max(step4TL(:,2),[],1)
step4_LE_Bwave=step4TLmax-step4_LE_Awave
step4_LE_ImplicitTime=step4TL(idx,1)-step4_LE_latency


figure
plot(step4T,step4L)
xlim([-50,300])
ylim([-200000,300000])
title('CC349885M3NOPUNCH Left Eye step4 photopic 3.0 cd/m^2')
xlabel('ms')
ylabel('nV')
yline(step4TLmin)
yline(step4TLmax)
xline(step4_LE_latency)
xline(step4_LE_ImplicitTime+step4_LE_latency)
xline(0)


%find A wave and latency step 4 Right eye
step4TR=horzcat(step4T,step4R)
[step4TRmin,idx]=min(step4TR(101:221,2),[],1)
step4_RE_latency=step4TR(101+(idx-1),1)
step4_RE_Awave=step4TR(101+(idx-1),2)-step4TR(101,2)


%find B wave and implicit time step 4 Right eye
[step4TRmax,idx]=max(step4TR(:,2),[],1)
step4_RE_Bwave=step4TRmax-step4_RE_Awave
step4_RE_ImplicitTime=step4TR(idx,1)-step4_RE_latency


figure
plot(step4T,step4R)
xlim([-50,300])
ylim([-200000,300000])
title('CC349885M3NOPUNCH Right Eye step4 photopic 3.0 cd/m^2')
xlabel('ms')
ylabel('nV')
yline(step4TRmin)
yline(step4TRmax)
xline(step4_RE_latency)
xline(step4_RE_ImplicitTime+step4_RE_latency)
xline(0)


%compute measurements step 5 

%find A wave and latency step 5 Left eye
step5TL=horzcat(step5T,step5L)
[step5TLmin,idx]=min(step5TL(101:221,2),[],1)
step5_LE_latency=step5TL(101+(idx-1),1)
step5_LE_Awave=step5TL(101+(idx-1),2)-step5TL(101,2)


%find B wave and implicit time step 5 Left eye
[step5TLmax,idx]=max(step5TL(:,2),[],1)
step5_LE_Bwave=step5TLmax-step5_LE_Awave
step5_LE_ImplicitTime=step5TL(idx,1)-step5_LE_latency


figure
plot(step5T,step5L)
xlim([-50,300])
ylim([-200000,300000])
title('CC349885M3NOPUNCH Left Eye step5 photopic 10.0 cd/m^2')
xlabel('ms')
ylabel('nV')
yline(step5TLmin)
yline(step5TLmax)
xline(step5_LE_latency)
xline(step5_LE_ImplicitTime+step5_LE_latency)
xline(0)


%find A wave and latency step 5 Right eye
step5TR=horzcat(step5T,step5R)
[step5TRmin,idx]=min(step5TR(101:221,2),[],1)
step5_RE_latency=step5TR(101+(idx-1),1)
step5_RE_Awave=step5TR(101+(idx-1),2)-step5TR(101,2)


%find B wave and implicit time step 5 Right eye
[step5TRmax,idx]=max(step5TR(:,2),[],1)
step5_RE_Bwave=step5TRmax-step5_RE_Awave
step5_RE_ImplicitTime=step5TR(idx,1)-step5_RE_latency


figure
plot(step5T,step5R)
xlim([-50,300])
ylim([-200000,300000])
title('CC349885M3NOPUNCH Right Eye step5 photopic 10.0 cd/m^2')
xlabel('ms')
ylabel('nV')
yline(step5TRmin)
yline(step5TRmax)
xline(step5_RE_latency)
xline(step5_RE_ImplicitTime+step5_RE_latency)
xline(0)


%compute measurements step 6 

%find N1 wave and latency step 6 Left eye
step6TL=horzcat(step6T,step6L)
[step6TLmin,idx]=min(step6TL(101:201,2),[],1)
step6_LE_latency=step6TL(101+(idx-1),1)
step6_LE_N1=step6TL(101,2)+step6TLmin


%find P1 wave and implicit time step 6 Left eye
[step6TLmax,idx]=max(step6TL(141:301,2),[],1)
step6_LE_P1=step6TLmax-step6_LE_N1
step6_LE_ImplicitTime=step6TL(141+(idx-1),1)-step6_LE_latency


figure
plot(step6T,step6L)
xlim([-50,300])
ylim([-200000,300000])
title('CC349885M3NOPUNCH Left Eye step6 photopic 10hz flicker')
xlabel('ms')
ylabel('nV')
yline(step6TLmax)
yline(step6TLmin)
xline(step6_LE_latency)
xline(step6_LE_ImplicitTime+step6_LE_latency)
xline(0)


%find N1 wave and latency step 6 Right eye
step6TR=horzcat(step6T,step6R)
[step6TRmin,idx]=min(step6TR(121:201,2),[],1)
step6_RE_latency=step6TR(121+(idx-1),1)
step6_RE_N1=step6TR(121,2)+step6TRmin


%find P1 wave and implicit time step 6 Right eye
[step6TRmax,idx]=max(step6TR(141:301,2),[],1)
step6_RE_P1=step6TRmax-step6_RE_N1
step6_RE_ImplicitTime=step6TR(141+(idx-1),1)-step6_RE_latency


figure
plot(step6T,step6R)
xlim([-50,300])
ylim([-200000,300000])
title('CC349885M3NOPUNCH Right Eye step6 photopic 10hz flicker')
xlabel('ms')
ylabel('nV')
yline(step6TRmax)
yline(step6TRmin)
xline(step6_RE_latency)
xline(step6_RE_ImplicitTime+step6_RE_latency)
xline(0)

%Create Results str%
str=["step/side(R/L)","1L","1R","2L","2R","3L","3R","4L","4R","5L","5R","6L","6R";
    "latency(ms)",step1_LE_latency,step1_RE_latency,step2_LE_latency,step2_RE_latency,step3_LE_latency,step3_RE_latency,step4_LE_latency,step4_RE_latency,step5_LE_latency,step5_RE_latency,step6_LE_latency,step6_RE_latency;
    "aWave(nV)",step1_LE_Awave,step1_RE_Awave,step2_LE_Awave,step2_RE_Awave,step3_LE_Awave,step3_RE_Awave,step4_LE_Awave,step4_RE_Awave,step5_LE_Awave,step5_RE_Awave,step6_LE_N1,step6_RE_N1;
    "bWave(nV)",step1_LE_Bwave,step1_RE_Bwave,step2_LE_Bwave,step2_RE_Bwave,step3_LE_Bwave,step3_RE_Bwave,step4_LE_Bwave,step4_RE_Bwave,step5_LE_Bwave,step5_RE_Bwave,step6_LE_P1,step6_RE_P1;
    "ImplicitTime(ms)",step1_LE_ImplicitTime,step1_RE_ImplicitTime,step2_LE_ImplicitTime,step2_RE_ImplicitTime,step3_LE_ImplicitTime,step3_RE_ImplicitTime,step4_LE_ImplicitTime,step4_RE_ImplicitTime,step5_LE_ImplicitTime,step5_RE_ImplicitTime,step6_LE_ImplicitTime,step6_RE_ImplicitTime]
Results=str

%Create tiled plots
figure
tiledlayout(6,2,'TileSpacing','compact','Padding','compact')

nexttile
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

nexttile
plot(step1T,step1R)
xlim([-50,300])
ylim([-200000,300000])
title('CC349885M3NOPUNCH Right Eye step1 scotopic 0.01 cd/m^2')
xlabel('ms')
ylabel('nV')
yline(step1TRmin)
yline(step1TRmax)
xline(step1_RE_latency)
xline(step1_RE_ImplicitTime+step1_RE_latency)
xline(0)

nexttile
plot(step2T,step2L)
xlim([-50,300])
ylim([-200000,300000])
title('CC349885M3NOPUNCH Left Eye step2 scotopic 0.1 cd/m^2')
xlabel('ms')
ylabel('nV')
yline(step2TLmin)
yline(step2TLmax)
xline(step2_LE_latency)
xline(step2_LE_ImplicitTime+step2_LE_latency)
xline(0)

nexttile
plot(step2T,step2R)
xlim([-50,300])
ylim([-200000,300000])
title('CC349885M3NOPUNCH Right Eye step2 scotopic 0.1 cd/m^2')
xlabel('ms')
ylabel('nV')
yline(step2TRmin)
yline(step2TRmax)
xline(step2_RE_latency)
xline(step2_RE_ImplicitTime+step2_RE_latency)
xline(0)

nexttile
plot(step3T,step3L)
xlim([-50,300])
ylim([-200000,300000])
title('CC349885M3NOPUNCH Left Eye step3 mesopic 1.0 cd/m^2')
xlabel('ms')
ylabel('nV')
yline(step3TLmin)
yline(step3TLmax)
xline(step3_LE_latency)
xline(step3_LE_ImplicitTime+step3_LE_latency)
xline(0)

nexttile
plot(step3T,step3R)
xlim([-50,300])
ylim([-200000,300000])
title('CC349885M3NOPUNCH Right Eye step3 mesopic 1.0 cd/m^2')
xlabel('ms')
ylabel('nV')
yline(step3TRmin)
yline(step3TRmax)
xline(step3_RE_latency)
xline(step3_RE_ImplicitTime+step3_RE_latency)
xline(0)

nexttile
plot(step4T,step4L)
xlim([-50,300])
ylim([-50000,100000])
title('CC349885M3NOPUNCH Left Eye step4 photopic 3.0 cd/m^2')
xlabel('ms')
ylabel('nV')
yline(step4TLmin)
yline(step4TLmax)
xline(step4_LE_latency)
xline(step4_LE_ImplicitTime+step4_LE_latency)
xline(0)

nexttile
plot(step4T,step4R)
xlim([-50,300])
ylim([-50000,100000])
title('CC349885M3NOPUNCH Right Eye step4 photopic 3.0 cd/m^2')
xlabel('ms')
ylabel('nV')
yline(step4TRmin)
yline(step4TRmax)
xline(step4_RE_latency)
xline(step4_RE_ImplicitTime+step4_RE_latency)
xline(0)

nexttile
plot(step5T,step5L)
xlim([-50,300])
ylim([-50000,100000])
title('CC349885M3NOPUNCH Left Eye step5 photopic 10.0 cd/m^2')
xlabel('ms')
ylabel('nV')
yline(step5TLmin)
yline(step5TLmax)
xline(step5_LE_latency)
xline(step5_LE_ImplicitTime+step5_LE_latency)
xline(0)

nexttile
plot(step5T,step5R)
xlim([-50,300])
ylim([-50000,100000])
title('CC349885M3NOPUNCH Right Eye step5 photopic 10.0 cd/m^2')
xlabel('ms')
ylabel('nV')
yline(step5TRmin)
yline(step5TRmax)
xline(step5_RE_latency)
xline(step5_RE_ImplicitTime+step5_RE_latency)
xline(0)

nexttile
plot(step6T,step6L)
xlim([-50,300])
ylim([-50000,100000])
title('CC349885M3NOPUNCH Left Eye step6 photopic 10hz flicker')
xlabel('ms')
ylabel('nV')
yline(step6TLmax)
yline(step6TLmin)
xline(step6_LE_latency)
xline(step6_LE_ImplicitTime+step6_LE_latency)
xline(0)

nexttile
plot(step6T,step6R)
xlim([-50,300])
ylim([-50000,100000])
title('CC349885M3NOPUNCH Right Eye step6 photopic 10hz flicker')
xlabel('ms')
ylabel('nV')
yline(step6TRmax)
yline(step6TRmin)
xline(step6_RE_latency)
xline(step6_RE_ImplicitTime+step6_RE_latency)
xline(0)










