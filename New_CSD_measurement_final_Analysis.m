%% This script will analyze multiple mice to be compared as 2 groups (vehicle -1, TBOA -2)
%% Put the saved workspaces into a single folder and number animals from the first group consecutively
%% and number animals from the second group consecutively after the first group
%% ex: (000_G1, 001_G1, 002_G1, 003_G1, 004_G1, 005_G2, 006_G2, 007_G2)
%% Then put the folder in the Matlab folder in Documents, and open it in the 
%% Current Folder tab to the left, and run the script.  
%% Follow prompts for input as they appear in the command window

myDir = uigetdir;
myFiles = dir(fullfile(myDir,'*.mat'));

%% input total number of animals in folder to analyze
prompt = 'How many total animals are in the analysis?'
n = input(prompt);
%n=8 %enter total number of files to be included in analysis
%M=cell(n,4)

%%


%% input how many are in the first group, creat variables for start and stop
prompt = 'How many are in the first group?'
g1 = input(prompt);

%% input how many are in the second group, create variables for start and stop 
prompt = 'How many are in the second group?'
g2 = input(prompt);

%% input how many are in the third group, create variables for start and stop
prompt = 'How many are in the third group?'
g3 = input(prompt);


%% find actual start and stop for G1 and G2 in loops
G1start = 1;
G1end = g1;
G2start = g1+1;
G2end = G2start+g2-1;
G3start = G2end + 1;
G3end = n;

%% declare variables to hold average CSD measurements for each group
G1_maxAmp = [];
G1_halfAmp = [];
G1_CSDlengthFrames = [];
G1_CSDlengthSeconds = [];
G1_CSDaucFrames = [];
G1_CSDaucSeconds = [];
G1_CSDT2MaxFrames = [];
G1_CSDT2MaxSeconds = [];
G1_CSDT2BaseFrames = [];
G1_CSDT2BaseSeconds = [];
G1_maxDistance = [];
G1_endDistance = [];
G1_FWHMFrames = [];
G1_FWHMSeconds = [];

G2_maxAmp = [];
G2_halfAmp = [];
G2_CSDlengthFrames = [];
G2_CSDlengthSeconds = [];
G2_CSDaucFrames = [];
G2_CSDaucSeconds = [];
G2_CSDT2MaxFrames = [];
G2_CSDT2MaxSeconds = [];
G2_CSDT2BaseFrames = [];
G2_CSDT2BaseSeconds = [];
G2_maxDistance = [];
G2_endDistance = [];
G2_FWHMFrames = [];
G2_FWHMSeconds = [];

%% declare variables for avg traces, plus and minus SD and SEM
avgTraces = [];
sdTraces = [];
plus_sdTraces = [];
minus_sdTraces = [];
semTraces = [];
plus_semTraces = [];
minus_semTraces = [];

%% declare variables to combine measurements per cell for each animal
MaxAvgCombined = [];
HalfMaxAvgCombined = [];
FWHMframesAvgCombined = [];
FWHMsecondsAvgCombined = [];
T2MaxFramesAvgCombined = [];
T2MaxSecondsAvgCombined = [];
T2BaseFramesAvgCombined = [];
T2BaseSecondsAvgCombined = [];
CSDlengthFramesAvgCombined = [];
CSDlengthSecondsAvgCombined = [];
CSDaucFramesAvgCombined = [];
CSDaucSecondsAvgCombined = [];
%MaxInt = []
%CSDlengthInt = []
%CSDaucInt = []

%% begin plots for avg trace per animal with either SD or SEM
figure(1);
figure(2);

expectedDataLength = [];

%% master loop for all files in folder
for k = 1:n
  baseFileName = myFiles(k).name;
  fullFileName = fullfile(myDir, baseFileName);
  fprintf(1, 'Now reading %s\n', fullFileName);
  cur = myFiles(k).name;
  F1 = load(cur);
  CSDmeasurements = F1.CSDmeasurements;
  data = F1.data;
  
  %% need to check if data columns are same length and shorten if shorter than previous 
  if k > 1
      prevlength = size(avgTraces(:,k-1));
      curlength = size(data,1);
      if prevlength < curlength
          data = data(1:prevlength,:);
      elseif curlength < prevlength
          for q=1:k
              avgTraces = avgTraces(1:curlength,:);
              sdTraces = sdTraces(1:curlength,:);
              plus_sdTraces = plus_sdTraces(1:curlength,:);
              minus_sdTraces = minus_sdTraces(1:curlength,:);
              semTraces = semTraces(1:curlength,:);
              plus_semTraces = plus_semTraces(1:curlength,:);
              minus_semTraces = minus_semTraces(1:curlength,:);
          end
      end
  end

  %% end distance and max distance
  endDistance = F1.endDistance;
  maxDistance = F1.maxDistance;
  %pause
  %disp(i)
  if k < G2start
      SIZE = size(maxDistance);
      if SIZE == 1
        G1_maxDistance = vertcat(G1_maxDistance, maxDistance);
      end
      SIZE = size(endDistance);
      if SIZE == 1
        G1_endDistance = vertcat(G1_endDistance, endDistance);
      end
  else
      SIZE = size(maxDistance);
      if SIZE == 1
        G2_maxDistance= vertcat(G2_maxDistance, maxDistance);
      end
      SIZE = size(endDistance);
      if SIZE == 1
        G2_endDistance = vertcat(G2_endDistance, endDistance);
      end
  end
  
  %% make temp vectors to hold all CSD measurements for averaging and aggregate with others
  tempMax = CSDmeasurements(1,2:end)';
  tempHalfMax = CSDmeasurements(2,2:end)';
  tempFWHMframes = CSDmeasurements(3,2:end)';
  tempFWHMseconds = CSDmeasurements(4,2:end)';
  tempT2MaxFrames = CSDmeasurements(5,2:end)';
  tempT2MaxSeconds = CSDmeasurements(6,2:end)';
  tempT2BaseFrames = CSDmeasurements(7,2:end)';
  tempT2BaseSeconds = CSDmeasurements(8,2:end)';
  tempLengthFrames = CSDmeasurements(9,2:end)';
  tempLengthSeconds = CSDmeasurements(10,2:end)';
  tempAUCframes = CSDmeasurements(11,2:end)';
  tempAUCseconds = CSDmeasurements(12,2:end)';

  %% make temp variables to make average variables
  SZ = size(tempMax,1);
  MaxInt = [];
  HalfMaxInt = [];
  FWHMframesInt = [];
  FWHMsecondsInt = [];
  T2MaxFramesInt = [];
  T2MaxSecondsInt = [];
  T2BaseFramesInt = [];
  T2BaseSecondsInt = [];
  CSDlengthFramesInt = [];
  CSDlengthSecondsInt = [];
  CSDaucframesInt = [];
  CSDaucsecondsInt = [];
  

  for i=1:SZ
      
      %% convert each measurement from string to int and add to MaxInt, CSDlengthInt and CSDaucInt
      tempMaxchar = tempMax(i,:);
      tempMaxchar = str2num(tempMaxchar);
      MaxInt = vertcat(MaxInt,tempMaxchar);

      tempHalfMaxchar = tempHalfMax(i,:);
      tempHalfMaxchar = str2num(tempHalfMaxchar);
      HalfMaxInt = vertcat(HalfMaxInt,tempHalfMaxchar);

      tempFWHMframeschar = tempFWHMframes(i,:);
      tempFWHMframeschar = str2num(tempFWHMframeschar);
      FWHMframesInt = vertcat(FWHMframesInt,tempFWHMframeschar);

      tempFWHMsecondschar = tempFWHMseconds(i,:);
      tempFWHMsecondschar = str2num(tempFWHMsecondschar);
      FWHMsecondsInt = vertcat(FWHMsecondsInt,tempFWHMsecondschar);
      
      tempT2MaxFrameschar = tempT2MaxFrames(i,:);
      tempT2MaxFrameschar = str2num(tempT2MaxFrameschar);
      T2MaxFramesInt = vertcat(T2MaxFramesInt, tempT2MaxFrameschar);
      
      tempT2MaxSecondschar = tempT2MaxSeconds(i,:);
      tempT2MaxSecondschar = str2num(tempT2MaxSecondschar);
      T2MaxSecondsInt = vertcat(T2MaxSecondsInt, tempT2MaxSecondschar);
      
      tempT2BaseFrameschar = tempT2BaseFrames(i,:);
      tempT2BaseFrameschar = str2num(tempT2BaseFrameschar);
      T2BaseFramesInt = vertcat(T2BaseFramesInt, tempT2BaseFrameschar);

      tempT2BaseSecondschar = tempT2BaseFrames(i,:);
      tempT2BaseSecondschar = str2num(tempT2BaseSecondschar);
      T2BaseSecondsInt = vertcat(T2BaseSecondsInt, tempT2BaseSecondschar);
      
      tempLengthFrameschar = tempLengthFrames(i,:);
      tempLengthFrameschar = str2num(tempLengthFrameschar);
      CSDlengthFramesInt = vertcat(CSDlengthFramesInt,tempLengthFrameschar);

      tempLengthSecondschar = tempLengthSeconds(i,:);
      tempLengthSecondschar = str2num(tempLengthSecondschar);
      CSDlengthSecondsInt = vertcat(CSDlengthSecondsInt,tempLengthSecondschar);

      tempAUCframeschar = tempAUCframes(i,:);
      tempAUCframeschar = str2num(tempAUCframeschar);
      CSDaucframesInt = vertcat(CSDaucframesInt,tempAUCframeschar);

      tempAUCsecondschar = tempAUCseconds(i,:);
      tempAUCsecondschar = str2num(tempAUCsecondschar);
      CSDaucsecondsInt = vertcat(CSDaucsecondsInt,tempAUCsecondschar);
      
  end
  
  %% calculate avg for each measurment (per cell) and add to the global vars 
  MaxIntAvg = mean(MaxInt);
  MaxAvgCombined = vertcat(MaxAvgCombined,MaxIntAvg);

  HalfMaxIntAvg = mean(HalfMaxInt);
  HalfMaxAvgCombined = vertcat(HalfMaxAvgCombined,HalfMaxIntAvg);

  FWHMframesIntAvg = mean(FWHMframesInt);
  FWHMframesAvgCombined = vertcat(FWHMframesAvgCombined,FWHMframesIntAvg);

  FWHMsecondsIntAvg = mean(FWHMsecondsInt);
  FWHMsecondsAvgCombined = vertcat(FWHMsecondsAvgCombined,FWHMsecondsIntAvg);

  T2MaxFramesIntAvg = mean(T2MaxFramesInt);
  T2MaxFramesAvgCombined = vertcat(T2MaxFramesAvgCombined,T2MaxFramesIntAvg);

  T2MaxSecondsIntAvg = mean(T2MaxSecondsInt);
  T2MaxSecondsAvgCombined = vertcat(T2MaxSecondsAvgCombined,T2MaxSecondsIntAvg);
  
  T2BaseFramesIntAvg = mean(T2BaseFramesInt);
  T2BaseFramesAvgCombined = vertcat(T2BaseFramesAvgCombined,T2BaseFramesIntAvg);

  T2BaseSecondsIntAvg = mean(T2BaseSecondsInt);
  T2BaseSecondsAvgCombined = vertcat(T2BaseSecondsAvgCombined,T2BaseSecondsIntAvg);

  CSDlengthFramesIntAvg = mean(CSDlengthFramesInt);
  CSDlengthFramesAvgCombined = vertcat(CSDlengthFramesAvgCombined,CSDlengthFramesIntAvg);

  CSDlengthSecondsIntAvg = mean(CSDlengthSecondsInt);
  CSDlengthSecondsAvgCombined = vertcat(CSDlengthSecondsAvgCombined,CSDlengthFramesIntAvg);

  CSDaucframesIntAvg = mean(CSDaucframesInt);
  CSDaucFramesAvgCombined = vertcat(CSDaucFramesAvgCombined,CSDaucframesIntAvg);

  CSDaucsecondsIntAvg = mean(CSDaucsecondsInt);
  CSDaucSecondsAvgCombined = vertcat(CSDaucSecondsAvgCombined,CSDaucframesIntAvg);

  


  %% convert nan in data to 0's, make avg trace, calculate SD and SEM
  data(isnan(data)) = 0;
  dataAvg = mean(data,2);
  avgTraces = horzcat(avgTraces,dataAvg);
  dataSD = std(data(:,i));
  sdTraces = horzcat(sdTraces,dataSD);
  sz = size(data,1);
  Cols = size(data,2);
  dataSEM = [];
  for i = 1:sz
      numSEM = std(data(i,:))/sqrt(Cols);
      dataSEM = vertcat(dataSEM,numSEM);
  end
  
  %% make avg plus and minus SD and SEM
  dataAvgPlusSD = dataAvg + dataSD;
  plus_sdTraces = horzcat(plus_sdTraces,dataAvgPlusSD);
  dataAvgMinusSD = dataAvg - dataSD;
  minus_sdTraces = horzcat(minus_sdTraces,dataAvgMinusSD);
  
  dataAvgPlusDSEM = dataAvg + dataSEM;
  plus_semTraces = horzcat(plus_semTraces,dataAvgPlusDSEM);
  dataAvgMinusSEM = dataAvg - dataSEM;
  minus_semTraces = horzcat(minus_semTraces,dataAvgMinusSEM);

  %% time variable
  Tfold = (0:(sz-1))';
  
  %% plot avg data trace with SD
  figure(1)
  hold on
  nexttile;
  patch([Tfold;flipud(Tfold)],[minus_sdTraces(:,k);flipud(plus_sdTraces(:,k))],[200 1 1]/255, 'edgecolor','none');
  hold on
  
  plot(Tfold,dataAvg,'Color','k','linewidth',2);
  
  hold off
  xlim([0,sz]);
  %ylim([-30,20])
  title('CSD average df/f traces (per animal) w/SD',k);
  xlabel('frames');
  ylabel('df/f');
  alpha(0.3);
  pbaspect([1 2 1]);
  
  %% plot avg data trace with SEM
  figure(2)
  hold on;
  nexttile;
  patch([Tfold;flipud(Tfold)],[minus_semTraces(:,k);flipud(plus_semTraces(:,k))],[200 1 1]/255, 'edgecolor','none');
  hold on
 
  plot(Tfold,dataAvg,'Color','k','linewidth',2);
  
  hold off
  xlim([0,sz]);
  title('CSD average df/f traces (per animal) w/SEM', k);
  xlabel('frames');
  ylabel('df/f');
  alpha(0.3);
  pbaspect([1 2 1]);
  
  %% add pause to inspect each trace and then clear vars
  %pause
  %disp(k)
  clearvars -except G1_maxDistance G1_endDistance G2_maxDistance G2_endDistance Tfold MaxAvgCombined HalfMaxAvgCombined FWHMframesAvgCombined FWHMsecondsAvgCombined T2MaxFramesAvgCombined T2MaxSecondsAvgCombined T2BaseFramesAvgCombined T2BaseSecondsAvgCombined CSDlengthFramesAvgCombined CSDlengthSecondsAvgCombined CSDaucFramesAvgCombined CSDaucSecondsAvgCombined CSDlengthCombined CSDlengthAvgCombined CSDaucCombined CSDaucAvgCombined myDir myFiles g1 g2 G1 G2 G1start G1end G2start G2end G1_maxAmp G1_CSDlength G1_CSDauc G2_maxAmp G2_CSDlength G2_CSDauc avgTraces sdTraces plus_sdTraces minus_sdTraces semTraces plus_semTraces minus_semTraces; 
