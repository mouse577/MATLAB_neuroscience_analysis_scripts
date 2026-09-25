

G1_sham_all=horzcat(G1_sham_acqpgAfold,G1_sham_acqpgBfold)

avg_G1_sham_all=mean(G1_sham_all,2)

G1_sham_sem=std(G1_sham_all,0,2)/sqrt(length(G1_sham_all))

G1_sham_std=std(G1_sham_all,0,2)

G1_sham_stdplot=horzcat((avg_G1_sham_all-G1_sham_std),avg_G1_sham_all,(avg_G1_sham_all+G1_sham_std))

G1_sham_semplot=horzcat((avg_G1_sham_all-G1_sham_sem),avg_G1_sham_all,(avg_G1_sham_all+G1_sham_sem))


G1_sham_semtest=std(G1_sham_all,0,2)/sqrt(length(G1_sham_all))

G1_sham_stdplot=horzcat((avg_G1_sham_all-G1_sham_stdtest),avg_G1_sham_all,(avgG1all+G1stdtest))

G1_sham_semplot=horzcat((avgG1all-G1semtest),avgG1all,(avgG1all+G1semtest))

avg_G1_sham_all=mean(G1all,2)

[avg_G1_sham_allmin,idx]=min(avg_G1_sham_all,[],1)


%Create tiled plots
figure
tiledlayout(1,5,'TileSpacing','compact','Padding','compact')

%G1
nexttile
patch([Tfold;flipud(Tfold)],[G1stdplot(:,3);flipud(G1stdplot(:,1))],[200 200 200]/255, 'edgecolor','none')
hold on
plot(Tfold,G1stdplot(:,2),'Color',[200 200 200]/255)
plot(Tfold,G1stdplot(:,2),'k*','MarkerIndices',G1idx)
plot(Tfold,G1stdplot(:,2),'k*','MarkerIndices',G1minidx)
plot(Tfold,G1stdplot(:,3),'Color',[200 200 200]/255)
plot(Tfold,G1stdplot(:,3),'k_','linewidth',2,'MarkerIndices',G1idx,'MarkerSize',10)
plot(Tfold,G1stdplot(:,3),'k_','linewidth',2,'MarkerIndices',G1minidx,'MarkerSize',10)
plot(Tfold,G1stdplot(:,1),'Color',[200 200 200]/255)
plot(Tfold,G1stdplot(:,1),'k_','linewidth',2,'MarkerIndices',G1idx,'MarkerSize',10)
plot(Tfold,G1stdplot(:,1),'k_','linewidth',2,'MarkerIndices',G1minidx,'MarkerSize',10)
plot([G1idx,G1idx],[G1stdplot(G1idx,1),G1stdplot(G1idx,3)],'Color','k','linewidth',2)
plot([G1minidx,G1minidx],[G1stdplot(G1minidx,1),G1stdplot(G1minidx,3)],'Color','k','linewidth',2)
alpha(0.5)

patch([Tfold;flipud(Tfold)],[G2stdplot(:,3);flipud(G2stdplot(:,1))],[1 0.8 0.8], 'edgecolor','none')
hold on
plot(Tfold,G2stdplot(:,2),'Color','r')
plot(Tfold,G2stdplot(:,2),'r*','MarkerIndices',G2idx)
plot(Tfold,G2stdplot(:,2),'r*','MarkerIndices',G2minidx)
plot(Tfold,G2stdplot(:,3),'Color',[1 0.8 0.8])
plot(Tfold,G2stdplot(:,3),'r_','linewidth',2,'MarkerIndices',G2idx,'MarkerSize',10)
plot(Tfold,G2stdplot(:,3),'r_','linewidth',2,'MarkerIndices',G2minidx,'MarkerSize',10)
plot(Tfold,G2stdplot(:,1),'Color',[1 0.8 0.8])
plot(Tfold,G2stdplot(:,1),'r_','linewidth',2,'MarkerIndices',G2idx,'MarkerSize',10)
plot(Tfold,G2stdplot(:,1),'r_','linewidth',2,'MarkerIndices',G2minidx,'MarkerSize',10)
plot([G2idx,G2idx],[G2stdplot(G2idx,1),G2stdplot(G2idx,3)],'Color','r','linewidth',2)
plot([G2minidx,G2minidx],[G2stdplot(G2minidx,1),G2stdplot(G2minidx,3)],'Color','r','linewidth',2)
alpha(0.5)

patch([Tfold;flipud(Tfold)],[G3stdplot(:,3);flipud(G3stdplot(:,1))],[0.8 0.8 1], 'edgecolor','none')
hold on
plot(Tfold,G3stdplot(:,2),'Color','b')
plot(Tfold,G3stdplot(:,2),'b*','MarkerIndices',G3idx)
plot(Tfold,G3stdplot(:,2),'b*','MarkerIndices',G3minidx)
plot(Tfold,G3stdplot(:,3),'Color',[0.8 0.8 1])
plot(Tfold,G3stdplot(:,3),'b_','linewidth',2,'MarkerIndices',G3idx,'MarkerSize',10)
plot(Tfold,G3stdplot(:,3),'b_','linewidth',2,'MarkerIndices',G3minidx,'MarkerSize',10)
plot(Tfold,G3stdplot(:,1),'Color',[0.8 0.8 1])
plot(Tfold,G3stdplot(:,1),'b_','linewidth',2,'MarkerIndices',G2idx,'MarkerSize',10)
plot(Tfold,G3stdplot(:,1),'b_','linewidth',2,'MarkerIndices',G3minidx,'MarkerSize',10)
plot([G3idx,G3idx],[G3stdplot(G3idx,1),G3stdplot(G3idx,3)],'Color','b','linewidth',2)
plot([G3minidx,G3minidx],[G3stdplot(G3minidx,1),G3stdplot(G3minidx,3)],'Color','b','linewidth',2)
alpha(0.5)





