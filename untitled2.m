%This will analyze several folded ASCII files from pERG recordings, 
% with 1 eye per file.  This is set to separate into 3
% groups but that can be changed.

%create folder on computer with the pERG recordings to be analyzed.  
%Then, navigate to that location for "Current Folder" in MATLAB (to the right).

myDir = uigetdir;
myFiles = dir(fullfile(myDir,'*.txt'));

n=20 %enter total number of files to be included in analysis
M=cell(n,4)

for k = 1:n
  baseFileName = myFiles(k).name;
  fullFileName = fullfile(myDir, baseFileName);
  fprintf(1, 'Now reading %s\n', fullFileName);
  T=readtable(baseFileName)
  Twave=table2array(T(:,4))
  clear T
  M{k,1}=Twave
  M{k,2}=max(Twave(5:480))
  M{k,3}=min(Twave(5:480))
  M{k,4}=abs(max(Twave))+abs(min(Twave))
end


Tfold=[1:494]'

%Group1

%Use this line if the file numbers for the group are not consecutive.
%G1cell=vertcat(M(1:2,:),M(21:24,:)) 

%Use this line if the file numbers for the group are consecutive
G1cell=M(1:10,:)

%Make sure to put % in front of whichever line is not being used

%G1amp=vertcat(M(1:2,4),M(21:24,4))
G1amp=(M(1:10,4))

G1amp=cell2mat(G1amp)
G1ampavg=mean(G1amp)
G1stderr=std(G1amp)/sqrt(length(G1amp))

%update numbers inside curly brackets
G1all=horzcat(M{1},M{2},M{3},M{4},M{5},M{6},M{7},M{8},M{9},M{10})

G1avg=mean(G1all,2)
[G1avgmin,idx]=min(G1avg,[],1)
G1minidx=idx
[G1avgmax,idx]=max(G1avg,[],1)
G1idx=idx
G1sem=std(G1all,0,2)/sqrt(length(G1all))
G1std=std(G1all,0,2)
G1stdplot=horzcat((G1avg-G1std),G1avg,(G1avg+G1std))
G1semplot=horzcat((G1avg-G1sem),G1avg,(G1avg+G1sem))
G1semtest=std(G1all,0,2)/sqrt(length(G1all))
%G1stdtest=std(G1all,0,2)
%G1stdplot=horzcat((G1avg-G1stdtest),G1avg,(G1avg+G1stdtest))
G1semplot=horzcat((G1avg-G1semtest),G1avg,(G1avg+G1semtest))

Tfoldcell=num2cell(Tfold)
Tfoldcellwithheader=vertcat('time(ms)',Tfoldcell)

G1allcell=num2cell(G1all)
%G1allcellwithheader=vertcat('raw(uV)',G1allcell)

G1avgcell=num2cell(G1avg)
G1avgcellwithheader=vertcat('raw(uV)',G1avgcell)

G1stdcell=num2cell(G1std)
G1stdcellwithheader=vertcat('std',G1stdcell)

G1semcell=num2cell(G1sem)
G1semcellwithheader=vertcat('sem',G1semcell)

G1avgtimecell=horzcat(Tfoldcellwithheader,G1avgcellwithheader,G1stdcellwithheader,G1semcellwithheader)
G1finalresultsheader={'G1all' 'G1avgwaves' 'avg P1(max)' 'P1 time (ms)' 'avg N2(min)' 'N2 time (ms)' 'avg Amplitude' 'Amplitude SEM'}
G1finalresultscellavg={G1allcell,G1avgtimecell,G1avgmax,G1idx,G1avgmin,G1minidx,G1ampavg,G1stderr}
G1finalresultscellavg=vertcat(G1finalresultsheader,G1finalresultscellavg)


%Group2

%G2cell=vertcat(M(9:16,:),M(21:24,:))
G2cell=M(11:20,:)
G2amp=M(11:20,4)

G2amp=cell2mat(G2amp)
G2ampavg=mean(G2amp)
G2stderr=std(G2amp)/sqrt(length(G2amp))

%update numbers inside curly brackets
G2all=horzcat(M{11},M{12},M{13},M{14},M{15},M{16},M{17},M{18},M{19},M{20})

G2avg=mean(G2all,2)
[G2avgmin,idx]=min(G2avg,[],1)
G2minidx=idx
[G2avgmax,idx]=max(G2avg,[],1)
G2idx=idx
G2sem=std(G2all,0,2)/sqrt(length(G2all))
G2std=std(G2all,0,2)
G2stdplot=horzcat((G2avg-G2std),G2avg,(G2avg+G2std))
G2semplot=horzcat((G2avg-G2sem),G2avg,(G2avg+G2sem))
G2semtest=std(G2all,0,2)/sqrt(length(G2all))
G2stdtest=std(G2all,0,2)
G2stdplot=horzcat((G2avg-G2stdtest),G2avg,(G2avg+G2stdtest))
G2semplot=horzcat((G2avg-G2semtest),G2avg,(G2avg+G2semtest))


G2allcell=num2cell(G2all)
%G2allcellwithheader=vertcat('raw(uV)',G2allcell)

G2avgcell=num2cell(G2avg)
G2avgcellwithheader=vertcat('raw(uV)',G2avgcell)

G2stdcell=num2cell(G2std)
G2stdcellwithheader=vertcat('std',G2stdcell)