end


G1_maxAmp = [];
G1_halfAmp = [];
G1_CSDlengthFrames = [];
G1_CSDlengthSeconds = [];
G1_CSDaucFrames = [];
G1_CSDaucSeconds = [];
G1_CSDT2MaxFrames = [];
G1_CSDT2MaxSeconds = [];
G1_CSDT2BaseFrames = [];
G1_CSDT2BaseSeconds = [];
%G1_maxDistance = []
%G1_endDistance = []
G1_FWHMFrames = [];
G1_FWHMSeconds = [];

G2_maxAmp = [];
G2_halfAmp = [];
G2_CSDlengthFrames = [];
G2_CSDlengthSeconds = [];
G2_CSDaucFrames = [];
G2_CSDaucSeconds = [];
G2_CSDT2MaxFrames = [];
G2_CSDT2MaxSeconds = [];
G2_CSDT2BaseFrames = [];
G2_CSDT2BaseSeconds = [];
%G2_maxDistance = []
%G2_endDistance = []
G2_FWHMFrames = [];
G2_FWHMSeconds = [];

G1_maxDistanceAvg = mean(G1_maxDistance);
G1_maxDistanceSD = std(G1_maxDistance);
G1_sz = size(G1_maxDistance,1);
G1_maxDistanceSEM = G1_maxDistanceSD/sqrt(G1_sz);

G1_endDistanceAvg = mean(G1_endDistance);
G1_endDistanceSD = std(G1_endDistance);
G1_endDistanceSEM = G1_endDistanceSD/sqrt(G1_sz);

G2_maxDistanceAvg = mean(G2_maxDistance);
G2_maxDistanceSD = std(G2_maxDistance);
G2_sz = size(G2_maxDistance,1);
G2_maxDistanceSEM = G2_maxDistanceSD/sqrt(G2_sz);

G2_endDistanceAvg = mean(G2_endDistance);
G2_endDistanceSD = std(G2_endDistance);
G2_endDistanceSEM = G2_endDistanceSD/sqrt(G2_sz);

for i=G1start:G1end
    
    temp = MaxAvgCombined(i,:);
    G1_maxAmp = vertcat(G1_maxAmp,temp);
    temp = HalfMaxAvgCombined(i,:);
    G1_halfAmp = vertcat(G1_halfAmp,temp);
    temp = FWHMframesAvgCombined(i,:);
    G1_FWHMFrames = vertcat(G1_FWHMFrames,temp);
    temp = FWHMsecondsAvgCombined(i,:);
    G1_FWHMSeconds = vertcat(G1_FWHMSeconds,temp);
    temp = T2MaxFramesAvgCombined(i,:);
    G1_CSDT2MaxFrames = vertcat(G1_CSDT2MaxFrames,temp);
    temp = T2MaxSecondsAvgCombined(i,:);
    G1_CSDT2MaxSeconds = vertcat(G1_CSDT2MaxSeconds,temp);
    temp = T2BaseFramesAvgCombined(i,:);
    G1_CSDT2BaseFrames = vertcat(G1_CSDT2BaseFrames,temp);
    temp = T2BaseSecondsAvgCombined(i,:);
    G1_CSDT2BaseSeconds = vertcat(G1_CSDT2BaseSeconds,temp);
    temp = CSDlengthFramesAvgCombined(i,:);
    G1_CSDlengthFrames = vertcat(G1_CSDlengthFrames,temp);
    temp = CSDlengthSecondsAvgCombined(i,:);
    G1_CSDlengthSeconds = vertcat(G1_CSDlengthSeconds,temp);
    temp = CSDaucFramesAvgCombined(i,:);
    G1_CSDaucFrames = vertcat(G1_CSDaucFrames,temp);
    temp = CSDaucSecondsAvgCombined(i,:);
    G1_CSDaucSeconds = vertcat(G1_CSDaucSeconds,temp);
end

for i = G2start:G2end
    temp = MaxAvgCombined(i,:);
    G2_maxAmp = vertcat(G2_maxAmp,temp);
    temp = HalfMaxAvgCombined(i,:);
    G2_halfAmp = vertcat(G2_halfAmp,temp);
    temp = FWHMframesAvgCombined(i,:);
    G2_FWHMFrames = vertcat(G2_FWHMFrames,temp);
    temp = FWHMsecondsAvgCombined(i,:);
    G2_FWHMSeconds = vertcat(G2_FWHMSeconds,temp);
    temp = T2MaxFramesAvgCombined(i,:);
    G2_CSDT2MaxFrames = vertcat(G2_CSDT2MaxFrames,temp);
    temp = T2MaxSecondsAvgCombined(i,:);
    G2_CSDT2MaxSeconds = vertcat(G2_CSDT2MaxSeconds,temp);
    temp = T2BaseFramesAvgCombined(i,:);
    G2_CSDT2BaseFrames = vertcat(G2_CSDT2BaseFrames,temp);
    temp = T2BaseSecondsAvgCombined(i,:);
    G2_CSDT2BaseSeconds = vertcat(G2_CSDT2BaseSeconds,temp);
    temp = CSDlengthFramesAvgCombined(i,:);
    G2_CSDlengthFrames = vertcat(G2_CSDlengthFrames,temp);
    temp = CSDlengthSecondsAvgCombined(i,:);
    G2_CSDlengthSeconds = vertcat(G2_CSDlengthSeconds,temp);
    temp = CSDaucFramesAvgCombined(i,:);
    G2_CSDaucFrames = vertcat(G2_CSDaucFrames,temp);
    temp = CSDaucSecondsAvgCombined(i,:);
    G2_CSDaucSeconds = vertcat(G2_CSDaucSeconds,temp);
end


%% make overall average traces for each group
G1_subGroup = avgTraces(:,G1start:G1end);
G2_subGroup = avgTraces(:,G2start:G2end);

G1_cols = size(G1_subGroup,2);
G2_cols = size(G2_subGroup,2);

G1avgAVGtrace = mean(G1_subGroup,2);
G2avgAVGtrace = mean(G2_subGroup,2);

G1avgAVGstd = [];
G1avgAVGsem = [];
sz = size(G1_subGroup,1);
for i=1:sz
    temp = std(G1_subGroup(i,:));
    G1avgAVGstd = vertcat(G1avgAVGstd,temp);
    temp2 = temp/sqrt(G1_cols);
    G1avgAVGsem = vertcat(G1avgAVGsem,temp2);
end

G2avgAVGstd = [];
G2avgAVGsem = [];
SZ = size(G2_subGroup,1);
for i=1:SZ
    temp = std(G1_subGroup(i,:));
    G2avgAVGstd = vertcat(G2avgAVGstd,temp);
    temp2 = temp/sqrt(G1_cols);
    G2avgAVGsem = vertcat(G2avgAVGsem,temp2);
end

G1avgAVGplusSD = G1avgAVGtrace + G1avgAVGstd;
G1avgAVGminusSD = G1avgAVGtrace - G1avgAVGstd;
G1avgAVGplusSEM = G1avgAVGtrace + G1avgAVGsem;
G1avgAVGminusSEM = G1avgAVGtrace + G1avgAVGsem;

G2avgAVGplusSD = G2avgAVGtrace + G2avgAVGstd;
G2avgAVGminusSD = G2avgAVGtrace - G2avgAVGstd;
G2avgAVGplusSEM = G2avgAVGtrace + G2avgAVGsem;
G2avgAVGminusSEM = G2avgAVGtrace + G2avgAVGsem;

figure(3)
hold on
patch([Tfold;flipud(Tfold)],[G1avgAVGminusSD;flipud(G1avgAVGplusSD)],[200 200 200]/255, 'edgecolor','none');
plot(Tfold,G1avgAVGtrace,'Color','k','linewidth',2);
patch([Tfold;flipud(Tfold)],[G2avgAVGminusSD;flipud(G2avgAVGplusSD)],[200 1 1]/255, 'edgecolor','none');
plot(Tfold,G2avgAVGtrace,'Color','r','linewidth',2);
hold off
xlim([0,sz]);
%ylim([-30,20])
title('CSD G1 average df/f traces (per animal) w/SD');
xlabel('frames');
ylabel('df/f');
alpha(0.2);
pbaspect([1 2 1]);

figure(4)
hold on
patch([Tfold;flipud(Tfold)],[G1avgAVGminusSEM;flipud(G1avgAVGplusSEM)],[200 200 200]/255, 'edgecolor','none');
hold on
plot(Tfold,G1avgAVGtrace,'Color','k','linewidth',2);
patch([Tfold;flipud(Tfold)],[G2avgAVGminusSEM;flipud(G2avgAVGplusSEM)],[200 1 1]/255, 'edgecolor','none');
plot(Tfold,G2avgAVGtrace,'Color','r','linewidth',2);
hold off
xlim([0,sz]);
%ylim([-30,20])
title('CSD G2 average df/f traces (per animal) w/SEM');
xlabel('frames');
ylabel('df/f');
alpha(0.3);
pbaspect([1 2 1]);

x=[1,2];

G1avgMaxFinal = mean(G1_maxAmp);
G1sdMaxFinal = std(G1_maxAmp);
G1semMaxFinal = G1sdMaxFinal/sqrt(G1_cols);
G1Maxlowerr=G1avgMaxFinal-G1sdMaxFinal;
G1Maxhigherr=G1avgMaxFinal+G1sdMaxFinal;

G1avgHalfMaxFinal = mean(G1_halfAmp);
G1sdHalfMaxFinal = std(G1_halfAmp);
G1semHalfMaxFinal = G1sdHalfMaxFinal/sqrt(G1_cols);
G1HalfMaxlowerr=G1avgHalfMaxFinal-G1sdHalfMaxFinal;
G1HalfMaxhigherr=G1avgHalfMaxFinal+G1sdHalfMaxFinal;

G1avgFWHMFramesFinal = mean(G1_FWHMFrames);
G1sdFWHMFramesFinal = std(G1_FWHMFrames);
G1semFWHMFramesFinal = G1sdFWHMFramesFinal/sqrt(G1_cols);
G1FWHMFrameslowerr=G1avgFWHMFramesFinal-G1sdFWHMFramesFinal;
G1FWHMFrameshigherr=G1avgFWHMFramesFinal+G1sdFWHMFramesFinal;

G1avgFWHMSecondsFinal = mean(G1_FWHMSeconds);
G1sdFWHMSecondsFinal = std(G1_FWHMSeconds);
G1semFWHMSecondsFinal = G1sdFWHMSecondsFinal/sqrt(G1_cols);
G1FWHMSecondslowerr=G1avgFWHMSecondsFinal-G1sdFWHMSecondsFinal;
G1FWHMSecondshigherr=G1avgFWHMSecondsFinal+G1sdFWHMSecondsFinal;