xlim([1,494])
ylim([-20,12])
title('G1 pERG')
xlabel('ms')
ylabel('uV')

%good traces plot
patch([Tfold;flipud(Tfold)],[G1stdplot(:,3);flipud(G1stdplot(:,1))],[200 200 200]/255, 'edgecolor','none')
hold on
patch([Tfold;flipud(Tfold)],[G2stdplot(:,3);flipud(G2stdplot(:,1))],[1 0.8 0.8], 'edgecolor','none')
patch([Tfold;flipud(Tfold)],[G3stdplot(:,3);flipud(G3stdplot(:,1))],[0.8 0.8 1], 'edgecolor','none')
plot(Tfold,G1stdplot(:,2),'Color','k','linewidth',2)
plot(Tfold,G1stdplot(:,2),'k*','MarkerSize',10,'linewidth',2,'MarkerIndices',G1idx)
plot(Tfold,G1stdplot(:,2),'ko','MarkerSize',10,'linewidth',2,'MarkerIndices',G1minidx)
plot(Tfold,G2stdplot(:,2),'Color','r','linewidth',2)
plot(Tfold,G2stdplot(:,2),'r*','MarkerSize',10,'linewidth',2,'MarkerIndices',G2idx)
plot(Tfold,G2stdplot(:,2),'ro','MarkerSize',10,'linewidth',2,'MarkerIndices',G2minidx)
plot(Tfold,G3stdplot(:,2),'Color','y','linewidth',2)
plot(Tfold,G3stdplot(:,2),'y*','MarkerSize',10,'linewidth',2,'MarkerIndices',G3idx)
plot(Tfold,G3stdplot(:,2),'yo','MarkerSize',10,'linewidth',2,'MarkerIndices',G3minidx)
hold off
xlim([1,494])
ylim([-20,12])
title('0.7J TBI pERG')
xlabel('ms')
ylabel('uV')
alpha(0.3)

Amplitude_results_G1=[mean(group1_fold_amp);std(group1_fold_amp);(std(group1_fold_amp))/sqrt(6)]

h=bar(x,G1data,'stacked','FaceColor','Flat','EdgeColor','Flat')
h.CData(1,:)=[200 200 200]/255,[1 1 1]
h.EdgeColor(1,:)='black'
h.CData(2,:)=[1 0.8 0.8]
h.CData(3,:)=[0.8 0.8 1]

%Good bar graph
bar(x(:,1),G1data(:,1),'FaceColor',[200 200 200]/250,'EdgeColor','k','linewidth',5)
hold on
er=errorbar(x(:,1),G1data(:,1),G1stderr(1,1),'color','k','linewidth',5)
bar(x(:,2),G1data(:,2),'FaceColor',[1 0.8 0.8],'EdgeColor','r','linewidth',5)
er=errorbar(x(:,2),G1data(:,2),G1stderr(2,1),'color','r','linewidth',5)
bar(x(:,3),G1data(:,3),'FaceColor',[0.8 0.8 1],'EdgeColor','b','linewidth',5)
er=errorbar(x(:,3),G1data(:,3),G1stderr(3,1),'color','b','linewidth',5)
hold off

er = errorbar(x,G1data,G1stderr);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
hold off

%traces only
plot(Tfold,G1stdplot(:,2),'Color','k','linewidth',2)
hold on
plot(Tfold,G1stdplot(:,2),'k*','MarkerSize',10,'linewidth',2,'MarkerIndices',G1idx)
plot(Tfold,G1stdplot(:,2),'ko','MarkerSize',10,'linewidth',2,'MarkerIndices',G1minidx)
plot(Tfold,G2stdplot(:,2),'Color','r','linewidth',2)
plot(Tfold,G2stdplot(:,2),'r*','MarkerSize',10,'linewidth',2,'MarkerIndices',G2idx)
plot(Tfold,G2stdplot(:,2),'ro','MarkerSize',10,'linewidth',2,'MarkerIndices',G2minidx)
plot(Tfold,G3stdplot(:,2),'Color','b','linewidth',2)
plot(Tfold,G3stdplot(:,2),'b*','MarkerSize',10,'linewidth',2,'MarkerIndices',G3idx)
plot(Tfold,G3stdplot(:,2),'bo','MarkerSize',10,'linewidth',2,'MarkerIndices',G3minidx)
hold off
xlim([1,494])
ylim([-20,12])
title('0.7J TBI pERG')
xlabel('ms')
ylabel('uV')
alpha(0.3)




