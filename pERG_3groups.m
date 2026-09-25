%This will analyze several folded ASCII files from pERG recordings, 
% with 1 eye per file.  This is set to separate into 3
% groups but that can be changed.

%create folder on computer with the pERG recordings to be analyzed.  
%Then, navigate to that location for "Current Folder" in MATLAB (to the right).

myDir = uigetdir;
myFiles = dir(fullfile(myDir,'*.txt'));

n=90 %enter total number of files to be included in analysis
M=cell(n,4)

for k = 1:n
  baseFileName = myFiles(k).name;
  fullFileName = fullfile(myDir, baseFileName);
  fprintf(1, 'Now reading %s\n', fullFileName);
  T=readtable(baseFileName)
  Twave=table2array(T(:,4))
  clear T
  M{k,1}=Twave
  M{k,2}=max(Twave)
  M{k,3}=min(Twave)
  M{k,4}=abs(max(Twave))+abs(min(Twave))
end


Tfold=[1:494]'

%Group1

%Use this line if the file numbers for the group are not consecutive.
%G1cell=vertcat(M(1:2,:),M(21:24,:)) 

%Use this line if the file numbers for the group are consecutive
G1cell=M(1:30,:)

%Make sure to put % in front of whichever line is not being used

%G1amp=vertcat(M(1:2,4),M(21:24,4))
G1amp=(M(1:30,4))

G1amp=cell2mat(G1amp)
G1ampavg=mean(G1amp)
G1stderr=std(G1amp)/sqrt(length(G1amp))

%update numbers inside curly brackets
G1all=horzcat(M{1},M{2},M{3},M{4},M{5},M{6},M{7},M{8},M{9},M{10},M{11},M{12},M{13},M{14},M{15},M{16},M{17},M{18},M{19},M{20},M{21},M{22},M{23},M{24},M{25},M{26},M{27},M{28},M{29},M{30})

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
G1stdtest=std(G1all,0,2)
G1stdplot=horzcat((G1avg-G1stdtest),G1avg,(G1avg+G1stdtest))
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
G2cell=M(31:60,:)
G2amp=M(31:60,4)

G2amp=cell2mat(G2amp)
G2ampavg=mean(G2amp)
G2stderr=std(G2amp)/sqrt(length(G2amp))

%update numbers inside curly brackets
G2all=horzcat(M{31},M{32},M{33},M{34},M{35},M{36},M{37},M{38},M{39},M{40},M{41},M{42},M{43},M{44},M{45},M{46},M{47},M{48},M{49},M{50},M{51},M{52},M{53},M{54},M{55},M{56},M{57},M{58},M{59},M{60})

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



%Group3

%G3cell=vertcat(M(3:6,:),M(17:20,:))
G3cell=M(61:90,:)
G3amp=M(61:90,4)

G3amp=cell2mat(G3amp)
G3ampavg=mean(G3amp)
G3stderr=std(G3amp)/sqrt(length(G3amp))

%update numbers inside curly brackets
G3all=horzcat(M{61},M{62},M{63},M{64},M{65},M{66},M{67},M{68},M{69},M{70},M{71},M{72},M{73},M{74},M{75},M{76},M{77},M{78},M{79},M{80},M{81},M{82},M{83},M{84},M{85},M{86},M{87},M{88},M{89},M{90})

G3avg=mean(G3all,2)
[G3avgmin,idx]=min(G3avg,[],1)
G3minidx=idx
[G3avgmax,idx]=max(G3avg,[],1)
G3idx=idx
G3sem=std(G3all,0,2)/sqrt(length(G3all))
G3std=std(G3all,0,2)
G3stdplot=horzcat((G3avg-G3std),G3avg,(G3avg+G3std))
G3semplot=horzcat((G3avg-G3sem),G3avg,(G3avg+G3sem))
G3semtest=std(G3all,0,2)/sqrt(length(G3all))
G3stdtest=std(G3all,0,2)
G3stdplot=horzcat((G3avg-G3stdtest),G3avg,(G3avg+G3stdtest))
G3semplot=horzcat((G3avg-G3semtest),G3avg,(G3avg+G3semtest))


G3allcell=num2cell(G3all)
%G3allcellwithheader=vertcat('raw(uV)',G3allcell)

G3avgcell=num2cell(G3avg)
G3avgcellwithheader=vertcat('raw(uV)',G3avgcell)

G3stdcell=num2cell(G3std)
G3stdcellwithheader=vertcat('std',G3stdcell)

G3semcell=num2cell(G3sem)
G3semcellwithheader=vertcat('sem',G3semcell)