G1avgCSDT2MaxFramesFinal = mean(G1_CSDT2MaxFrames);
G1sdCSDT2MaxFramesFinal = std(G1_CSDT2MaxFrames);
G1semCSDT2MaxFramesFinal = G1sdCSDT2MaxFramesFinal/sqrt(G1_cols);
G1CSDT2MaxFrameslowerr=G1avgCSDT2MaxFramesFinal-G1sdCSDT2MaxFramesFinal;
G1CSDT2MaxFrameshigherr=G1avgCSDT2MaxFramesFinal+G1sdCSDT2MaxFramesFinal;

G1avgCSDT2MaxSecondsFinal = mean(G1_CSDT2MaxSeconds);
G1sdCSDT2MaxSecondsFinal = std(G1_CSDT2MaxSeconds);
G1semCSDT2MaxSecondsFinal = G1sdCSDT2MaxSecondsFinal/sqrt(G1_cols);
G1CSDT2MaxSecondslowerr=G1avgCSDT2MaxSecondsFinal-G1sdCSDT2MaxSecondsFinal;
G1CSDT2MaxSecondshigherr=G1avgCSDT2MaxSecondsFinal+G1sdCSDT2MaxSecondsFinal;

G1avgCSDT2BaseFramesFinal = mean(G1_CSDT2BaseFrames);
G1sdCSDT2BaseFramesFinal = std(G1_CSDT2BaseFrames);
G1semCSDT2BaseFramesFinal = G1sdCSDT2BaseFramesFinal/sqrt(G1_cols);
G1CSDT2BaseFrameslowerr=G1avgCSDT2BaseFramesFinal-G1sdCSDT2BaseFramesFinal;
G1CSDT2BaseFrameshigherr=G1avgCSDT2BaseFramesFinal+G1sdCSDT2BaseFramesFinal;

G1avgCSDT2BaseSecondsFinal = mean(G1_CSDT2BaseSeconds);
G1sdCSDT2BaseSecondsFinal = std(G1_CSDT2BaseSeconds);
G1semCSDT2BaseSecondsFinal = G1sdCSDT2BaseSecondsFinal/sqrt(G1_cols);
G1CSDT2BaseSecondslowerr=G1avgCSDT2BaseSecondsFinal-G1sdCSDT2BaseSecondsFinal;
G1CSDT2BaseSecondshigherr=G1avgCSDT2BaseSecondsFinal+G1sdCSDT2BaseSecondsFinal;

G1avgCSDlengthFramesFinal = mean(G1_CSDlengthFrames);
G1sdCSDlengthFramesFinal = std(G1_CSDlengthFrames);
G1semCSDlengthFramesFinal = G1sdCSDlengthFramesFinal/sqrt(G1_cols);
G1CSDlengthFrameslowerr=G1avgCSDlengthFramesFinal-G1sdCSDlengthFramesFinal;
G1CSDlengthFrameshigherr=G1avgCSDlengthFramesFinal+G1sdCSDlengthFramesFinal;

G1avgCSDlengthSecondsFinal = mean(G1_CSDlengthSeconds);
G1sdCSDlengthSecondsFinal = std(G1_CSDlengthSeconds);
G1semCSDlengthSecondsFinal = G1sdCSDlengthSecondsFinal/sqrt(G1_cols);
G1CSDlengthSecondslowerr=G1avgCSDlengthSecondsFinal-G1sdCSDlengthSecondsFinal;
G1CSDlengthSecondshigherr=G1avgCSDlengthSecondsFinal+G1sdCSDlengthSecondsFinal;

G1avgCSDaucFramesFinal = mean(G1_CSDaucFrames);
G1sdCSDaucFramesFinal = std(G1_CSDaucFrames);
G1semCSDaucFramesFinal = G1sdCSDaucFramesFinal/sqrt(G1_cols);
G1CSDaucFrameslowerr=G1avgCSDaucFramesFinal-G1sdCSDaucFramesFinal;
G1CSDaucFrameshigherr=G1avgCSDaucFramesFinal+G1sdCSDaucFramesFinal;

G1avgCSDaucSecondsFinal = mean(G1_CSDaucSeconds);
G1sdCSDaucSecondsFinal = std(G1_CSDaucSeconds);
G1semCSDaucSecondsFinal = G1sdCSDaucSecondsFinal/sqrt(G1_cols);
G1CSDaucSecondslowerr=G1avgCSDaucSecondsFinal-G1sdCSDaucSecondsFinal;
G1CSDaucSecondshigherr=G1avgCSDaucSecondsFinal+G1sdCSDaucSecondsFinal;

G2avgMaxFinal = mean(G2_maxAmp);
G2sdMaxFinal = std(G2_maxAmp);
G2semMaxFinal = G2sdMaxFinal/sqrt(G2_cols);
G2Maxlowerr=G2avgMaxFinal-G2sdMaxFinal;
G2Maxhigherr=G2avgMaxFinal+G2sdMaxFinal;

G2avgHalfMaxFinal = mean(G2_halfAmp);
G2sdHalfMaxFinal = std(G2_halfAmp);
G2semHalfMaxFinal = G2sdHalfMaxFinal/sqrt(G2_cols);
G2HalfMaxlowerr=G2avgHalfMaxFinal-G2sdHalfMaxFinal;
G2HalfMaxhigherr=G2avgHalfMaxFinal+G2sdHalfMaxFinal;

G2avgFWHMFramesFinal = mean(G2_FWHMFrames);
G2sdFWHMFramesFinal = std(G2_FWHMFrames);
G2semFWHMFramesFinal = G2sdFWHMFramesFinal/sqrt(G2_cols);
G2FWHMFrameslowerr=G2avgFWHMFramesFinal-G2sdFWHMFramesFinal;
G2FWHMFrameshigherr=G2avgFWHMFramesFinal+G2sdFWHMFramesFinal;

G2avgFWHMSecondsFinal = mean(G2_FWHMSeconds);
G2sdFWHMSecondsFinal = std(G2_FWHMSeconds);
G2semFWHMSecondsFinal = G2sdFWHMSecondsFinal/sqrt(G2_cols);
G2FWHMSecondslowerr=G2avgFWHMSecondsFinal-G2sdFWHMSecondsFinal;
G2FWHMSecondshigherr=G2avgFWHMSecondsFinal+G2sdFWHMSecondsFinal;

G2avgCSDT2MaxFramesFinal = mean(G2_CSDT2MaxFrames);
G2sdCSDT2MaxFramesFinal = std(G2_CSDT2MaxFrames);
G2semCSDT2MaxFramesFinal = G2sdCSDT2MaxFramesFinal/sqrt(G2_cols);
G2CSDT2MaxFrameslowerr=G2avgCSDT2MaxFramesFinal-G2sdCSDT2MaxFramesFinal;
G2CSDT2MaxFrameshigherr=G2avgCSDT2MaxFramesFinal+G2sdCSDT2MaxFramesFinal;

G2avgCSDT2MaxSecondsFinal = mean(G2_CSDT2MaxSeconds);
G2sdCSDT2MaxSecondsFinal = std(G2_CSDT2MaxSeconds);
G2semCSDT2MaxSecondsFinal = G2sdCSDT2MaxSecondsFinal/sqrt(G2_cols);
G2CSDT2MaxSecondslowerr=G2avgCSDT2MaxSecondsFinal-G2sdCSDT2MaxSecondsFinal;
G2CSDT2MaxSecondshigherr=G2avgCSDT2MaxSecondsFinal+G2sdCSDT2MaxSecondsFinal;

G2avgCSDT2BaseFramesFinal = mean(G2_CSDT2BaseFrames);
G2sdCSDT2BaseFramesFinal = std(G2_CSDT2BaseFrames);
G2semCSDT2BaseFramesFinal = G2sdCSDT2BaseFramesFinal/sqrt(G2_cols);
G2CSDT2BaseFrameslowerr=G2avgCSDT2BaseFramesFinal-G2sdCSDT2BaseFramesFinal;
G2CSDT2BaseFrameshigherr=G2avgCSDT2BaseFramesFinal+G2sdCSDT2BaseFramesFinal;

G2avgCSDT2BaseSecondsFinal = mean(G2_CSDT2BaseSeconds);
G2sdCSDT2BaseSecondsFinal = std(G2_CSDT2BaseSeconds);
G2semCSDT2BaseSecondsFinal = G2sdCSDT2BaseSecondsFinal/sqrt(G2_cols);
G2CSDT2BaseSecondslowerr=G2avgCSDT2BaseSecondsFinal-G2sdCSDT2BaseSecondsFinal;
G2CSDT2BaseSecondshigherr=G2avgCSDT2BaseSecondsFinal+G2sdCSDT2BaseSecondsFinal;

G2avgCSDlengthFramesFinal = mean(G2_CSDlengthFrames);
G2sdCSDlengthFramesFinal = std(G2_CSDlengthFrames);
G2semCSDlengthFramesFinal = G2sdCSDlengthFramesFinal/sqrt(G2_cols);
G2CSDlengthFrameslowerr=G2avgCSDlengthFramesFinal-G2sdCSDlengthFramesFinal;
G2CSDlengthFrameshigherr=G2avgCSDlengthFramesFinal+G2sdCSDlengthFramesFinal;

G2avgCSDlengthSecondsFinal = mean(G2_CSDlengthSeconds);
G2sdCSDlengthSecondsFinal = std(G2_CSDlengthSeconds);
G2semCSDlengthSecondsFinal = G2sdCSDlengthSecondsFinal/sqrt(G2_cols);
G2CSDlengthSecondslowerr=G2avgCSDlengthSecondsFinal-G2sdCSDlengthSecondsFinal;
G2CSDlengthSecondshigherr=G2avgCSDlengthSecondsFinal+G2sdCSDlengthSecondsFinal;

G2avgCSDaucFramesFinal = mean(G2_CSDaucFrames);
G2sdCSDaucFramesFinal = std(G2_CSDaucFrames);
G2semCSDaucFramesFinal = G2sdCSDaucFramesFinal/sqrt(G2_cols);
G2CSDaucFrameslowerr=G2avgCSDaucFramesFinal-G2sdCSDaucFramesFinal;
G2CSDaucFrameshigherr=G2avgCSDaucFramesFinal+G2sdCSDaucFramesFinal;

G2avgCSDaucSecondsFinal = mean(G2_CSDaucSeconds);
G2sdCSDaucSecondsFinal = std(G2_CSDaucSeconds);
G2semCSDaucSecondsFinal = G2sdCSDaucSecondsFinal/sqrt(G2_cols);
G2CSDaucSecondslowerr=G2avgCSDaucSecondsFinal-G2sdCSDaucSecondsFinal;
G2CSDaucSecondshigherr=G2avgCSDaucSecondsFinal+G2sdCSDaucSecondsFinal;


figure(5)
nexttile
plot(1,G1avgMaxFinal,'k.','MarkerSize',50,'DisplayName','vehicle');
hold on
plot([0.95,1.05],[(G1avgMaxFinal+G1semMaxFinal),(G1avgMaxFinal+G1semMaxFinal)],'Color','k','linewidth',3);
plot([0.95,1.05],[(G1avgMaxFinal-G1semMaxFinal),(G1avgMaxFinal-G1semMaxFinal)],'Color','k','linewidth',3);
plot([1,1],[(G1avgMaxFinal-G1semMaxFinal),(G1avgMaxFinal+G1semMaxFinal)],'Color','k','linewidth',3);

sz = size(G1_maxAmp,1);
xmin = 0.9;
xmax = 1.1;
n = sz;
g1_groupNum = xmin+rand(1,n)*(xmax-xmin);
g1_groupNum = g1_groupNum';
G1_maxAmp_plotNum = horzcat(g1_groupNum,G1_maxAmp);

for i=1:sz
    plot(G1_maxAmp_plotNum(i,1),G1_maxAmp_plotNum(i,2),'k*','MarkerSize',10,'linewidth',2,'Color',[200 200 200]/255);
    MarkerEdgeAlpha = 0.3;
end

plot(2,G2avgMaxFinal,'r.','MarkerSize',50,'DisplayName','TBOA');
plot([1.95,2.05],[(G2avgMaxFinal+G2semMaxFinal),(G2avgMaxFinal+G2semMaxFinal)],'Color','r','linewidth',3);
plot([1.95,2.05],[(G2avgMaxFinal-G2semMaxFinal),(G2avgMaxFinal-G2semMaxFinal)],'Color','r','linewidth',3);
plot([2,2],[(G2avgMaxFinal-G2semMaxFinal),(G2avgMaxFinal+G2semMaxFinal)],'Color','r','linewidth',3);

sz = size(G2_maxAmp,1);
xmin = 1.9;
xmax = 2.1;
n = sz;
g2_groupNum = xmin+rand(1,n)*(xmax-xmin);
g2_groupNum = g2_groupNum';
G2_maxAmp_plotNum = horzcat(g2_groupNum,G2_maxAmp);

for i=1:sz
    plot(G2_maxAmp_plotNum(i,1),G2_maxAmp_plotNum(i,2),'r*','MarkerSize',10,'linewidth',2,'Color',[1 0.5 0.5]);
    MarkerEdgeAlpha = 0.3;
end