G2semcell=num2cell(G2sem)
G2semcellwithheader=vertcat('sem',G2semcell)

G2avgtimecell=horzcat(Tfoldcellwithheader,G2avgcellwithheader,G2stdcellwithheader,G2semcellwithheader)
G2finalresultsheader={'G2all' 'G2avgwaves' 'avg P1(max)' 'P1 time (ms)' 'avg N2(min)' 'N2 time (ms)' 'avg Amplitude' 'Amplitude SEM'}
G2finalresultscellavg={G2allcell,G2avgtimecell,G2avgmax,G2idx,G2avgmin,G2minidx,G2ampavg,G2stderr}
G2finalresultscellavg=vertcat(G2finalresultsheader,G2finalresultscellavg)






%good traces plot
patch([Tfold;flipud(Tfold)],[G1stdplot(:,3);flipud(G1stdplot(:,1))],[200 200 200]/255, 'edgecolor','none')
hold on
patch([Tfold;flipud(Tfold)],[G2stdplot(:,3);flipud(G2stdplot(:,1))],[1 0.8 0.8], 'edgecolor','none')


plot(Tfold,G1stdplot(:,2),'Color','k','linewidth',2)
plot(Tfold,G1stdplot(:,2),'k*','MarkerSize',10,'linewidth',2,'MarkerIndices',G1idx)
plot(Tfold,G1stdplot(:,2),'ko','MarkerSize',10,'linewidth',2,'MarkerIndices',G1minidx)
plot(Tfold,G2stdplot(:,2),'Color','r','linewidth',2)
plot(Tfold,G2stdplot(:,2),'r*','MarkerSize',10,'linewidth',2,'MarkerIndices',G2idx)
plot(Tfold,G2stdplot(:,2),'ro','MarkerSize',10,'linewidth',2,'MarkerIndices',G2minidx)


hold off
xlim([1,494])
ylim([-35,30])
title('ONC before pERG')
xlabel('ms')
ylabel('uV')
alpha(0.3)
pbaspect([1 2 1])

x=[1,2,3]
G1data=[G1ampavg,G2ampavg]
G1amplowerr=G1ampavg-G1stderr
G1amphigherr=G1ampavg+G1stderr
G2amplowerr=G2ampavg-G2stderr
G2amphigherr=G2ampavg-G2stderr
G1errhigh=[G1amphigherr,G2amphigherr]
G1errlow=[G1amplowerr,G2amplowerr]
Gstderr=[G1stderr,G2stderr]


%Good bar graph
figure
bar(x(:,1),G1data(:,1),'FaceColor',[200 200 200]/250,'EdgeColor','k','linewidth',5)
hold on
er=errorbar(x(:,1),G1data(:,1),Gstderr(1,1),'color','k','linewidth',5)
bar(x(:,2),G1data(:,2),'FaceColor',[1 0.8 0.8],'EdgeColor','r','linewidth',5)
er=errorbar(x(:,2),G1data(:,2),Gstderr(1,2),'color','r','linewidth',5)
hold off
%names={'Group1','Group2'}


%traces only
figure
plot(Tfold,G1stdplot(:,2),'Color','k','linewidth',2)
hold on
plot(Tfold,G1stdplot(:,2),'k*','MarkerSize',10,'linewidth',2,'MarkerIndices',G1idx)
plot(Tfold,G1stdplot(:,2),'ko','MarkerSize',10,'linewidth',2,'MarkerIndices',G1minidx)
plot(Tfold,G2stdplot(:,2),'Color','r','linewidth',2)
plot(Tfold,G2stdplot(:,2),'r*','MarkerSize',10,'linewidth',2,'MarkerIndices',G2idx)
plot(Tfold,G2stdplot(:,2),'ro','MarkerSize',10,'linewidth',2,'MarkerIndices',G2minidx)

hold off
xlim([1,494])
ylim([-20,12])
title('Sham pERG')
xlabel('ms')
ylabel('uV')
alpha(0.3)
pbaspect([1 2 1])


%Final results
FinalResults={G1finalresultscellavg,G2finalresultscellavg}
FinalResultsHeader={'Group1' 'Group2'}
FinalResults=vertcat(FinalResultsHeader,FinalResults)

%1 way ANOVA
G1ampL=size(G1amp,1)
G2ampL=size(G2amp,1)
ampL=[G1ampL,G2ampL]
maxampL=max(ampL)

if G1ampL<maxampL
    G1evenamp=maxampL-G1ampL
    G1nanadd=NaN(G1evenamp,1)
    G1ampevenfinal=vertcat(G1amp,G1nanadd)
else G1ampevenfinal=G1amp
end

if G2ampL<maxampL
    G2evenamp=maxampL-G2ampL
    G2nanadd=NaN(G2evenamp,1)
    G2ampevenfinal=vertcat(G2amp,G2nanadd)
else G2ampevenfinal=G2amp
end


GroupstatsAmplitude=[G1ampevenfinal,G2ampevenfinal]
[p,tbl,stats]=anova1(GroupstatsAmplitude)
GroupstatsHeader={'Group1' 'Group2'}
Groupstatscell=num2cell(GroupstatsAmplitude)
GroupstatsAmplitude=vertcat(GroupstatsHeader,Groupstatscell)

%multicompare
figure
[c,m,h,gnames] = multcompare(stats)

%Clear variables
