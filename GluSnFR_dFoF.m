% Enter "data = []" into the command window, double click "data" in
% workspace, and then copy and paste GluSnFR sensory recording plot z-axis
% list from imageJ into data, then run this script

dataSignal = data(:,2);
dataFrames = data(:,1);
deltaFcomputed = [];
temp = [];

base = dataSignal(1:10,1);
baseAVG = mean(base);
SZ = size(dataSignal(:,1)); 
    
for i = 1:SZ
    temp = dataSignal(i,1);
    temp = (temp - baseAVG) / baseAVG;
    deltaFcomputed(i,1) = temp;    
end

plot(deltaFcomputed);
title('Whisker sensory GluSnFR %df/f');
xlabel('Frames');
ylabel('df/f');

dFoF_toSave = deltaFcomputed(:,1)
deltaFcomputed = horzcat(dataFrames, deltaFcomputed);

selpath = uigetdir();
flNME = '/GluSnFR_dFoF.dat'
fullFName = horzcat(selpath,flNME)

save(fullFName,'dFoF_toSave','-ascii','-double')

clearvars -except deltaFcomputed dFoF_toSave fullFName;   