G3avgtimecell=horzcat(Tfoldcellwithheader,G3avgcellwithheader,G3stdcellwithheader,G3semcellwithheader)
G3finalresultsheader={'G3all' 'G3avgwaves' 'avg P1(max)' 'P1 time (ms)' 'avg N2(min)' 'N2 time (ms)' 'avg Amplitude' 'Amplitude SEM'}
G3finalresultscellavg={G3avgcell,G3avgtimecell,G3avgmax,G3idx,G3avgmin,G3minidx,G3ampavg,G3stderr}
G3finalresultscellavg=vertcat(G3finalresultsheader,G3finalresultscellavg)


%good traces plot
patch([Tfold;flipud(Tfold)],[G1stdplot(:,3);flipud(G1stdplot(:,1))],[200 200 200]/255, 'edgecolor','none')
hold on
patch([Tfold;flipud(Tfold)],[G2stdplot(:,3);flipud(G2stdplot(:,1))],[1 0.8 0.8], 'edgecolor','none')
patch([Tfold;flipud(Tfold)],[G3stdplot(:,3);flipud(G3stdplot(:,1))],[0.8 1 0.8], 'edgecolor','none')

plot(Tfold,G1stdplot(:,2),'Color','k','linewidth',2)
plot(Tfold,G1stdplot(:,2),'k*','MarkerSize',10,'linewidth',2,'MarkerIndices',G1idx)
plot(Tfold,G1stdplot(:,2),'ko','MarkerSize',10,'linewidth',2,'MarkerIndices',G1minidx)
plot(Tfold,G2stdplot(:,2),'Color','r','linewidth',2)
plot(Tfold,G2stdplot(:,2),'r*','MarkerSize',10,'linewidth',2,'MarkerIndices',G2idx)
plot(Tfold,G2stdplot(:,2),'ro','MarkerSize',10,'linewidth',2,'MarkerIndices',G2minidx)
plot(Tfold,G3stdplot(:,2),'Color','g','linewidth',2)
plot(Tfold,G3stdplot(:,2),'g*','MarkerSize',10,'linewidth',2,'MarkerIndices',G3idx)
plot(Tfold,G3stdplot(:,2),'go','MarkerSize',10,'linewidth',2,'MarkerIndices',G3minidx)

hold off
xlim([1,494])
ylim([-30,20])
title('0.7J TBI pERG')
xlabel('ms')
ylabel('uV')
alpha(0.3)
pbaspect([1 2 1])

x=[1,2,3]
G1data=[G1ampavg,G2ampavg,G3ampavg]
G1amplowerr=G1ampavg-G1stderr
G1amphigherr=G1ampavg+G1stderr
G2amplowerr=G2ampavg-G2stderr
G2amphigherr=G2ampavg-G2stderr
G3amplowerr=G3ampavg-G3stderr
G3amphigherr=G3ampavg-G3stderr
G1errhigh=[G1amphigherr,G2amphigherr,G3amphigherr]
G1errlow=[G1amplowerr,G2amplowerr,G3amplowerr]
Gstderr=[G1stderr,G2stderr,G3stderr]


%Good bar graph
figure
bar(x(:,1),G1data(:,1),'FaceColor',[200 200 200]/250,'EdgeColor','k','linewidth',5)
hold on
er=errorbar(x(:,1),G1data(:,1),Gstderr(1,1),'color','k','linewidth',5)
bar(x(:,2),G1data(:,2),'FaceColor',[1 0.8 0.8],'EdgeColor','r','linewidth',5)
er=errorbar(x(:,2),G1data(:,2),Gstderr(1,2),'color','r','linewidth',5)
bar(x(:,3),G1data(:,3),'FaceColor',[0.8 1 0.8],'EdgeColor','g','linewidth',5)
er=errorbar(x(:,3),G1data(:,3),Gstderr(1,3),'color','g','linewidth',5)
hold off
%names={'Group1','Group2','Group3'}


%traces only
figure
plot(Tfold,G1stdplot(:,2),'Color','k','linewidth',2)
hold on
plot(Tfold,G1stdplot(:,2),'k*','MarkerSize',10,'linewidth',2,'MarkerIndices',G1idx)
plot(Tfold,G1stdplot(:,2),'ko','MarkerSize',10,'linewidth',2,'MarkerIndices',G1minidx)
plot(Tfold,G2stdplot(:,2),'Color','r','linewidth',2)
plot(Tfold,G2stdplot(:,2),'r*','MarkerSize',10,'linewidth',2,'MarkerIndices',G2idx)
plot(Tfold,G2stdplot(:,2),'ro','MarkerSize',10,'linewidth',2,'MarkerIndices',G2minidx)
plot(Tfold,G3stdplot(:,2),'Color','g','linewidth',2)
plot(Tfold,G3stdplot(:,2),'g*','MarkerSize',10,'linewidth',2,'MarkerIndices',G3idx)
plot(Tfold,G3stdplot(:,2),'go','MarkerSize',10,'linewidth',2,'MarkerIndices',G3minidx)