ax = gca;
xticks([1 2]);
xticklabels({'vehicle','TBOA'});
xlim([0.5,2.5]);
ax.XTickLabel{2} = ['\color{red}' ax.XTickLabels{2}];
title('CSD max amplitude');
ylabel('dF/F');

hold off

nexttile

plot(1,G1avgHalfMaxFinal,'k.','MarkerSize',50,'DisplayName','vehicle');
hold on
plot([0.95,1.05],[(G1avgHalfMaxFinal+G1semHalfMaxFinal),(G1avgHalfMaxFinal+G1semHalfMaxFinal)],'Color','k','linewidth',3);
plot([0.95,1.05],[(G1avgHalfMaxFinal-G1semHalfMaxFinal),(G1avgHalfMaxFinal-G1semHalfMaxFinal)],'Color','k','linewidth',3);
plot([1,1],[(G1avgHalfMaxFinal-G1semHalfMaxFinal),(G1avgHalfMaxFinal+G1semHalfMaxFinal)],'Color','k','linewidth',3);

sz = size(G1_halfAmp,1);
xmin = 0.9;
xmax = 1.1;
n = sz;
g1_groupNum = xmin+rand(1,n)*(xmax-xmin);
g1_groupNum = g1_groupNum';
G1_halfAmp_plotNum = horzcat(g1_groupNum,G1_halfAmp);

for i=1:sz
    plot(G1_halfAmp_plotNum(i,1),G1_halfAmp_plotNum(i,2),'k*','MarkerSize',10,'linewidth',2,'Color',[200 200 200]/255);
    MarkerEdgeAlpha = 0.3;
end

plot(2,G2avgHalfMaxFinal,'r.','MarkerSize',50,'DisplayName','TBOA');
plot([1.95,2.05],[(G2avgHalfMaxFinal+G2semHalfMaxFinal),(G2avgHalfMaxFinal+G2semHalfMaxFinal)],'Color','r','linewidth',3);
plot([1.95,2.05],[(G2avgHalfMaxFinal-G2semHalfMaxFinal),(G2avgHalfMaxFinal-G2semHalfMaxFinal)],'Color','r','linewidth',3);
plot([2,2],[(G2avgHalfMaxFinal-G2semHalfMaxFinal),(G2avgHalfMaxFinal+G2semHalfMaxFinal)],'Color','r','linewidth',3);

sz = size(G2_halfAmp,1);
xmin = 1.9;
xmax = 2.1;
n = sz;
g2_groupNum = xmin+rand(1,n)*(xmax-xmin);
g2_groupNum = g2_groupNum';
G2_halfAmp_plotNum = horzcat(g2_groupNum,G2_halfAmp);

for i=1:sz
    plot(G2_halfAmp_plotNum(i,1),G2_halfAmp_plotNum(i,2),'r*','MarkerSize',10,'linewidth',2,'Color',[1 0.5 0.5]);
    MarkerEdgeAlpha = 0.3;
end

ax = gca;
xticks([1 2]);
xticklabels({'vehicle','TBOA'});
xlim([0.5,2.5]) ;
ax.XTickLabel{2} = ['\color{red}' ax.XTickLabels{2}];
title('CSD 1/2 max amplitude');
ylabel('dF/F');

hold off

nexttile

plot(1,G1avgFWHMFramesFinal,'k.','MarkerSize',50,'DisplayName','vehicle');
hold on
plot([0.95,1.05],[(G1avgFWHMFramesFinal+G1semFWHMFramesFinal),(G1avgFWHMFramesFinal+G1semFWHMFramesFinal)],'Color','k','linewidth',3);
plot([0.95,1.05],[(G1avgFWHMFramesFinal-G1semFWHMFramesFinal),(G1avgFWHMFramesFinal-G1semFWHMFramesFinal)],'Color','k','linewidth',3);
plot([1,1],[(G1avgFWHMFramesFinal-G1semFWHMFramesFinal),(G1avgFWHMFramesFinal+G1semFWHMFramesFinal)],'Color','k','linewidth',3);

sz = size(G1_FWHMFrames,1);
xmin = 0.9;
xmax = 1.1;
n = sz;
g1_groupNum = xmin+rand(1,n)*(xmax-xmin);
g1_groupNum = g1_groupNum';
G1_FWHMFrames_plotNum = horzcat(g1_groupNum,G1_FWHMFrames);

for i=1:sz
    plot(G1_FWHMFrames_plotNum(i,1),G1_FWHMFrames_plotNum(i,2),'k*','MarkerSize',10,'linewidth',2,'Color',[200 200 200]/255);
    MarkerEdgeAlpha = 0.3;
end

plot(2,G2avgFWHMFramesFinal,'r.','MarkerSize',50,'DisplayName','TBOA');
plot([1.95,2.05],[(G2avgFWHMFramesFinal+G2semFWHMFramesFinal),(G2avgFWHMFramesFinal+G2semFWHMFramesFinal)],'Color','r','linewidth',3);
plot([1.95,2.05],[(G2avgFWHMFramesFinal-G2semFWHMFramesFinal),(G2avgFWHMFramesFinal-G2semFWHMFramesFinal)],'Color','r','linewidth',3);
plot([2,2],[(G2avgFWHMFramesFinal-G2semFWHMFramesFinal),(G2avgFWHMFramesFinal+G2semFWHMFramesFinal)],'Color','r','linewidth',3);

sz = size(G2_FWHMFrames,1);
xmin = 1.9;
xmax = 2.1;
n = sz;
g2_groupNum = xmin+rand(1,n)*(xmax-xmin);
g2_groupNum = g2_groupNum';
G2_FWHMFrames_plotNum = horzcat(g2_groupNum,G2_FWHMFrames);

for i=1:sz
    plot(G2_FWHMFrames_plotNum(i,1),G2_FWHMFrames_plotNum(i,2),'r*','MarkerSize',10,'linewidth',2,'Color',[1 0.5 0.5]);
    MarkerEdgeAlpha = 0.3;
end
ax = gca;
xticks([1 2]);
xticklabels({'vehicle','TBOA'});
xlim([0.5,2.5]);
ax.XTickLabel{2} = ['\color{red}' ax.XTickLabels{2}];
title('CSD FWHM(frames)');
ylabel('frames');
%legend(['vehicle','TBOA'])
%legend('G1FWHMFrames_plotNum','G2FWHMFrames_plotNum')
hold off

nexttile

plot(1,G1avgFWHMSecondsFinal,'k.','MarkerSize',50,'DisplayName','vehicle');
hold on
plot([0.95,1.05],[(G1avgFWHMSecondsFinal+G1semFWHMSecondsFinal),(G1avgFWHMSecondsFinal+G1semFWHMSecondsFinal)],'Color','k','linewidth',3);
plot([0.95,1.05],[(G1avgFWHMSecondsFinal-G1semFWHMSecondsFinal),(G1avgFWHMSecondsFinal-G1semFWHMSecondsFinal)],'Color','k','linewidth',3);
plot([1,1],[(G1avgFWHMSecondsFinal-G1semFWHMSecondsFinal),(G1avgFWHMSecondsFinal+G1semFWHMSecondsFinal)],'Color','k','linewidth',3);

sz = size(G1_FWHMSeconds,1);
xmin = 0.9;
xmax = 1.1;
n = sz;
g1_groupNum = xmin+rand(1,n)*(xmax-xmin);
g1_groupNum = g1_groupNum';
G1_FWHMSeconds_plotNum = horzcat(g1_groupNum,G1_FWHMSeconds);

for i=1:sz
    plot(G1_FWHMSeconds_plotNum(i,1),G1_FWHMSeconds_plotNum(i,2),'k*','MarkerSize',10,'linewidth',2,'Color',[200 200 200]/255);
    MarkerEdgeAlpha = 0.3;
end

plot(2,G2avgFWHMSecondsFinal,'r.','MarkerSize',50,'DisplayName','TBOA');
plot([1.95,2.05],[(G2avgFWHMSecondsFinal+G2semFWHMSecondsFinal),(G2avgFWHMSecondsFinal+G2semFWHMSecondsFinal)],'Color','r','linewidth',3);
plot([1.95,2.05],[(G2avgFWHMSecondsFinal-G2semFWHMSecondsFinal),(G2avgFWHMSecondsFinal-G2semFWHMSecondsFinal)],'Color','r','linewidth',3);
plot([2,2],[(G2avgFWHMSecondsFinal-G2semFWHMSecondsFinal),(G2avgFWHMSecondsFinal+G2semFWHMSecondsFinal)],'Color','r','linewidth',3);

sz = size(G2_FWHMSeconds,1);
xmin = 1.9;
xmax = 2.1;
n = sz;
g2_groupNum = xmin+rand(1,n)*(xmax-xmin);
g2_groupNum = g2_groupNum';
G2_FWHMSeconds_plotNum = horzcat(g2_groupNum,G2_FWHMSeconds);

for i=1:sz
    plot(G2_FWHMSeconds_plotNum(i,1),G2_FWHMSeconds_plotNum(i,2),'r*','MarkerSize',10,'linewidth',2,'Color',[1 0.5 0.5]);
    MarkerEdgeAlpha = 0.3;
end
ax = gca;
xticks([1 2]);
xticklabels({'vehicle','TBOA'});
xlim([0.5,2.5]); 
ax.XTickLabel{2} = ['\color{red}' ax.XTickLabels{2}];
title('CSD FWHM(seconds)');
ylabel('seconds');
%legend(['vehicle','TBOA'])
%legend('G1FWHMSeconds_plotNum','G2FWHMSeconds_plotNum')
hold off

nexttile

plot(1,G1avgCSDT2MaxFramesFinal,'k.','MarkerSize',50,'DisplayName','vehicle');
hold on
plot([0.95,1.05],[(G1avgCSDT2MaxFramesFinal+G1semCSDT2MaxFramesFinal),(G1avgCSDT2MaxFramesFinal+G1semCSDT2MaxFramesFinal)],'Color','k','linewidth',3);
plot([0.95,1.05],[(G1avgCSDT2MaxFramesFinal-G1semCSDT2MaxFramesFinal),(G1avgCSDT2MaxFramesFinal-G1semCSDT2MaxFramesFinal)],'Color','k','linewidth',3);
plot([1,1],[(G1avgCSDT2MaxFramesFinal-G1semCSDT2MaxFramesFinal),(G1avgCSDT2MaxFramesFinal+G1semCSDT2MaxFramesFinal)],'Color','k','linewidth',3);

sz = size(G1_CSDT2MaxFrames,1);
xmin = 0.9;
xmax = 1.1;
n = sz;
g1_groupNum = xmin+rand(1,n)*(xmax-xmin);
g1_groupNum = g1_groupNum';
G1_CSDT2MaxFrames_plotNum = horzcat(g1_groupNum,G1_CSDT2MaxFrames);

for i=1:sz
    plot(G1_CSDT2MaxFrames_plotNum(i,1),G1_CSDT2MaxFrames_plotNum(i,2),'k*','MarkerSize',10,'linewidth',2,'Color',[200 200 200]/255);
    MarkerEdgeAlpha = 0.3;
end

plot(2,G2avgCSDT2MaxFramesFinal,'r.','MarkerSize',50,'DisplayName','TBOA');
plot([1.95,2.05],[(G2avgCSDT2MaxFramesFinal+G2semCSDT2MaxFramesFinal),(G2avgCSDT2MaxFramesFinal+G2semCSDT2MaxFramesFinal)],'Color','r','linewidth',3);
plot([1.95,2.05],[(G2avgCSDT2MaxFramesFinal-G2semCSDT2MaxFramesFinal),(G2avgCSDT2MaxFramesFinal-G2semCSDT2MaxFramesFinal)],'Color','r','linewidth',3);
plot([2,2],[(G2avgCSDT2MaxFramesFinal-G2semCSDT2MaxFramesFinal),(G2avgCSDT2MaxFramesFinal+G2semCSDT2MaxFramesFinal)],'Color','r','linewidth',3);

sz = size(G2_CSDT2MaxFrames,1);
xmin = 1.9;
xmax = 2.1;
n = sz;
g2_groupNum = xmin+rand(1,n)*(xmax-xmin);
g2_groupNum = g2_groupNum';
G2_CSDT2MaxFrames_plotNum = horzcat(g2_groupNum,G2_CSDT2MaxFrames);

for i=1:sz
    plot(G2_CSDT2MaxFrames_plotNum(i,1),G2_CSDT2MaxFrames_plotNum(i,2),'r*','MarkerSize',10,'linewidth',2,'Color',[1 0.5 0.5]);
    MarkerEdgeAlpha = 0.3;
end
ax = gca;
xticks([1 2]);
xticklabels({'vehicle','TBOA'});
xlim([0.5,2.5]);
ax.XTickLabel{2} = ['\color{red}' ax.XTickLabels{2}];
title('CSD rise time(frames)');
ylabel('frames');
hold off

nexttile

