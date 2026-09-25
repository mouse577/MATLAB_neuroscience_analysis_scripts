%This will analyze several folded ASCII files from pERG recordings, 
% with 1 eye per file.  This is set to separate into 3
% groups but that can be changed.

%create folder on computer with the pERG recordings to be analyzed.  
%Then, navigate to that location for "Current Folder" in MATLAB (to the right).

myDir = uigetdir;
myFiles = dir(fullfile(myDir,'*.txt'));

n=12 %enter total number of files to be included in analysis
M=cell(n,4)
tile_rows = n/4

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
g = 6
h = 12
%Use this line if the file numbers for the group are not consecutive.
%G1cell=vertcat(M(1:2,:),M(21:24,:)) 

%Use this line if the file numbers for the group are consecutive
G1cell=M(g,:)

%Make sure to put % in front of whichever line is not being used

%G1amp=vertcat(M(1:1,4),M(25:25,4))
G1amp=(M(g,4))

G1amp=cell2mat(G1amp)

%update numbers inside curly brackets
G1all=horzcat(M{g})

[G1allmin,idx]=min(G1all(1:230),[],1)
G1minidx=idx
[G1allmax,idx]=max(G1all,[],1)
G1idx=idx

Tfoldcell=num2cell(Tfold)
Tfoldcellwithheader=vertcat('time(ms)',Tfoldcell)

G1allcell=num2cell(G1all)
G1allcellwithheader=vertcat('raw(uV)',G1allcell)

G1alltimecell=horzcat(Tfoldcellwithheader,G1allcellwithheader)
G1finalresultsheader={'G1all' 'G1allwaves' 'P1(max)' 'P1 time (ms)' 'N2(min)' 'N2 time (ms)' 'Amplitude'}
G1finalresultscellall={G1allcell,G1alltimecell,G1allmax,G1idx,G1allmin,G1minidx,G1amp}
G1finalresultscellall=vertcat(G1finalresultsheader,G1finalresultscellall)


%Group2

%G2cell=vertcat(M(2:2,:),M(25:25,:))
G2cell=M(h,:)
G2amp=M(h,4)

G2amp=cell2mat(G2amp)

%update numbers inside curly brackets
G2all=horzcat(M{h})

[G2allmin,idx]=min(G2all(1:230),[],1)
G2minidx=idx
[G2allmax,idx]=max(G2all,[],1)
G2idx=idx
G1G2diff = G1amp - G2amp

G2allcell=num2cell(G2all)
G2allcellwithheader=vertcat('raw(uV)',G2allcell)

G2alltimecell=horzcat(Tfoldcellwithheader,G2allcellwithheader)
G2finalresultsheader={'G2all' 'G2allwaves' 'P1(max)' 'P1 time (ms)' 'N2(min)' 'N2 time (ms)' 'Amplitude' 'AmpDiff'}
G2finalresultscellall={G2allcell,G2alltimecell,G2allmax,G2idx,G2allmin,G2minidx,G2amp,G1G2diff}
G2finalresultscellall=vertcat(G2finalresultsheader,G2finalresultscellall)


%traces only
%figure
%tiledlayout(tile_rows,2, 'TileSpacing','compact','Padding','compact')

nexttile
plot(Tfold,G1all,'Color','k','linewidth',2)
hold on
plot(Tfold,G1all,'k*','MarkerSize',7,'linewidth',2,'MarkerIndices',G1idx)
plot(Tfold,G1all,'ko','MarkerSize',7,'linewidth',2,'MarkerIndices',G1minidx)
plot(Tfold,G2all,'Color','r','linewidth',2)
plot(Tfold,G2all,'r*','MarkerSize',7,'linewidth',2,'MarkerIndices',G2idx)
plot(Tfold,G2all,'ro','MarkerSize',7,'linewidth',2,'MarkerIndices',G2minidx)

hold off
xlim([1,494])
ylim([-50,50])
title('exp1 mk801 M4L VEP')
xlabel('ms')
ylabel('uV')
alpha(0.3)
pbaspect([1 1 1])


%Final results

FinalResults={G1finalresultscellall,G2finalresultscellall}
FinalResultsHeader={'Group1' 'Group2'}
FinalResults=vertcat(FinalResultsHeader,FinalResults)