hold off
xlim([1,494])
ylim([-20,12])
title('0.7J TBI pERG')
xlabel('ms')
ylabel('uV')
alpha(0.3)
pbaspect([1 2 1])


%Final results
FinalResults={G1finalresultscellavg,G2finalresultscellavg,G3finalresultscellavg}
FinalResultsHeader={'Group1' 'Group2' 'Group3'}
FinalResults=vertcat(FinalResultsHeader,FinalResults)

%1 way ANOVA
G1ampL=size(G1amp,1)
G2ampL=size(G2amp,1)
G3ampL=size(G3amp,1)
ampL=[G1ampL,G2ampL,G3ampL]
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

if G3ampL<maxampL
    G3evenamp=maxampL-G3ampL
    G3nanadd=NaN(G3evenamp,1)
    G3ampevenfinal=vertcat(G3amp,G3nanadd)
else G3ampevenfinal=G3amp
end


GroupstatsAmplitude=[G1ampevenfinal,G2ampevenfinal,G3ampevenfinal]
[p,tbl,stats]=anova1(GroupstatsAmplitude)
GroupstatsHeader={'Group1' 'Group2' 'Group3'}
Groupstatscell=num2cell(GroupstatsAmplitude)
GroupstatsAmplitude=vertcat(GroupstatsHeader,Groupstatscell)

%multicompare
figure
[c,m,h,gnames] = multcompare(stats)

%Clear variables
clear baseFileName
clear c
clear er
clear FinalResultsHeader
clear fullFileName

clear G1all
clear G1allcell
clear G1amp
clear G1ampavg
clear G1amphigherr
clear G1amplowerr
clear G1avg
clear G1avgcell
clear G1avgcellwithheader
clear G1avgmax
clear G1avgmin
clear G1avgtimecell
clear G1cell
clear G1data
clear G1errhigh
clear G1errlow
clear G1finalresultscellavg
clear G1finalresultsheader
clear G1idx
clear G1minidx
clear G1sem
clear G1semcell
clear G1semcellwithheader
clear G1semplot
clear G1semtest
clear G1std
clear G1stdcell
clear G1stdcellwithheader
clear G1stderr
clear G1stdplot
clear G1stdtest

clear G2all
clear G2allcell
clear G2amp
clear G2ampavg
clear G2amphigherr
clear G2amplowerr
clear G2avg
clear G2avgcell
clear G2avgcellwithheader
clear G2avgmax
clear G2avgmin
clear G2avgtimecell
clear G2cell
clear G2data
clear G2errhigh
clear G2errlow
clear G2finalresultscellavg
clear G2finalresultsheader
clear G2idx
clear G2minidx
clear G2sem
clear G2semcell
clear G2semcellwithheader
clear G2semplot
clear G2semtest
clear G2std
clear G2stdcell
clear G2stdcellwithheader
clear G2stderr
clear G2stdplot
clear G2stdtest

clear G3all
clear G3allcell
clear G3amp
clear G3ampavg
clear G3amphigherr
clear G3amplowerr
clear G3avg
clear G3avgcell
clear G3avgcellwithheader
clear G3avgmax
clear G3avgmin
clear G3avgtimecell
clear G3cell
clear G3data
clear G3errhigh
clear G3errlow
clear G3finalresultscellavg
clear G3finalresultsheader
clear G3idx
clear G3minidx
clear G3sem
clear G3semcell
clear G3semcellwithheader
clear G3semplot
clear G3semtest
clear G3std
clear G3stdcell
clear G3stdcellwithheader
clear G3stderr
clear G3stdplot
clear G3stdtest

clear gnames
clear Gstderr
clear h
clear idx
clear k
clear m
clear M
clear myDir
clear myFiles
clear n
clear p
clear Tfold
clear Tfoldcell
clear Tfoldcellwithheader
clear Twave
clear x
clear Groupstats
clear GroupstatsHeader
clear Groupstatscell
clear G1ampevenfinal
clear ampL
clear G1ampL
clear G1evenamp
clear G1nanadd
clear G2ampevenfinal
clear G2ampL
clear G3ampevenfinal
clear G3ampL
clear maxampL
