plot(1,G1avgCSDT2MaxSecondsFinal,'k.','MarkerSize',50,'DisplayName','vehicle');
hold on
plot([0.95,1.05],[(G1avgCSDT2MaxSecondsFinal+G1semCSDT2MaxSecondsFinal),(G1avgCSDT2MaxSecondsFinal+G1semCSDT2MaxSecondsFinal)],'Color','k','linewidth',3);
plot([0.95,1.05],[(G1avgCSDT2MaxSecondsFinal-G1semCSDT2MaxSecondsFinal),(G1avgCSDT2MaxSecondsFinal-G1semCSDT2MaxSecondsFinal)],'Color','k','linewidth',3);
plot([1,1],[(G1avgCSDT2MaxSecondsFinal-G1semCSDT2MaxSecondsFinal),(G1avgCSDT2MaxSecondsFinal+G1semCSDT2MaxSecondsFinal)],'Color','k','linewidth',3);

sz = size(G1_CSDT2MaxSeconds,1);
xmin = 0.9;
xmax = 1.1;
n = sz;
g1_groupNum = xmin+rand(1,n)*(xmax-xmin);
g1_groupNum = g1_groupNum';
G1_CSDT2MaxSeconds_plotNum = horzcat(g1_groupNum,G1_CSDT2MaxSeconds);

for i=1:sz
    plot(G1_CSDT2MaxSeconds_plotNum(i,1),G1_CSDT2MaxSeconds_plotNum(i,2),'k*','MarkerSize',10,'linewidth',2,'Color',[200 200 200]/255);
    MarkerEdgeAlpha = 0.3;
end

plot(2,G2avgCSDT2MaxSecondsFinal,'r.','MarkerSize',50,'DisplayName','TBOA');
plot([1.95,2.05],[(G2avgCSDT2MaxSecondsFinal+G2semCSDT2MaxSecondsFinal),(G2avgCSDT2MaxSecondsFinal+G2semCSDT2MaxSecondsFinal)],'Color','r','linewidth',3);
plot([1.95,2.05],[(G2avgCSDT2MaxSecondsFinal-G2semCSDT2MaxSecondsFinal),(G2avgCSDT2MaxSecondsFinal-G2semCSDT2MaxSecondsFinal)],'Color','r','linewidth',3);
plot([2,2],[(G2avgCSDT2MaxSecondsFinal-G2semCSDT2MaxSecondsFinal),(G2avgCSDT2MaxSecondsFinal+G2semCSDT2MaxSecondsFinal)],'Color','r','linewidth',3);

sz = size(G2_CSDT2MaxSeconds,1);
xmin = 1.9;
xmax = 2.1;
n = sz;
g2_groupNum = xmin+rand(1,n)*(xmax-xmin);
g2_groupNum = g2_groupNum';
G2_CSDT2MaxSeconds_plotNum = horzcat(g2_groupNum,G2_CSDT2MaxSeconds);

for i=1:sz
    plot(G2_CSDT2MaxSeconds_plotNum(i,1),G2_CSDT2MaxSeconds_plotNum(i,2),'r*','MarkerSize',10,'linewidth',2,'Color',[1 0.5 0.5]);
    MarkerEdgeAlpha = 0.3;
end
ax = gca;
xticks([1 2]);
xticklabels({'vehicle','TBOA'});
xlim([0.5,2.5]); 
ax.XTickLabel{2} = ['\color{red}' ax.XTickLabels{2}];
title('CSD rise time(seconds)');
ylabel('seconds');
%legend(['vehicle','TBOA'])
%legend('G1CSDT2MaxSeconds_plotNum','G2CSDT2MaxSeconds_plotNum')
hold off

nexttile

plot(1,G1avgCSDT2BaseFramesFinal,'k.','MarkerSize',50,'DisplayName','vehicle');
hold on
plot([0.95,1.05],[(G1avgCSDT2BaseFramesFinal+G1semCSDT2BaseFramesFinal),(G1avgCSDT2BaseFramesFinal+G1semCSDT2BaseFramesFinal)],'Color','k','linewidth',3);
plot([0.95,1.05],[(G1avgCSDT2BaseFramesFinal-G1semCSDT2BaseFramesFinal),(G1avgCSDT2BaseFramesFinal-G1semCSDT2BaseFramesFinal)],'Color','k','linewidth',3);
plot([1,1],[(G1avgCSDT2BaseFramesFinal-G1semCSDT2BaseFramesFinal),(G1avgCSDT2BaseFramesFinal+G1semCSDT2BaseFramesFinal)],'Color','k','linewidth',3);

sz = size(G1_CSDT2BaseFrames,1);
xmin = 0.9;
xmax = 1.1;
n = sz;
g1_groupNum = xmin+rand(1,n)*(xmax-xmin);
g1_groupNum = g1_groupNum';
G1_CSDT2BaseFrames_plotNum = horzcat(g1_groupNum,G1_CSDT2BaseFrames);

for i=1:sz
    plot(G1_CSDT2BaseFrames_plotNum(i,1),G1_CSDT2BaseFrames_plotNum(i,2),'k*','MarkerSize',10,'linewidth',2,'Color',[200 200 200]/255);
    MarkerEdgeAlpha = 0.3;
end

plot(2,G2avgCSDT2BaseFramesFinal,'r.','MarkerSize',50,'DisplayName','TBOA');
plot([1.95,2.05],[(G2avgCSDT2BaseFramesFinal+G2semCSDT2BaseFramesFinal),(G2avgCSDT2BaseFramesFinal+G2semCSDT2BaseFramesFinal)],'Color','r','linewidth',3);
plot([1.95,2.05],[(G2avgCSDT2BaseFramesFinal-G2semCSDT2BaseFramesFinal),(G2avgCSDT2BaseFramesFinal-G2semCSDT2BaseFramesFinal)],'Color','r','linewidth',3);
plot([2,2],[(G2avgCSDT2BaseFramesFinal-G2semCSDT2BaseFramesFinal),(G2avgCSDT2BaseFramesFinal+G2semCSDT2BaseFramesFinal)],'Color','r','linewidth',3);

sz = size(G2_CSDT2BaseFrames,1);
xmin = 1.9;
xmax = 2.1;
n = sz;
g2_groupNum = xmin+rand(1,n)*(xmax-xmin);
g2_groupNum = g2_groupNum';
G2_CSDT2BaseFrames_plotNum = horzcat(g2_groupNum,G2_CSDT2BaseFrames);

for i=1:sz
    plot(G2_CSDT2BaseFrames_plotNum(i,1),G2_CSDT2BaseFrames_plotNum(i,2),'r*','MarkerSize',10,'linewidth',2,'Color',[1 0.5 0.5]);
    MarkerEdgeAlpha = 0.3;
end
ax = gca;
xticks([1 2]);
xticklabels({'vehicle','TBOA'});
xlim([0.5,2.5]);
ax.XTickLabel{2} = ['\color{red}' ax.XTickLabels{2}];
title('CSD decay time(frames)');
ylabel('frames');
hold off

nexttile

plot(1,G1avgCSDT2BaseSecondsFinal,'k.','MarkerSize',50,'DisplayName','vehicle');
hold on
plot([0.95,1.05],[(G1avgCSDT2BaseSecondsFinal+G1semCSDT2BaseSecondsFinal),(G1avgCSDT2BaseSecondsFinal+G1semCSDT2BaseSecondsFinal)],'Color','k','linewidth',3);
plot([0.95,1.05],[(G1avgCSDT2BaseSecondsFinal-G1semCSDT2BaseSecondsFinal),(G1avgCSDT2BaseSecondsFinal-G1semCSDT2BaseSecondsFinal)],'Color','k','linewidth',3);
plot([1,1],[(G1avgCSDT2BaseSecondsFinal-G1semCSDT2BaseSecondsFinal),(G1avgCSDT2BaseSecondsFinal+G1semCSDT2BaseSecondsFinal)],'Color','k','linewidth',3);

sz = size(G1_CSDT2BaseSeconds,1);
xmin = 0.9;
xmax = 1.1;
n = sz;
g1_groupNum = xmin+rand(1,n)*(xmax-xmin);
g1_groupNum = g1_groupNum';
G1_CSDT2BaseSeconds_plotNum = horzcat(g1_groupNum,G1_CSDT2BaseSeconds);

for i=1:sz
    plot(G1_CSDT2BaseSeconds_plotNum(i,1),G1_CSDT2BaseSeconds_plotNum(i,2),'k*','MarkerSize',10,'linewidth',2,'Color',[200 200 200]/255);
    MarkerEdgeAlpha = 0.3;
end

plot(2,G2avgCSDT2BaseSecondsFinal,'r.','MarkerSize',50,'DisplayName','TBOA');
plot([1.95,2.05],[(G2avgCSDT2BaseSecondsFinal+G2semCSDT2BaseSecondsFinal),(G2avgCSDT2BaseSecondsFinal+G2semCSDT2BaseSecondsFinal)],'Color','r','linewidth',3);
plot([1.95,2.05],[(G2avgCSDT2BaseSecondsFinal-G2semCSDT2BaseSecondsFinal),(G2avgCSDT2BaseSecondsFinal-G2semCSDT2BaseSecondsFinal)],'Color','r','linewidth',3);
plot([2,2],[(G2avgCSDT2BaseSecondsFinal-G2semCSDT2BaseSecondsFinal),(G2avgCSDT2BaseSecondsFinal+G2semCSDT2BaseSecondsFinal)],'Color','r','linewidth',3);

sz = size(G2_CSDT2BaseSeconds,1);
xmin = 1.9;
xmax = 2.1;
n = sz;
g2_groupNum = xmin+rand(1,n)*(xmax-xmin);
g2_groupNum = g2_groupNum';
G2_CSDT2BaseSeconds_plotNum = horzcat(g2_groupNum,G2_CSDT2BaseSeconds);

for i=1:sz
    plot(G2_CSDT2BaseSeconds_plotNum(i,1),G2_CSDT2BaseSeconds_plotNum(i,2),'r*','MarkerSize',10,'linewidth',2,'Color',[1 0.5 0.5]);
    MarkerEdgeAlpha = 0.3;
end
ax = gca;
xticks([1 2]);
xticklabels({'vehicle','TBOA'});
xlim([0.5,2.5]);
ax.XTickLabel{2} = ['\color{red}' ax.XTickLabels{2}];
title('CSD decay time(seconds)');
ylabel('seconds');
hold off

nexttile

plot(1,G1avgCSDlengthFramesFinal,'k.','MarkerSize',50,'DisplayName','vehicle');
hold on
plot([0.95,1.05],[(G1avgCSDlengthFramesFinal+G1semCSDlengthFramesFinal),(G1avgCSDlengthFramesFinal+G1semCSDlengthFramesFinal)],'Color','k','linewidth',3);
plot([0.95,1.05],[(G1avgCSDlengthFramesFinal-G1semCSDlengthFramesFinal),(G1avgCSDlengthFramesFinal-G1semCSDlengthFramesFinal)],'Color','k','linewidth',3);
plot([1,1],[(G1avgCSDlengthFramesFinal-G1semCSDlengthFramesFinal),(G1avgCSDlengthFramesFinal+G1semCSDlengthFramesFinal)],'Color','k','linewidth',3);

sz = size(G1_CSDlengthFrames,1);
xmin = 0.9;
xmax = 1.1;
n = sz;
g1_groupNum = xmin+rand(1,n)*(xmax-xmin);
g1_groupNum = g1_groupNum';
G1_CSDlengthFrames_plotNum = horzcat(g1_groupNum,G1_CSDlengthFrames);

for i=1:sz
    plot(G1_CSDlengthFrames_plotNum(i,1),G1_CSDlengthFrames_plotNum(i,2),'k*','MarkerSize',10,'linewidth',2,'Color',[200 200 200]/255);
    MarkerEdgeAlpha = 0.3;
end

plot(2,G2avgCSDlengthFramesFinal,'r.','MarkerSize',50,'DisplayName','TBOA');
plot([1.95,2.05],[(G2avgCSDlengthFramesFinal+G2semCSDlengthFramesFinal),(G2avgCSDlengthFramesFinal+G2semCSDlengthFramesFinal)],'Color','r','linewidth',3);
plot([1.95,2.05],[(G2avgCSDlengthFramesFinal-G2semCSDlengthFramesFinal),(G2avgCSDlengthFramesFinal-G2semCSDlengthFramesFinal)],'Color','r','linewidth',3);
plot([2,2],[(G2avgCSDlengthFramesFinal-G2semCSDlengthFramesFinal),(G2avgCSDlengthFramesFinal+G2semCSDlengthFramesFinal)],'Color','r','linewidth',3);

sz = size(G2_CSDlengthFrames,1);
xmin = 1.9;
xmax = 2.1;
n = sz;
g2_groupNum = xmin+rand(1,n)*(xmax-xmin);
g2_groupNum = g2_groupNum';
G2_CSDlengthFrames_plotNum = horzcat(g2_groupNum,G2_CSDlengthFrames);

for i=1:sz
    plot(G2_CSDlengthFrames_plotNum(i,1),G2_CSDlengthFrames_plotNum(i,2),'r*','MarkerSize',10,'linewidth',2,'Color',[1 0.5 0.5]);
    MarkerEdgeAlpha = 0.3;
end
ax = gca;
xticks([1 2]);
xticklabels({'vehicle','TBOA'});
xlim([0.5,2.5]);
ax.XTickLabel{2} = ['\color{red}' ax.XTickLabels{2}];
title('CSD length(frames)');
ylabel('frames');
hold off

nexttile

plot(1,G1avgCSDlengthSecondsFinal,'k.','MarkerSize',50,'DisplayName','vehicle');
hold on
plot([0.95,1.05],[(G1avgCSDlengthSecondsFinal+G1semCSDlengthSecondsFinal),(G1avgCSDlengthSecondsFinal+G1semCSDlengthSecondsFinal)],'Color','k','linewidth',3);
plot([0.95,1.05],[(G1avgCSDlengthSecondsFinal-G1semCSDlengthSecondsFinal),(G1avgCSDlengthSecondsFinal-G1semCSDlengthSecondsFinal)],'Color','k','linewidth',3);
plot([1,1],[(G1avgCSDlengthSecondsFinal-G1semCSDlengthSecondsFinal),(G1avgCSDlengthSecondsFinal+G1semCSDlengthSecondsFinal)],'Color','k','linewidth',3);

sz = size(G1_CSDlengthSeconds,1);
xmin = 0.9;
xmax = 1.1;
n = sz;
g1_groupNum = xmin+rand(1,n)*(xmax-xmin);
g1_groupNum = g1_groupNum';
G1_CSDlengthSeconds_plotNum = horzcat(g1_groupNum,G1_CSDlengthSeconds);

for i=1:sz
    plot(G1_CSDlengthSeconds_plotNum(i,1),G1_CSDlengthSeconds_plotNum(i,2),'k*','MarkerSize',10,'linewidth',2,'Color',[200 200 200]/255);
    MarkerEdgeAlpha = 0.3;
end

plot(2,G2avgCSDlengthSecondsFinal,'r.','MarkerSize',50,'DisplayName','TBOA');
plot([1.95,2.05],[(G2avgCSDlengthSecondsFinal+G2semCSDlengthSecondsFinal),(G2avgCSDlengthSecondsFinal+G2semCSDlengthSecondsFinal)],'Color','r','linewidth',3);
plot([1.95,2.05],[(G2avgCSDlengthSecondsFinal-G2semCSDlengthSecondsFinal),(G2avgCSDlengthSecondsFinal-G2semCSDlengthSecondsFinal)],'Color','r','linewidth',3);
plot([2,2],[(G2avgCSDlengthSecondsFinal-G2semCSDlengthSecondsFinal),(G2avgCSDlengthSecondsFinal+G2semCSDlengthSecondsFinal)],'Color','r','linewidth',3);

sz = size(G2_CSDlengthSeconds,1);
xmin = 1.9;
xmax = 2.1;
n = sz;
g2_groupNum = xmin+rand(1,n)*(xmax-xmin);
g2_groupNum = g2_groupNum';
G2_CSDlengthSeconds_plotNum = horzcat(g2_groupNum,G2_CSDlengthSeconds);

for i=1:sz
    plot(G2_CSDlengthSeconds_plotNum(i,1),G2_CSDlengthSeconds_plotNum(i,2),'r*','MarkerSize',10,'linewidth',2,'Color',[1 0.5 0.5]);
    MarkerEdgeAlpha = 0.3;
end
ax = gca;
xticks([1 2]);
xticklabels({'vehicle','TBOA'});
xlim([0.5,2.5]);
ax.XTickLabel{2} = ['\color{red}' ax.XTickLabels{2}];
title('CSD length(seconds)');
ylabel('seconds');
hold off

nexttile

plot(1,G1avgCSDaucFramesFinal,'k.','MarkerSize',50,'DisplayName','vehicle');
hold on
plot([0.95,1.05],[(G1avgCSDaucFramesFinal+G1semCSDaucFramesFinal),(G1avgCSDaucFramesFinal+G1semCSDaucFramesFinal)],'Color','k','linewidth',3);
plot([0.95,1.05],[(G1avgCSDaucFramesFinal-G1semCSDaucFramesFinal),(G1avgCSDaucFramesFinal-G1semCSDaucFramesFinal)],'Color','k','linewidth',3);
plot([1,1],[(G1avgCSDaucFramesFinal-G1semCSDaucFramesFinal),(G1avgCSDaucFramesFinal+G1semCSDaucFramesFinal)],'Color','k','linewidth',3);

sz = size(G1_CSDaucFrames,1);
xmin = 0.9;
xmax = 1.1;
n = sz;
g1_groupNum = xmin+rand(1,n)*(xmax-xmin);
g1_groupNum = g1_groupNum';
G1_CSDaucFrames_plotNum = horzcat(g1_groupNum,G1_CSDaucFrames);

for i=1:sz
    plot(G1_CSDaucFrames_plotNum(i,1),G1_CSDaucFrames_plotNum(i,2),'k*','MarkerSize',10,'linewidth',2,'Color',[200 200 200]/255);
    MarkerEdgeAlpha = 0.3;
end

plot(2,G2avgCSDaucFramesFinal,'r.','MarkerSize',50,'DisplayName','TBOA');
plot([1.95,2.05],[(G2avgCSDaucFramesFinal+G2semCSDaucFramesFinal),(G2avgCSDaucFramesFinal+G2semCSDaucFramesFinal)],'Color','r','linewidth',3);
plot([1.95,2.05],[(G2avgCSDaucFramesFinal-G2semCSDaucFramesFinal),(G2avgCSDaucFramesFinal-G2semCSDaucFramesFinal)],'Color','r','linewidth',3);
plot([2,2],[(G2avgCSDaucFramesFinal-G2semCSDaucFramesFinal),(G2avgCSDaucFramesFinal+G2semCSDaucFramesFinal)],'Color','r','linewidth',3);

sz = size(G2_CSDaucFrames,1);
xmin = 1.9;
xmax = 2.1;
n = sz;
g2_groupNum = xmin+rand(1,n)*(xmax-xmin);
g2_groupNum = g2_groupNum';
G2_CSDaucFrames_plotNum = horzcat(g2_groupNum,G2_CSDaucFrames);;

for i=1:sz
    plot(G2_CSDaucFrames_plotNum(i,1),G2_CSDaucFrames_plotNum(i,2),'r*','MarkerSize',10,'linewidth',2,'Color',[1 0.5 0.5])
    MarkerEdgeAlpha = 0.3
end
ax = gca;
xticks([1 2]);
xticklabels({'vehicle','TBOA'});
xlim([0.5,2.5]);
ax.XTickLabel{2} = ['\color{red}' ax.XTickLabels{2}];
title('CSD Ca++ load(frames)');
ylabel('dF/F/frame');
%legend(['vehicle','TBOA'])
%legend('G1CSDaucFrames_plotNum','G2CSDaucFrames_plotNum')
hold off

nexttile

plot(1,G1avgCSDaucSecondsFinal,'k.','MarkerSize',50,'DisplayName','vehicle');
hold on
plot([0.95,1.05],[(G1avgCSDaucSecondsFinal+G1semCSDaucSecondsFinal),(G1avgCSDaucSecondsFinal+G1semCSDaucSecondsFinal)],'Color','k','linewidth',3);
plot([0.95,1.05],[(G1avgCSDaucSecondsFinal-G1semCSDaucSecondsFinal),(G1avgCSDaucSecondsFinal-G1semCSDaucSecondsFinal)],'Color','k','linewidth',3);
plot([1,1],[(G1avgCSDaucSecondsFinal-G1semCSDaucSecondsFinal),(G1avgCSDaucSecondsFinal+G1semCSDaucSecondsFinal)],'Color','k','linewidth',3);

sz = size(G1_CSDaucSeconds,1);
xmin = 0.9;
xmax = 1.1;
n = sz;
g1_groupNum = xmin+rand(1,n)*(xmax-xmin);
g1_groupNum = g1_groupNum';
G1_CSDaucSeconds_plotNum = horzcat(g1_groupNum,G1_CSDaucSeconds);

for i=1:sz
    plot(G1_CSDaucSeconds_plotNum(i,1),G1_CSDaucSeconds_plotNum(i,2),'k*','MarkerSize',10,'linewidth',2,'Color',[200 200 200]/255);
    MarkerEdgeAlpha = 0.3;
end

plot(2,G2avgCSDaucSecondsFinal,'r.','MarkerSize',50,'DisplayName','TBOA');
plot([1.95,2.05],[(G2avgCSDaucSecondsFinal+G2semCSDaucSecondsFinal),(G2avgCSDaucSecondsFinal+G2semCSDaucSecondsFinal)],'Color','r','linewidth',3);
plot([1.95,2.05],[(G2avgCSDaucSecondsFinal-G2semCSDaucSecondsFinal),(G2avgCSDaucSecondsFinal-G2semCSDaucSecondsFinal)],'Color','r','linewidth',3);
plot([2,2],[(G2avgCSDaucSecondsFinal-G2semCSDaucSecondsFinal),(G2avgCSDaucSecondsFinal+G2semCSDaucSecondsFinal)],'Color','r','linewidth',3);

sz = size(G2_CSDaucSeconds,1);
xmin = 1.9;
xmax = 2.1;
n = sz;
g2_groupNum = xmin+rand(1,n)*(xmax-xmin);
g2_groupNum = g2_groupNum';
G2_CSDaucSeconds_plotNum = horzcat(g2_groupNum,G2_CSDaucSeconds);

for i=1:sz
    plot(G2_CSDaucSeconds_plotNum(i,1),G2_CSDaucSeconds_plotNum(i,2),'r*','MarkerSize',10,'linewidth',2,'Color',[1 0.5 0.5]);
    MarkerEdgeAlpha = 0.3;
end
ax = gca;
xticks([1 2]);
xticklabels({'vehicle','TBOA'});
xlim([0.5,2.5]);
ax.XTickLabel{2} = ['\color{red}' ax.XTickLabels{2}];
title('CSD Ca++ load(seconds)');
ylabel('dF/F/second');
%legend(['vehicle','TBOA'])
%legend('G1CSDaucSeconds_plotNum','G2CSDaucSeconds_plotNum')
hold off

nexttile

plot(1,G1_maxDistanceAvg,'k.','MarkerSize',50,'DisplayName','vehicle');
hold on
plot([0.95,1.05],[(G1_maxDistanceAvg+G1_maxDistanceSEM),(G1_maxDistanceAvg+G1_maxDistanceSEM)],'Color','k','linewidth',3);
plot([0.95,1.05],[(G1_maxDistanceAvg-G1_maxDistanceSEM),(G1_maxDistanceAvg-G1_maxDistanceSEM)],'Color','k','linewidth',3);
plot([1,1],[(G1_maxDistanceAvg-G1_maxDistanceSEM),(G1_maxDistanceAvg+G1_maxDistanceSEM)],'Color','k','linewidth',3);

sz = size(G1_maxDistance,1);
xmin = 0.9;
xmax = 1.1;
n = sz;
g1_groupNum = xmin+rand(1,n)*(xmax-xmin);
g1_groupNum = g1_groupNum';
G1_maxDistance_plotNum = horzcat(g1_groupNum,G1_maxDistance);

for i=1:sz
    plot(G1_maxDistance_plotNum(i,1),G1_maxDistance_plotNum(i,2),'k*','MarkerSize',10,'linewidth',2,'Color',[200 200 200]/255);
    MarkerEdgeAlpha = 0.3;
end

plot(2,G2_maxDistanceAvg,'r.','MarkerSize',50,'DisplayName','vehicle');
hold on
plot([1.95,2.05],[(G2_maxDistanceAvg+G2_maxDistanceSEM),(G2_maxDistanceAvg+G2_maxDistanceSEM)],'Color','r','linewidth',3);
plot([1.95,2.05],[(G2_maxDistanceAvg-G2_maxDistanceSEM),(G2_maxDistanceAvg-G2_maxDistanceSEM)],'Color','r','linewidth',3);
plot([2,2],[(G2_maxDistanceAvg-G2_maxDistanceSEM),(G2_maxDistanceAvg+G2_maxDistanceSEM)],'Color','r','linewidth',3);

sz = size(G2_maxDistance,1);
xmin = 1.9;
xmax = 2.1;
n = sz;
g2_groupNum = xmin+rand(1,n)*(xmax-xmin);
g2_groupNum = g2_groupNum';
G2_maxDistance_plotNum = horzcat(g2_groupNum,G2_maxDistance);

for i=1:sz
    plot(G2_maxDistance_plotNum(i,1),G2_maxDistance_plotNum(i,2),'r*','MarkerSize',10,'linewidth',2,'Color',[1 0.5 0.5]);
    MarkerEdgeAlpha = 0.3;
end
ax = gca;
xticks([1 2]);
xticklabels({'vehicle','TBOA'});
xlim([0.5,2.5]); 
ax.XTickLabel{2} = ['\color{red}' ax.XTickLabels{2}];
title('CSD max tissue displacement(pixels)');
ylabel('pixels');
%legend(['vehicle','TBOA'])
%legend('G1_maxDistance_plotNum','G2_maxDistance_plotNum')
hold off

nexttile

plot(1,G1_endDistanceAvg,'k.','MarkerSize',50,'DisplayName','vehicle');
hold on
plot([0.95,1.05],[(G1_endDistanceAvg+G1_endDistanceSEM),(G1_endDistanceAvg+G1_endDistanceSEM)],'Color','k','linewidth',3);
plot([0.95,1.05],[(G1_endDistanceAvg-G1_endDistanceSEM),(G1_endDistanceAvg-G1_endDistanceSEM)],'Color','k','linewidth',3);
plot([1,1],[(G1_endDistanceAvg-G1_endDistanceSEM),(G1_endDistanceAvg+G1_endDistanceSEM)],'Color','k','linewidth',3);

sz = size(G1_endDistance,1);
xmin = 0.9;
xmax = 1.1;
n = sz;
g1_groupNum = xmin+rand(1,n)*(xmax-xmin);
g1_groupNum = g1_groupNum';
G1_endDistance_plotNum = horzcat(g1_groupNum,G1_endDistance);

for i=1:sz
    plot(G1_endDistance_plotNum(i,1),G1_endDistance_plotNum(i,2),'k*','MarkerSize',10,'linewidth',2,'Color',[200 200 200]/255);
    MarkerEdgeAlpha = 0.3;
end

plot(2,G2_endDistanceAvg,'r.','MarkerSize',50,'DisplayName','vehicle');
hold on
plot([1.95,2.05],[(G2_endDistanceAvg+G2_endDistanceSEM),(G2_endDistanceAvg+G2_endDistanceSEM)],'Color','r','linewidth',3);
plot([1.95,2.05],[(G2_endDistanceAvg-G2_endDistanceSEM),(G2_endDistanceAvg-G2_endDistanceSEM)],'Color','r','linewidth',3);
plot([2,2],[(G2_endDistanceAvg-G2_endDistanceSEM),(G2_endDistanceAvg+G2_endDistanceSEM)],'Color','r','linewidth',3);

sz = size(G2_endDistance,1);
xmin = 1.9;
xmax = 2.1;
n = sz;
g2_groupNum = xmin+rand(1,n)*(xmax-xmin);
g2_groupNum = g2_groupNum';
G2_endDistance_plotNum = horzcat(g2_groupNum,G2_endDistance);

for i=1:sz
    plot(G2_endDistance_plotNum(i,1),G2_endDistance_plotNum(i,2),'r*','MarkerSize',10,'linewidth',2,'Color',[1 0.5 0.5]);
    MarkerEdgeAlpha = 0.3;
end
ax = gca;
xticks([1 2]);
xticklabels({'vehicle','TBOA'});
xlim([0.5,2.5]); 
ax.XTickLabel{2} = ['\color{red}' ax.XTickLabels{2}];
title('CSD end tissue displacement(pixels)');
ylabel('pixels');
hold off



%Good bar graph
figure(6)
bar(x(:,1),G1avgMaxFinal,'FaceColor',[200 200 200]/250,'EdgeColor','k','linewidth',5);
hold on
er=errorbar(x(:,1),G1avgMaxFinal,G1semMaxFinal,'color','k','linewidth',5);

bar(x(:,2),G2avgMaxFinal,'FaceColor',[1 0.8 0.8],'EdgeColor','r','linewidth',5);
er=errorbar(x(:,2),G2avgMaxFinal,G2semMaxFinal,'color','r','linewidth',5);

title('G1 vs G2 max CSD Amplitude with SEM');

hold off

%figure(6)
nexttile
bar(x(:,1),G1avgHalfMaxFinal,'FaceColor',[200 200 200]/250,'EdgeColor','k','linewidth',5);
hold on
er=errorbar(x(:,1),G1avgHalfMaxFinal,G1semHalfMaxFinal,'color','k','linewidth',5);

bar(x(:,2),G2avgHalfMaxFinal,'FaceColor',[1 0.8 0.8],'EdgeColor','r','linewidth',5);
er=errorbar(x(:,2),G2avgHalfMaxFinal,G2semHalfMaxFinal,'color','r','linewidth',5);

title('G1 vs G2 1/2 max CSD amplitude with SEM');

hold off

%figure(7)
nexttile
bar(x(:,1),G1avgFWHMFramesFinal,'FaceColor',[200 200 200]/250,'EdgeColor','k','linewidth',5);
hold on
er=errorbar(x(:,1),G1avgFWHMFramesFinal,G1semFWHMFramesFinal,'color','k','linewidth',5);

bar(x(:,2),G2avgFWHMFramesFinal,'FaceColor',[1 0.8 0.8],'EdgeColor','r','linewidth',5);
er=errorbar(x(:,2),G2avgFWHMFramesFinal,G2semFWHMFramesFinal,'color','r','linewidth',5);

title('G1 vs G2 CSD FWHM(frames) with SEM');

hold off

%figure(7)
nexttile
bar(x(:,1),G1avgFWHMSecondsFinal,'FaceColor',[200 200 200]/250,'EdgeColor','k','linewidth',5);
hold on
er=errorbar(x(:,1),G1avgFWHMSecondsFinal,G1semFWHMSecondsFinal,'color','k','linewidth',5);

bar(x(:,2),G2avgFWHMSecondsFinal,'FaceColor',[1 0.8 0.8],'EdgeColor','r','linewidth',5);
er=errorbar(x(:,2),G2avgFWHMSecondsFinal,G2semFWHMSecondsFinal,'color','r','linewidth',5);

title('G1 vs G2 CSD FWHM(seconds) with SEM');

hold off

%figure(7)
nexttile
bar(x(:,1),G1avgCSDT2MaxFramesFinal,'FaceColor',[200 200 200]/250,'EdgeColor','k','linewidth',5);
hold on
er=errorbar(x(:,1),G1avgCSDT2MaxFramesFinal,G1semCSDT2MaxFramesFinal,'color','k','linewidth',5);

bar(x(:,2),G2avgCSDT2MaxFramesFinal,'FaceColor',[1 0.8 0.8],'EdgeColor','r','linewidth',5);
er=errorbar(x(:,2),G2avgCSDT2MaxFramesFinal,G2semCSDT2MaxFramesFinal,'color','r','linewidth',5);

title('G1 vs G2 CSD rise(frames) with SEM');

hold off

%figure(7)
nexttile
bar(x(:,1),G1avgCSDT2MaxSecondsFinal,'FaceColor',[200 200 200]/250,'EdgeColor','k','linewidth',5);
hold on
er=errorbar(x(:,1),G1avgCSDT2MaxSecondsFinal,G1semCSDT2MaxSecondsFinal,'color','k','linewidth',5);

bar(x(:,2),G2avgCSDT2MaxSecondsFinal,'FaceColor',[1 0.8 0.8],'EdgeColor','r','linewidth',5);
er=errorbar(x(:,2),G2avgCSDT2MaxSecondsFinal,G2semCSDT2MaxSecondsFinal,'color','r','linewidth',5);

title('G1 vs G2 CSD rise(seconds) with SEM');

hold off

%figure(7)
nexttile
bar(x(:,1),G1avgCSDT2BaseFramesFinal,'FaceColor',[200 200 200]/250,'EdgeColor','k','linewidth',5);
hold on
er=errorbar(x(:,1),G1avgCSDT2BaseFramesFinal,G1semCSDT2BaseFramesFinal,'color','k','linewidth',5);

bar(x(:,2),G2avgCSDT2BaseFramesFinal,'FaceColor',[1 0.8 0.8],'EdgeColor','r','linewidth',5);
er=errorbar(x(:,2),G2avgCSDT2BaseFramesFinal,G2semCSDT2BaseFramesFinal,'color','r','linewidth',5);

title('G1 vs G2 CSD decay(frames) with SEM');

hold off

%figure(7)
nexttile
bar(x(:,1),G1avgCSDT2BaseSecondsFinal,'FaceColor',[200 200 200]/250,'EdgeColor','k','linewidth',5);
hold on
er=errorbar(x(:,1),G1avgCSDT2BaseSecondsFinal,G1semCSDT2BaseSecondsFinal,'color','k','linewidth',5);

bar(x(:,2),G2avgCSDT2BaseSecondsFinal,'FaceColor',[1 0.8 0.8],'EdgeColor','r','linewidth',5);
er=errorbar(x(:,2),G2avgCSDT2BaseSecondsFinal,G2semCSDT2BaseSecondsFinal,'color','r','linewidth',5);

title('G1 vs G2 CSD decay(seconds) with SEM');

hold off

%figure(7)
nexttile
bar(x(:,1),G1avgCSDlengthFramesFinal,'FaceColor',[200 200 200]/250,'EdgeColor','k','linewidth',5);
hold on
er=errorbar(x(:,1),G1avgCSDlengthFramesFinal,G1semCSDlengthFramesFinal,'color','k','linewidth',5);

bar(x(:,2),G2avgCSDlengthFramesFinal,'FaceColor',[1 0.8 0.8],'EdgeColor','r','linewidth',5);
er=errorbar(x(:,2),G2avgCSDlengthFramesFinal,G2semCSDlengthFramesFinal,'color','r','linewidth',5);

title('G1 vs G2 CSD length(frames) with SEM');

hold off

%figure(7)
nexttile
bar(x(:,1),G1avgCSDlengthSecondsFinal,'FaceColor',[200 200 200]/250,'EdgeColor','k','linewidth',5);
hold on
er=errorbar(x(:,1),G1avgCSDlengthSecondsFinal,G1semCSDlengthSecondsFinal,'color','k','linewidth',5);

bar(x(:,2),G2avgCSDlengthSecondsFinal,'FaceColor',[1 0.8 0.8],'EdgeColor','r','linewidth',5);
er=errorbar(x(:,2),G2avgCSDlengthSecondsFinal,G2semCSDlengthSecondsFinal,'color','r','linewidth',5);

title('G1 vs G2 CSD length(seconds) with SEM');

hold off

%figure(7)
nexttile
bar(x(:,1),G1avgCSDaucFramesFinal,'FaceColor',[200 200 200]/250,'EdgeColor','k','linewidth',5);
hold on
er=errorbar(x(:,1),G1avgCSDaucFramesFinal,G1semCSDaucFramesFinal,'color','k','linewidth',5);

bar(x(:,2),G2avgCSDaucFramesFinal,'FaceColor',[1 0.8 0.8],'EdgeColor','r','linewidth',5);
er=errorbar(x(:,2),G2avgCSDaucFramesFinal,G2semCSDaucFramesFinal,'color','r','linewidth',5);

title('G1 vs G2 CSD AUC(frames) with SEM');

hold off

%figure(7)
nexttile
bar(x(:,1),G1avgCSDaucSecondsFinal,'FaceColor',[200 200 200]/250,'EdgeColor','k','linewidth',5);
hold on
er=errorbar(x(:,1),G1avgCSDaucSecondsFinal,G1semCSDaucSecondsFinal,'color','k','linewidth',5);

bar(x(:,2),G2avgCSDaucSecondsFinal,'FaceColor',[1 0.8 0.8],'EdgeColor','r','linewidth',5);
er=errorbar(x(:,2),G2avgCSDaucSecondsFinal,G2semCSDaucSecondsFinal,'color','r','linewidth',5);

title('G1 vs G2 CSD AUC(seconds) with SEM');

hold off


%figure(8)
nexttile
bar(x(:,1),G1_maxDistanceAvg,'FaceColor',[200 200 200]/250,'EdgeColor','k','linewidth',5);
hold on
er=errorbar(x(:,1),G1_maxDistanceAvg,G1_maxDistanceSEM,'color','k','linewidth',5);

bar(x(:,2),G2_maxDistanceAvg,'FaceColor',[1 0.8 0.8],'EdgeColor','r','linewidth',5);
er=errorbar(x(:,2),G2_maxDistanceAvg,G2_maxDistanceSEM,'color','r','linewidth',5);

title('G1 vs G2 max CSD displacement with SEM');

hold off

%figure(9)
nexttile
bar(x(:,1),G1_endDistanceAvg,'FaceColor',[200 200 200]/250,'EdgeColor','k','linewidth',5);
hold on
er=errorbar(x(:,1),G1_endDistanceAvg,G1_endDistanceSEM,'color','k','linewidth',5);

bar(x(:,2),G2_endDistanceAvg,'FaceColor',[1 0.8 0.8],'EdgeColor','r','linewidth',5);
er=errorbar(x(:,2),G2_endDistanceAvg,G2_endDistanceSEM,'color','r','linewidth',5);

title('G1 vs G2 end CSD displacement with SEM');

hold off


maxAmp_pairedT = ttest2(G1_maxAmp,G2_maxAmp);
maxAmp_pairedT = ttest2(G1_halfAmp,G2_halfAmp);
FWHMFrames_pairedT = ttest2(G1_FWHMFrames, G2_FWHMFrames);
FWHMSeconds_pairedT = ttest2(G1_FWHMSeconds, G2_FWHMSeconds);
CSDT2MaxFrames_pairedT = ttest2(G1_CSDT2MaxFrames, G2_CSDT2MaxFrames);
CSDT2MaxSeconds_pairedT = ttest2(G1_CSDT2MaxSeconds, G2_CSDT2MaxSeconds);
CSDT2BaseFrames_pairedT = ttest2(G1_CSDT2BaseFrames, G2_CSDT2BaseFrames);
CSDT2BaseSeconds_pairedT = ttest2(G1_CSDT2BaseSeconds, G2_CSDT2BaseSeconds);
CSDlengthFrames_pairedT = ttest2(G1_CSDlengthFrames,G2_CSDlengthFrames);
CSDlengthSeconds_pairedT = ttest2(G1_CSDlengthSeconds,G2_CSDlengthSeconds);
CSDaucFrames_pairedT = ttest2(G1_CSDaucFrames, G2_CSDaucFrames);
CSDaucSeconds_pairedT = ttest2(G1_CSDaucSeconds, G2_CSDaucSeconds);
maxDisplacement_pairedT = ttest2(G1_maxDistance,G2_maxDistance);
endDisplacement_pairedT = ttest2(G1_endDistance, G2_endDistance);

[h,p,ci,stats] = ttest2(G1_maxAmp,G2_maxAmp);
maxAmp_h = h;
maxAmp_p = p;
maxAmp_ci1 = ci(1);
maxAmp_ci2 = ci(2);
maxAmp_stats = stats;
%maxAmp_pairedT = ttest2(G1_halfAmp,G2_halfAmp)

[h,p,ci,stats] = ttest2(G1_FWHMFrames, G2_FWHMFrames);
FWHMFrames_h = h;
FWHMFrames_p = p;
FWHMFrames_ci1 = ci(1);
FWHMFrames_ci2 = ci(2);
FWHMFrames_stats = stats;
%FWHMFrames_pairedT = ttest2(G1_FWHMFrames, G2_FWHMFrames)


[h,p,ci,stats] = ttest2(G1_FWHMSeconds, G2_FWHMSeconds);
FWHMSeconds_h = h;
FWHMSeconds_p = p;
FWHMSeconds_ci1 = ci(1);
FWHMSeconds_ci2 = ci(2);
FWHMSeconds_stats = stats;
%FWHMSeconds_pairedT = ttest2(G1_FWHMSeconds, G2_FWHMSeconds)


[h,p,ci,stats] = ttest2(G1_CSDT2MaxFrames, G2_CSDT2MaxFrames)
CSDT2MaxFrames_h = h;
CSDT2MaxFrames_p = p;
CSDT2MaxFrames_ci1 = ci(1);
CSDT2MaxFrames_ci2 = ci(2);
CSDT2MaxFrames_stats = stats;
%CSDT2MaxFrames_pairedT = ttest2(G1_CSDT2MaxFrames, G2_CSDT2MaxFrames)


[h,p,ci,stats] = ttest2(G1_CSDT2MaxSeconds, G2_CSDT2MaxSeconds);
CSDT2MaxSeconds_h = h;
CSDT2MaxSeconds_p = p;
CSDT2MaxSeconds_ci1 = ci(1);
CSDT2MaxSeconds_ci2 = ci(2);
CSDT2MaxSeconds_stats = stats;
%CSDT2MaxSeconds_pairedT = ttest2(G1_CSDT2MaxSeconds, G2_CSDT2MaxSeconds)

[h,p,ci,stats] = ttest2(G1_CSDT2BaseFrames, G2_CSDT2BaseFrames);
CSDT2BaseFrames_h = h;
CSDT2BaseFrames_p = p;
CSDT2BaseFrames_ci1 = ci(1);
CSDT2BaseFrames_ci2 = ci(2);
CSDT2BaseFrames_stats = stats;
%CSDT2BaseFrames_pairedT = ttest2(G1_CSDT2BaseFrames, G2_CSDT2BaseFrames)

[h,p,ci,stats] = ttest2(G1_CSDT2BaseSeconds, G2_CSDT2BaseSeconds);
CSDT2BaseSeconds_h = h;
CSDT2BaseSeconds_p = p;
CSDT2BaseSeconds_ci1 = ci(1);
CSDT2BaseSeconds_ci2 = ci(2);
CSDT2BaseSeconds_stats = stats;
%CSDT2BaseSeconds_pairedT = ttest2(G1_CSDT2BaseSeconds, G2_CSDT2BaseSeconds)


[h,p,ci,stats] = ttest2(G1_CSDlengthFrames,G2_CSDlengthFrames);
CSDlengthFrames_h = h;
CSDlengthFrames_p = p;
CSDlengthFrames_ci1 = ci(1);
CSDlengthFrames_ci2 = ci(2);
CSDlengthFrames_stats = stats;
%CSDlengthFrames_pairedT = ttest2(G1_CSDlengthFrames,G2_CSDlengthFrames)


[h,p,ci,stats] = ttest2(G1_CSDlengthSeconds,G2_CSDlengthSeconds);
CSDlengthSeconds_h = h;
CSDlengthSeconds_p = p;
CSDlengthSeconds_ci1 = ci(1);
CSDlengthSeconds_ci2 = ci(2);
CSDlengthSeconds_stats = stats;
%CSDlengthSeconds_pairedT = ttest2(G1_CSDlengthSeconds,G2_CSDlengthSeconds)

[h,p,ci,stats] = ttest2(G1_CSDaucFrames, G2_CSDaucFrames);
CSDaucFrames_h = h;
CSDaucFrames_p = p;
CSDaucFrames_ci1 = ci(1);
CSDaucFrames_ci2 = ci(2);
CSDaucFrames_stats = stats;
%CSDaucFrames_pairedT = ttest2(G1_CSDaucFrames, G2_CSDaucFrames)


[h,p,ci,stats] = ttest2(G1_CSDaucSeconds, G2_CSDaucSeconds);
CSDaucSeconds_h = h;
CSDaucSeconds_p = p;
CSDaucSeconds_ci1 = ci(1);
CSDaucSeconds_ci2 = ci(2);
CSDaucSeconds_stats = stats;
%CSDaucSeconds_pairedT = ttest2(G1_CSDaucSeconds, G2_CSDaucSeconds)


[h,p,ci,stats] = ttest2(G1_maxDistance,G2_maxDistance);
maxDisplacement_h = h;
maxDisplacement_p = p;
maxDisplacement_ci1 = ci(1);
maxDisplacement_ci2 = ci(2);
maxDisplacement_stats = stats;
%maxDisplacement_pairedT = ttest2(G1_maxDistance,G2_maxDistance)

[h,p,ci,stats] = ttest2(G1_endDistance, G2_endDistance);
endDisplacement_h = h;
endDisplacement_p = p;
endDisplacement_ci1 = ci(1);
endDisplacement_ci2 = ci(2);
endDisplacement_stats = stats;
%endDisplacement_pairedT = ttest2(G1_endDistance, G2_endDistance)

pairedT_h = vertcat(maxAmp_h,maxAmp_h,FWHMFrames_h,FWHMSeconds_h,CSDT2MaxFrames_h,CSDT2MaxSeconds_h,CSDT2BaseFrames_h,CSDT2BaseSeconds_h,CSDlengthFrames_h,CSDlengthSeconds_h,CSDaucFrames_h,CSDaucSeconds_h,maxDisplacement_h,endDisplacement_h);
pairedT_p = vertcat(maxAmp_p,maxAmp_p,FWHMFrames_p,FWHMSeconds_p,CSDT2MaxFrames_p,CSDT2MaxSeconds_p,CSDT2BaseFrames_p,CSDT2BaseSeconds_p,CSDlengthFrames_p,CSDlengthSeconds_p,CSDaucFrames_p,CSDaucSeconds_p,maxDisplacement_p,endDisplacement_p);
pairedT_ci1 = vertcat(maxAmp_ci1,maxAmp_ci1,FWHMFrames_ci1,FWHMSeconds_ci1,CSDT2MaxFrames_ci1,CSDT2MaxSeconds_ci1,CSDT2BaseFrames_ci1,CSDT2BaseSeconds_ci1,CSDlengthFrames_ci1,CSDlengthSeconds_ci1,CSDaucFrames_ci1,CSDaucSeconds_ci1,maxDisplacement_ci1,endDisplacement_ci1);
pairedT_ci2 = vertcat(maxAmp_ci2,maxAmp_ci2,FWHMFrames_ci2,FWHMSeconds_ci2,CSDT2MaxFrames_ci2,CSDT2MaxSeconds_ci2,CSDT2BaseFrames_ci2,CSDT2BaseSeconds_ci2,CSDlengthFrames_ci2,CSDlengthSeconds_ci2,CSDaucFrames_ci2,CSDaucSeconds_ci2,maxDisplacement_ci2,endDisplacement_ci2);
pairedT_results = [string('maxAmp');string('halfAmp');string('FWHM(frames)');string('FWHM(seconds)');string('rise(frames)');string('rise(seconds)');string('decay(frames)');string('decay(seconds');string('CSDlength(frames)');string('CSDlength(seconds)');string('CSDauc(frames)');string('CSDauc(seconds)');string('maxDisplacement');string('endDisplacement')];
pairedT_results2 = [string('maxAmp');string('halfAmp');string('FWHM(frames)');string('FWHM(seconds)');string('rise(frames)');string('rise(seconds)');string('decay(frames)');string('decay(seconds');string('CSDlength(frames)');string('CSDlength(seconds)');string('CSDauc(frames)');string('CSDauc(seconds)');string('maxDisplacement');string('endDisplacement')];
pairedT_columns = [string('');string('h');string('p');string('ci low');string('ci high')]
pairedT_columns = pairedT_columns';
%pairedT_results = pairedT_results'
pairedT_results = horzcat(pairedT_results,pairedT_h,pairedT_p,pairedT_ci1,pairedT_ci2);
pairedT_results = vertcat(pairedT_columns,pairedT_results);

%G1_resultsAggregated = pairedT_results'
%G2_resultsAggregated = pairedT_results'

pairedT_results2 = pairedT_results2';
G1_tempResults = horzcat(G1_maxAmp,G1_halfAmp,G1_FWHMFrames,G1_FWHMSeconds,G1_CSDT2MaxFrames,G1_CSDT2MaxSeconds,G1_CSDT2BaseFrames,G1_CSDT2BaseSeconds,G1_CSDlengthFrames,G1_CSDlengthSeconds,G1_CSDaucFrames,G1_CSDaucSeconds,G1_maxDistance,G1_endDistance);
G1_resultsAggregated = vertcat(pairedT_results2,G1_tempResults);

G2_tempResults = horzcat(G2_maxAmp,G2_halfAmp,G2_FWHMFrames,G2_FWHMSeconds,G2_CSDT2MaxFrames,G2_CSDT2MaxSeconds,G2_CSDT2BaseFrames,G2_CSDT2BaseSeconds,G2_CSDlengthFrames,G2_CSDlengthSeconds,G2_CSDaucFrames,G2_CSDaucSeconds,G2_maxDistance,G2_endDistance);
G2_resultsAggregated = vertcat(pairedT_results2, G2_tempResults);

figure(1)
set(gcf,'Position',[100 100 1920 1080]);

figure(2)
set(gcf,'Position',[100 100 1920 1080]);

figure(3)
set(gcf,'Position',[100 100 1920 1080]);

figure(4)
set(gcf,'Position',[100 100 1920 1080]); 
figure(5)
set(gcf,'Position',[100 100 1920 1080]);

figure(6)
set(gcf,'Position',[100 100 1920 1080]);


prompt = "Save figures? (1 for yes, 0 for no)"
save = input(prompt);
if save == 1
    clearvars -except pairedT_results avgTraces G1_resultsAggregated G2_resultsAggregated h s q myDir myFiles pairedT_results;
    figure(1)
    saveas(gca, fullfile(myDir, 'avgTracesAnimalSD.tif'));
    saveas(gca, fullfile(myDir, 'avgTracesAnimalSD.fig'));
    figure(2)
    saveas(gca, fullfile(myDir, 'avgTracesAnimalSEM.tif'));
    saveas(gca, fullfile(myDir, 'avgTracesAnimalSEM.fig'));
    figure(3)
    saveas(gca, fullfile(myDir, 'CSD avg traces SD G1 and G2.tif'));
    saveas(gca, fullfile(myDir, 'CSD avg traces SD G1 and G2.fig'));
    figure(4)
    saveas(gca, fullfile(myDir, 'CSD avg traces SEM G1 and G2.tif'));
    saveas(gca, fullfile(myDir, 'CSD avg traces SEM G1 and G2.fig'));
    figure(5)
    saveas(gca, fullfile(myDir, 'CSD max amplitude G1 and G2.tif'));
    saveas(gca, fullfile(myDir, 'CSD max amplitude G1 and G2.fig'));
    %figure(6)
    %saveas(gca, fullfile(myDir, 'CSD duration G1 and G2.tif'))
    %saveas(gca, fullfile(myDir, 'CSD duration G1 and G2.fig'))
    %figure(7)
    %saveas(gca, fullfile(myDir, 'CSD AUC G1 and G2.tif'))
    %saveas(gca, fullfile(myDir, 'CSD AUC G1 and G2.fig'))
    %figure(8)
    %saveas(gca, fullfile(myDir, 'CSD max displacement G1 and G2.tif'))
    %saveas(gca, fullfile(myDir, 'CSD max displacement G1 and G2.fig'))
    %figure(9)
    %saveas(gca, fullfile(myDir, 'CSD end displacement G1 and G2.tif'))
    %saveas(gca, fullfile(myDir, 'CSD end displacement G1 and G2.fig'))
    
    filename = [myDir '\Aggregated_Groups_CaCSDmeasurements_workspace.mat'];
    save(filename);

    close all
end





