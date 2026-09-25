%%
%script for finding events and AUC in traces
    %'events' are found as p2eaks above a threshold based on standard 
    % deviation of baseline. Both the threshold and baseline are specified
    % by the user.  
    % AUC = area under the curve, and is determined using Trapz
%%
%load data and pertainent information
f = uiimport();
Vars = fieldnames (f);
v1 = getfield (f,Vars{1});
waitfor(f);
    
[data,dataName] = uigetvariables('Choose data variable');%chooses variable 
data = data{1,1};%converts from a cell format to original format of the variable. 

% shifts each column of data and v1 so that there are no negative values
numCols = size(data,2);
for i = 1:numCols
    curMin = min(data(:,i));
    if curMin < 0
        numRows = size(data,1);
        for j = 1:numRows
            data(j,i) = data(j,i) + abs(curMin);
            v1(j,i) = v1(j,i) + abs(curMin);
        end
    end
end

sz = size(data,2);
SZ = size(data,1) - 1;
t = linspace(0,SZ,(SZ+1))';
t = t/3.125;
figure(1);
hold on;
for i = 1:sz
    nexttile; 
    plot(t,data(:,i));
    set(gca, 'Xtick', 0:30:SZ);
    c = 88.8/3.125;
    title("cell " + num2str(i) +  " full length");
    xlabel('Time (s)');
    ylabel('\DeltaF/F_0');
    while c < 292
        xline(c,'--b');
        c = c + (88.8/3.125);
    end
end
hold off;

mkdir WhiskerStimCaAnalysis;
myDir = uigetdir;
saveas(figure(1),fullfile(myDir, "AllCellsFullLength"));
close(gcf);

DATA = {};
AllData = {};
AllDataAvgs = {};

for k = 1:numCols
    
    forAVGpks = [];
    forAVGwidthsFrames = [];
    forAVGwidthsSeconds = [];
    forAVGproms = [];
    
    Continue = 1;
    
    while Continue == 1
        preStim = data((1:154),k);
        tempT = t(1:87);
        a = figure
        hold on
        plot(tempT,preStim)
        title("cell " + num2str(k) +  " pre-stim");
        xlabel('Time (s)');
        ylabel('\DeltaF/F_0');
        hold off

        prompt = {'Use SD to calculate threshold or set manually? (0 for SD, 1 for manual'};
        dlg_title = 'Input variable';
        num_lines = 1;
        defaultans = {'1'};
        InputVar = str2double(inputdlg(prompt,dlg_title,num_lines,defaultans));
        ch = InputVar(1,1);
        clear prompt dlg_title num_lines defaulttans InputVar

        %prompt for # of ROIs
        if ch == 0
            prompt = {'Baseline start (frame)','baseline stop (frame)','Sampling Rate (Hz)','Threshold for events (SD)',};
            dlg_title = 'Input variables';
            num_lines = 1;
            defaultans = {'1','50','3.125','2'};
            InputVars = str2double(inputdlg(prompt,dlg_title,num_lines,defaultans));

        else
            prompt = {'Sampling Rate (Hz)','Threshold for events (prom)'};
            dlg_title = 'Input variables';
            num_lines = 1;
            defaultans = {'3.125','0.4'};
            InputVars = str2double(inputdlg(prompt,dlg_title,num_lines,defaultans));
        end

        close(a);

        %pull out input variables
        if ch==0
            BaseStrt = InputVars(1,1);
            BaseStp = InputVars(2,1);
            Fs = InputVars(3,1);
            EvSD = InputVars(4,1);
        else
            Fs = InputVars(1,1);
            EvSD = InputVars(2,1);
        end


        %findpeaks(preStim,Fs,'MinPeakHeight',0.5);
        [pks,locs,widths,proms] = findpeaks(preStim)%find all peaks for individual trace

        MeanProms = mean(proms);%mean prominence of all peaks for individual trace
        StdProms = std(proms);%standard deviation of prominence of all peaks for individual trace

        if ch==0
            UseProms = MeanProms + StdProms*EvSD;%determine standard deviation
        else
            UseProms = EvSD;
        end
        clear pks locs widths proms

        tempT = t(144:248);
        figure(k+1);
        hold on
        nexttile;
        findpeaks(data(150:248,k),Fs,'MinPeakProminence',UseProms,'Annotate','extents','WidthReference','halfprom');
        if ch==0
            xline(BaseStrt,'--b');
            xline(BaseStp, '--b');
        end
        title("cell " + num2str(k) +  " pre-stim");
        xlabel('Time (s)');
        ylabel('\DeltaF/F_0');

        clear ch;


        Stim1 = data(238:400,k);
        [pks1,locs1,widths,proms] = findpeaks(data(83:177,k),Fs,'MinPeakProminence',UseProms,'WidthReference','halfprom','MinPeakHeight',0.5)  %find peaks > 3 std for individual trace

        if isempty(pks1)
            tempT = t(245:400);
            nexttile;
            plot(tempT,Stim1)
            title("cell " + num2str(k) + " stim 1")
            xlabel('Time (s)');
            ylabel('\DeltaF/F_0');
        else
            tempT = t(385:550);
            nexttile;
            findpeaks(data(83:177,k),Fs,'MinPeakProminence',UseProms,'Annotate','extents','WidthReference','halfprom') %annotate peaks >3 std on individual figures
            s = findobj('type','legend');
            set(s,'visible','off');
            title("cell " + num2str(k) + " stim 1")
            xlabel('Time (s)');
            ylabel('\DeltaF/F_0');
        end
        
        numPeaks = size(pks1);
        peaksLabel = [string('locs'),string('pks'),string('widths(frames)'),string('widths(seconds)'),string('proms')];
        peaksData = [];
        for i = 1:numPeaks
            peaksData(i,1) = locs1(i);
            peaksData(i,2) = pks1(i);
            peaksData(i,3) = widths(i);
            peaksData(i,4) = widths(i)/Fs;
            peaksData(i,5) = proms(i);
        end
        peaksData = vertcat(peaksLabel,peaksData)

        tempLabel = [string('locsAvg'),string('pksAvg'),string('widthsAvg(frames)'),string('widthsAvg(seconds)'),string('Avgproms')];
        peaksAvgData = [];
        
        temp = mean(locs1);
        peaksAvgData(1,1) = temp;
        temp = mean(pks1);
        forAVGpks = horzcat(forAVGpks,temp);
        peaksAvgData(1,2) = temp;
        temp = mean(widths);
        forAVGwidthsFrames = horzcat(forAVGwidthsFrames,temp);
        peaksAvgData(1,3) = temp;
        temp = (mean(widths))/Fs;
        forAVGwidthsSeconds = horzcat(forAVGwidthsSeconds,temp);
        peaksAvgData(1,4) = temp;
        temp = mean(proms);
        forAVGproms = horzcat(forAVGproms,temp);
        peaksAvgData(1,5) = temp;
        peaksAvgData = vertcat(tempLabel,peaksAvgData);
        Stim1PeaksData = vertcat(peaksData,peaksAvgData);

        clear widths proms


        Stim2 = data(535:700,k);
        [pks2,locs2,widths,proms] = findpeaks(data(173:266,k),Fs,'MinPeakProminence',UseProms,'WidthReference','halfprom','MinPeakHeight',0.5)  %find peaks > 3 std for individual trace

        if isempty(pks2)
            tempT = t(173:266);
            nexttile;
            plot(tempT,Stim2)
            title("cell " + num2str(k) + " stim 2")
            xlabel('Time (s)');
            ylabel('\DeltaF/F_0');
        else
            tempT = t(173:266);
            nexttile;
            findpeaks(data(173:266,k),Fs,'MinPeakProminence',UseProms,'Annotate','extents','WidthReference','halfprom') %annotate peaks >3 std on individual figures
            s = findobj('type','legend');
            set(s,'visible','off')
            title("cell " + num2str(k) + " stim 2")
            xlabel('Time (s)');
            ylabel('\DeltaF/F_0');
        end
        
        numPeaks = size(pks2);
        peaksLabel = [string('locs'),string('pks'),string('widths(frames)'),string('widths(seconds)'),string('proms')];
        peaksData = [];
        for i = 1:numPeaks
            peaksData(i,1) = locs2(i);
            peaksData(i,2) = pks2(i);
            peaksData(i,3) = widths(i);
            peaksData(i,4) = widths(i)/Fs;
            peaksData(i,5) = proms(i);
        end
        peaksData = vertcat(peaksLabel,peaksData)

        tempLabel = [string('locsAvg'),string('pksAvg'),string('widthsAvg(frames)'),string('widthsAvg(seconds)'),string('Avgproms')];
        peaksAvgData = [];
        
        
        temp = mean(locs2);
        peaksAvgData(1,1) = temp;
        temp = mean(pks2);
        forAVGpks = horzcat(forAVGpks,temp);
        peaksAvgData(1,2) = temp;
        temp = mean(widths);
        forAVGwidthsFrames = horzcat(forAVGwidthsFrames,temp);
        peaksAvgData(1,3) = temp;
        temp = (mean(widths))/Fs;
        forAVGwidthsSeconds = horzcat(forAVGwidthsSeconds,temp);
        peaksAvgData(1,4) = temp;
        temp = mean(proms);
        forAVGproms = horzcat(forAVGproms,temp);
        peaksAvgData(1,5) = temp;
        peaksAvgData = vertcat(tempLabel,peaksAvgData);
        Stim2PeaksData = vertcat(peaksData,peaksAvgData);
   
        clear widths proms

        Stim3 = data(262:355,k);
        [pks3,locs3,widths,proms] = findpeaks(Stim3,Fs,'MinPeakProminence',UseProms,'WidthReference','halfprom','MinPeakHeight',0.5)  %find peaks > 3 std for individual trace

        if isempty(pks3)
            tempT = t(262:355);
            nexttile;
            plot(tempT,Stim3);
            title("cell " + num2str(k) + " stim 3")
            xlabel('Time (s)');
            ylabel('\DeltaF/F_0');
        else
            tempT = t(262:355);
            nexttile;
            findpeaks(data(262:355,k),Fs,'MinPeakProminence',UseProms,'Annotate','extents','WidthReference','halfprom') %annotate peaks >3 std on individual figures
            s = findobj('type','legend');
            set(s,'visible','off')
            title("cell " + num2str(k) + " stim 3")
            xlabel('Time (s)');
            ylabel('\DeltaF/F_0');
        end
        
        numPeaks = size(pks3);
        peaksLabel = [string('locs'),string('pks'),string('widths(frames)'),string('widths(seconds)'),string('proms')];
        peaksData = [];
        for i = 1:numPeaks
            peaksData(i,1) = locs3(i);
            peaksData(i,2) = pks3(i);
            peaksData(i,3) = widths(i);
            peaksData(i,4) = widths(i)/Fs;
            peaksData(i,5) = proms(i);
        end
        peaksData = vertcat(peaksLabel,peaksData)

        tempLabel = [string('locsAvg'),string('pksAvg'),string('widthsAvg(frames)'),string('widthsAvg(seconds)'),string('Avgproms')];
        peaksAvgData = [];
        
        temp = mean(locs3);
        peaksAvgData(1,1) = temp;
        temp = mean(pks3);
        forAVGpks = horzcat(forAVGpks,temp);
        peaksAvgData(1,2) = temp;
        temp = mean(widths);
        forAVGwidthsFrames = horzcat(forAVGwidthsFrames,temp);
        peaksAvgData(1,3) = temp;
        temp = (mean(widths))/Fs;
        forAVGwidthsSeconds = horzcat(forAVGwidthsSeconds,temp);
        peaksAvgData(1,4) = temp;
        temp = mean(proms);
        forAVGproms = horzcat(forAVGproms,temp);
        peaksAvgData(1,5) = temp;
        peaksAvgData = vertcat(tempLabel,peaksAvgData);
        Stim3PeaksData = vertcat(peaksData,peaksAvgData);

        clear widths proms


        Stim4 = data(351:444,k);
        [pks4,locs4,widths,proms] = findpeaks(Stim4,Fs,'MinPeakProminence',UseProms,'WidthReference','halfprom','MinPeakHeight',0.5)  %find peaks > 3 std for individual trace

        if isempty(pks4)
            tempT = t(351:444);
            nexttile;
            plot(tempT,Stim4)
            title("cell " + num2str(k) + " stim 4")
            xlabel('Time (s)');
            ylabel('\DeltaF/F_0');
        else
            tempT = t(351:444);
            nexttile;
            findpeaks(data(351:444,k),Fs,'MinPeakProminence',UseProms,'Annotate','extents','WidthReference','halfprom') %annotate peaks >3 std on individual figures
            s = findobj('type','legend');
            set(s,'visible','off')
            title("cell " + num2str(k) + " stim 4")
            xlabel('Time (s)');
            ylabel('\DeltaF/F_0');
        end

        numPeaks = size(pks4);
        peaksLabel = [string('locs'),string('pks'),string('widths(frames)'),string('widths(seconds)'),string('proms')];
        peaksData = [];
        for i = 1:numPeaks
            peaksData(i,1) = locs4(i);
            peaksData(i,2) = pks4(i);
            peaksData(i,3) = widths(i);
            peaksData(i,4) = widths(i)/Fs;
            peaksData(i,5) = proms(i);
        end
        peaksData = vertcat(peaksLabel,peaksData)

        tempLabel = [string('locsAvg'),string('pksAvg'),string('widthsAvg(frames)'),string('widthsAvg(seconds)'),string('Avgproms')];
        peaksAvgData = [];
        
        temp = mean(locs4);
        peaksAvgData(1,1) = temp;
        temp = mean(pks4);
        forAVGpks = horzcat(forAVGpks,temp);
        peaksAvgData(1,2) = temp;
        temp = mean(widths);
        forAVGwidthsFrames = horzcat(forAVGwidthsFrames,temp);
        peaksAvgData(1,3) = temp;
        temp = (mean(widths))/Fs;
        forAVGwidthsSeconds = horzcat(forAVGwidthsSeconds,temp);
        peaksAvgData(1,4) = temp;
        temp = mean(proms);
        forAVGproms = horzcat(forAVGproms,temp);
        peaksAvgData(1,5) = temp;
        peaksAvgData = vertcat(tempLabel,peaksAvgData);
        Stim4PeaksData = vertcat(peaksData,peaksAvgData);

        clear widths proms


        Stim5 = data(440:532,k);
        [pks5,locs5,widths,proms] = findpeaks(Stim5,Fs,'MinPeakProminence',UseProms,'WidthReference','halfprom','MinPeakHeight',0.5)  %find peaks > 3 std for individual trace

        if isempty(pks5)
            tempT = t(440:532);
            nexttile;
            plot(tempT,Stim5)
            title("cell " + num2str(k) + " stim 5")
            xlabel('Time (s)');
            ylabel('\DeltaF/F_0');
        else
            tempT = t(440:532);
            nexttile;
            findpeaks(data(440:532,k),Fs,'MinPeakProminence',UseProms,'Annotate','extents','WidthReference','halfprom') %annotate peaks >3 std on individual figures
            s = findobj('type','legend');
            set(s,'visible','off')
            title("cell " + num2str(k) + " stim 5")
            xlabel('Time (s)');
            ylabel('\DeltaF/F_0');
        end
        
        numPeaks = size(pks5);
        peaksLabel = [string('locs'),string('pks'),string('widths(frames)'),string('widths(seconds)'),string('proms')];
        peaksData = [];
        for i = 1:numPeaks
            peaksData(i,1) = locs5(i);
            peaksData(i,2) = pks5(i);
            peaksData(i,3) = widths(i);
            peaksData(i,4) = widths(i)/Fs;
            peaksData(i,5) = proms(i);
        end
        peaksData = vertcat(peaksLabel,peaksData)

        tempLabel = [string('locsAvg'),string('pksAvg'),string('widthsAvg(frames)'),string('widthsAvg(seconds)'),string('Avgproms')];
        peaksAvgData = [];
        
        temp = mean(locs5);
        peaksAvgData(1,1) = temp;
        temp = mean(pks5);
        forAVGpks = horzcat(forAVGpks,temp);
        peaksAvgData(1,2) = temp;
        temp = mean(widths);
        forAVGwidthsFrames = horzcat(forAVGwidthsFrames,temp);
        peaksAvgData(1,3) = temp;
        temp = (mean(widths))/Fs;
        forAVGwidthsSeconds = horzcat(forAVGwidthsSeconds,temp);
        peaksAvgData(1,4) = temp;
        temp = mean(proms);
        forAVGproms = horzcat(forAVGproms,temp);
        peaksAvgData(1,5) = temp;
        peaksAvgData = vertcat(tempLabel,peaksAvgData);
        Stim5PeaksData = vertcat(peaksData,peaksAvgData);

        clear widths proms


        Stim6 = data(528:621,k);
        [pks6,locs6,widths,proms] = findpeaks(Stim6,Fs,'MinPeakProminence',UseProms,'WidthReference','halfprom','MinPeakHeight',0.5)  %find peaks > 3 std for individual trace

        if isempty(pks6)
            tempT = t(528:621);
            nexttile;
            plot(tempT,Stim6)
            title("cell " + num2str(k) + " stim 6")
            xlabel('Time (s)');
            ylabel('\DeltaF/F_0');
        else
            tempT = t(528:621);
            nexttile;
            findpeaks(data(528:621,k),Fs,'MinPeakProminence',UseProms,'Annotate','extents','WidthReference','halfprom') %annotate peaks >3 std on individual figures
            s = findobj('type','legend');
            set(s,'visible','off')
            title("cell " + num2str(k) + " stim 6")
            xlabel('Time (s)');
            ylabel('\DeltaF/F_0');
        end
        
        numPeaks = size(pks6);
        peaksLabel = [string('locs'),string('pks'),string('widths(frames)'),string('widths(seconds)'),string('proms')];
        peaksData = [];
        for i = 1:numPeaks
            peaksData(i,1) = locs6(i);
            peaksData(i,2) = pks6(i);
            peaksData(i,3) = widths(i);
            peaksData(i,4) = widths(i)/Fs;
            peaksData(i,5) = proms(i);
        end
        peaksData = vertcat(peaksLabel,peaksData)

        tempLabel = [string('locsAvg'),string('pksAvg'),string('widthsAvg(frames)'),string('widthsAvg(seconds)'),string('Avgproms')];
        peaksAvgData = [];
        
        temp = mean(locs6);
        peaksAvgData(1,1) = temp;
        temp = mean(pks6);
        forAVGpks = horzcat(forAVGpks,temp);
        peaksAvgData(1,2) = temp;
        temp = mean(widths);
        forAVGwidthsFrames = horzcat(forAVGwidthsFrames,temp);
        peaksAvgData(1,3) = temp;
        temp = (mean(widths))/Fs;
        forAVGwidthsSeconds = horzcat(forAVGwidthsSeconds,temp);
        peaksAvgData(1,4) = temp;
        temp = mean(proms);
        forAVGproms = horzcat(forAVGproms,temp);
        peaksAvgData(1,5) = temp;
        peaksAvgData = vertcat(tempLabel,peaksAvgData);
        Stim6PeaksData = vertcat(peaksData,peaksAvgData);

        clear widths proms


        Stim7 = data(617:710,k);
        [pks7,locs7,widths,proms] = findpeaks(Stim7,Fs,'MinPeakProminence',UseProms,'WidthReference','halfprom','MinPeakHeight',0.5)  %find peaks > 3 std for individual trace

        if isempty(pks7)
            tempT = t(617:710);
            nexttile;
            plot(tempT,Stim7)
            title("cell " + num2str(k) + " stim 7")
            xlabel('Time (s)');
            ylabel('\DeltaF/F_0');
        else
            tempT = t(617:710);
            nexttile;
            findpeaks(data(617:710,k),Fs,'MinPeakProminence',UseProms,'Annotate','extents','WidthReference','halfprom') %annotate peaks >3 std on individual figures
            s = findobj('type','legend');
            set(s,'visible','off')
            title("cell " + num2str(k) + " stim 7")
            xlabel('Time (s)');
            ylabel('\DeltaF/F_0');
        end
        numPeaks = size(pks7);
        peaksLabel = [string('locs'),string('pks'),string('widths(frames)'),string('widths(seconds)'),string('proms')];
        peaksData = [];
        for i = 1:numPeaks
            peaksData(i,1) = locs7(i);
            peaksData(i,2) = pks7(i);
            peaksData(i,3) = widths(i);
            peaksData(i,4) = widths(i)/Fs;
            peaksData(i,5) = proms(i);
        end
        peaksData = vertcat(peaksLabel,peaksData)

        tempLabel = [string('locsAvg'),string('pksAvg'),string('widthsAvg(frames)'),string('widthsAvg(seconds)'),string('Avgproms')];
        peaksAvgData = [];
        
        temp = mean(locs7);
        peaksAvgData(1,1) = temp;
        temp = mean(pks7);
        forAVGpks = horzcat(forAVGpks,temp);
        peaksAvgData(1,2) = temp;
        temp = mean(widths);
        forAVGwidthsFrames = horzcat(forAVGwidthsFrames,temp);
        peaksAvgData(1,3) = temp;
        temp = (mean(widths))/Fs;
        forAVGwidthsSeconds = horzcat(forAVGwidthsSeconds,temp);
        peaksAvgData(1,4) = temp;
        temp = mean(proms);
        forAVGproms = horzcat(forAVGproms,temp);
        peaksAvgData(1,5) = temp;
        peaksAvgData = vertcat(tempLabel,peaksAvgData);
        Stim7PeaksData = vertcat(peaksData,peaksAvgData);

        clear widths proms


        Stim8 = data(706:799,k);
        [pks8,locs8,widths,proms] = findpeaks(Stim8,Fs,'MinPeakProminence',UseProms,'WidthReference','halfprom','MinPeakHeight',0.5)  %find peaks > 3 std for individual trace

        if isempty(pks8)
            tempT = t(706:799);
            nexttile;
            plot(tempT,Stim8)
            title("cell " + num2str(k) + " stim 8")
            xlabel('Time (s)');
            ylabel('\DeltaF/F_0');
        else
            tempT = t(706:799);
            nexttile;
            findpeaks(data(706:799,k),Fs,'MinPeakProminence',UseProms,'Annotate','extents','WidthReference','halfprom') %annotate peaks >3 std on individual figures
            s = findobj('type','legend');
            set(s,'visible','off')
            title("cell " + num2str(k) + " stim 8")
            xlabel('Time (s)');
            ylabel('\DeltaF/F_0');
        end
        
        numPeaks = size(pks8);
        peaksLabel = [string('locs'),string('pks'),string('widths(frames)'),string('widths(seconds)'),string('proms')];
        peaksData = [];
        for i = 1:numPeaks
            peaksData(i,1) = locs8(i);
            peaksData(i,2) = pks8(i);
            peaksData(i,3) = widths(i);
            peaksData(i,4) = widths(i)/Fs;
            peaksData(i,5) = proms(i);
        end
        
        peaksData = vertcat(peaksLabel,peaksData)

        tempLabel = [string('locsAvg'),string('pksAvg'),string('widthsAvg(frames)'),string('widthsAvg(seconds)'),string('Avgproms')];
        peaksAvgData = [];
        
        temp = mean(locs8);
        peaksAvgData(1,1) = temp;
        temp = mean(pks8);
        forAVGpks = horzcat(forAVGpks,temp);
        peaksAvgData(1,2) = temp;
        temp = mean(widths);
        forAVGwidthsFrames = horzcat(forAVGwidthsFrames,temp);
        peaksAvgData(1,3) = temp;
        temp = (mean(widths))/Fs;
        forAVGwidthsSeconds = horzcat(forAVGwidthsSeconds,temp);
        peaksAvgData(1,4) = temp;
        temp = mean(proms);
        forAVGproms = horzcat(forAVGproms,temp);
        peaksAvgData(1,5) = temp;
        peaksAvgData = vertcat(tempLabel,peaksAvgData);
        Stim8PeaksData = vertcat(peaksData,peaksAvgData);
        
        clear widths proms


        Stim9 = data(795:end,k);
        [pks9,locs9,widths,proms] = findpeaks(Stim9,Fs,'MinPeakProminence',UseProms,'WidthReference','halfprom','MinPeakHeight',0.5)  %find peaks > 3 std for individual trace

        if isempty(pks9)
            tempT = t(795:end);
            nexttile;
            plot(tempT,Stim9)
            title("cell " + num2str(k) + " stim 9")
            xlabel('Time (s)');
            ylabel('\DeltaF/F_0');

        else
            tempT = t(795:863);
            nexttile;
            hold on
            findpeaks(data(795:863,k),Fs,'MinPeakProminence',UseProms,'Annotate','extents','WidthReference','halfprom') %annotate peaks >3 std on individual figures
            title("cell " + num2str(k) + " stim 9")
            xlabel('Time (s)');
            ylabel('\DeltaF/F_0');
            s = findobj('type','legend');
            set(s,'visible','off')
        end
        
        numPeaks = size(pks9);
        peaksLabel = [string('locs'),string('pks'),string('widths(frames)'),string('widths(seconds)'),string('proms')];
        peaksData = [];
        for i = 1:numPeaks
            peaksData(i,1) = locs9(i);
            peaksData(i,2) = pks9(i);
            peaksData(i,3) = widths(i);
            peaksData(i,4) = widths(i)/Fs;
            peaksData(i,5) = proms(i);
        end
        
        peaksData = vertcat(peaksLabel,peaksData)

        tempLabel = [string('locsAvg'),string('pksAvg'),string('widthsAvg(frames)'),string('widthsAvg(seconds'),string('Avgproms')];
        peaksAvgData = [];
        
        temp = mean(locs9);
        peaksAvgData(1,1) = temp;
        temp = mean(pks9);
        forAVGpks = horzcat(forAVGpks,temp);
        peaksAvgData(1,2) = temp;
        temp = mean(widths);
        forAVGwidthsFrames = horzcat(forAVGwidthsFrames,temp);
        peaksAvgData(1,3) = temp;
        temp = (mean(widths))/Fs;
        forAVGwidthsSeconds = horzcat(forAVGwidthsSeconds,temp);
        peaksAvgData(1,4) = temp;
        temp = mean(proms);
        forAVGproms = horzcat(forAVGproms,temp);
        peaksAvgData(1,5) = temp;
        peaksAvgData = vertcat(tempLabel,peaksAvgData);
        Stim9PeaksData = vertcat(peaksData,peaksAvgData);

        clear widths proms 

        hold off

        prompt = {'Re-detect with different threshold? (0 for NO, 1 for YES'};
        dlg_title = 'Input variable';
        num_lines = 1;
        defaultans = {'0'};
        InputVar = str2double(inputdlg(prompt,dlg_title,num_lines,defaultans));
        if InputVar(1,1) == 1
            Continue = 1;
            close(gcf);
            clear prompt dlg_title num_lines defaulttans InputVar
        else
            Continue = 0;
            num = num2str(k);
            NAME = strcat('Cell',num,'DetectedPeaks.tif')
            saveas(figure(k+1), fullfile(myDir, NAME))
            NAME = strcat('Cell',num,'DetectedPeaks.fig')
            saveas(figure(k+1), fullfile(myDir, NAME))
            close(gcf)
            clear prompt dlg_title num_lines defaulttans InputVar
 
            tempAUCall = [];
            tempAUC2all = [];
            
            g = size(locs1,1);
            tempAUC = [];
            tempAUC2 = [];
            
            for z = 1:g
                figure(100);
                plot(Stim1);
                set(gcf,'Position',[100,100,1080,360]);
                hold on;
                grid on;
                daspect([8 1 1]);
                hold on;
                SIZE = size(Stim1);
                xticks(0:2:SIZE);
                idx = locs1(z:z,1:1)*Fs + 1;
                idx = round(idx);
                plot(Stim1,'r*','MarkerSize',10,'linewidth',2,'MarkerIndices',idx);
                prompt = {'Enter start for current peak AUC (frame)','Enter stop for current peak AUC (frame)'};
                dlg_title = 'AUC start and stop for current peak';
                num_lines = 1;
                defaultans = {'0','20'};
                INPUTVAR = str2double(inputdlg(prompt,dlg_title,num_lines,defaultans));
                curPeakAUC = trapz(Stim1(INPUTVAR(1,1):INPUTVAR(2,1)));
                curPeakAUCseconds = curPeakAUC/Fs;
                
                tempAUC = vertcat(tempAUC,curPeakAUC);
                tempAUC2 = vertcat(tempAUC2,curPeakAUCseconds);
                
                close(figure(100));
            end
            
            temp = mean(tempAUC);
            forAUCavg = temp;

            temp = mean(tempAUC2);
            forAUCsecondsAVG = temp;

            AUClabel = [string('AUC(frames)'),string('AUC(seconds)')];
            tempAUC = horzcat(tempAUC,tempAUC2);

            AvgAUClabel = [string('AvgAuc(frames)'),string('AvgAuc(seconds)')];
            tempAUCavg = horzcat(forAUCavg,forAUCsecondsAVG);
            
            tempAUC = vertcat(AUClabel,tempAUC,AvgAUClabel,tempAUCavg);
            Stim1PeaksData = horzcat(Stim1PeaksData,tempAUC);
            
            clear tempAUC tempAUC2;
           
            g = size(locs2,1);
            tempAUC = [];
            tempAUC2 = [];
            
            for z = 1:g
                figure(100);
                plot(Stim2);
                set(gcf,'Position',[100,100,1080,360]);
                hold on;
                grid on;
                daspect([8 1 1]);
                hold on;
                SIZE = size(Stim2);
                xticks(0:2:SIZE);
                idx = locs2(z:z,1:1)*Fs + 1;
                idx = round(idx);
                plot(Stim2,'r*','MarkerSize',10,'linewidth',2,'MarkerIndices',idx);
                prompt = {'Enter start for current peak AUC (frame)','Enter stop for current peak AUC (frame)'};
                dlg_title = 'AUC start and stop for current peak';
                num_lines = 1;
                defaultans = {'0','20'};
                INPUTVAR = str2double(inputdlg(prompt,dlg_title,num_lines,defaultans));
                curPeakAUC = trapz(Stim1(INPUTVAR(1,1):INPUTVAR(2,1)));
                curPeakAUCseconds = curPeakAUC/Fs;
                
                tempAUC = vertcat(tempAUC,curPeakAUC);
                tempAUC2 = vertcat(tempAUC2,curPeakAUCseconds);
                
                close(figure(100));
            end
            
            temp = mean(tempAUC);
            forAUCavg = temp;

            temp = mean(tempAUC2);
            forAUCsecondsAVG = temp;

            AUClabel = [string('AUC(frames)'),string('AUC(seconds)')];
            tempAUC = horzcat(tempAUC,tempAUC2);

            AvgAUClabel = [string('AvgAuc(frames)'),string('AvgAuc(seconds)')];
            tempAUCavg = horzcat(forAUCavg,forAUCsecondsAVG);
            
            tempAUC = vertcat(AUClabel,tempAUC,AvgAUClabel,tempAUCavg);
            Stim2PeaksData = horzcat(Stim2PeaksData,tempAUC);
            
            clear tempAUC tempAUC2;


            g = size(locs3,1);
            tempAUC = [];
            tempAUC2 = [];
            
            for z = 1:g
                figure(100);
                plot(Stim3);
                set(gcf,'Position',[100,100,1080,360]);
                hold on;
                grid on;
                daspect([8 1 1]);
                hold on;
                SIZE = size(Stim3);
                xticks(0:2:SIZE);
                idx = locs3(z:z,1:1)*Fs + 1;
                idx = round(idx);
                plot(Stim3,'r*','MarkerSize',10,'linewidth',2,'MarkerIndices',idx);
                prompt = {'Enter start for current peak AUC (frame)','Enter stop for current peak AUC (frame)'};
                dlg_title = 'AUC start and stop for current peak';
                num_lines = 1;
                defaultans = {'0','20'};
                INPUTVAR = str2double(inputdlg(prompt,dlg_title,num_lines,defaultans));
                curPeakAUC = trapz(Stim1(INPUTVAR(1,1):INPUTVAR(2,1)));
                curPeakAUCseconds = curPeakAUC/Fs;
                
                tempAUC = vertcat(tempAUC,curPeakAUC);
                tempAUC2 = vertcat(tempAUC2,curPeakAUCseconds);
                
                close(figure(100));
            end
            
            temp = mean(tempAUC);
            forAUCavg = temp;

            temp = mean(tempAUC2);
            forAUCsecondsAVG = temp;

            AUClabel = [string('AUC(frames)'),string('AUC(seconds)')];
            tempAUC = horzcat(tempAUC,tempAUC2);

            AvgAUClabel = [string('AvgAuc(frames)'),string('AvgAuc(seconds)')];
            tempAUCavg = horzcat(forAUCavg,forAUCsecondsAVG);
            
            tempAUC = vertcat(AUClabel,tempAUC,AvgAUClabel,tempAUCavg);
            Stim3PeaksData = horzcat(Stim3PeaksData,tempAUC);
            
            clear tempAUC tempAUC2;
            


            g = size(locs4,1);
            tempAUC = [];
            tempAUC2 = [];
            
            for z = 1:g
                figure(100);
                plot(Stim4);
                set(gcf,'Position',[100,100,1080,360]);
                hold on;
                grid on;
                daspect([8 1 1]);
                hold on;
                SIZE = size(Stim4);
                xticks(0:2:SIZE);
                idx = locs4(z:z,1:1)*Fs + 1;
                idx = round(idx);
                plot(Stim4,'r*','MarkerSize',10,'linewidth',2,'MarkerIndices',idx);
                prompt = {'Enter start for current peak AUC (frame)','Enter stop for current peak AUC (frame)'};
                dlg_title = 'AUC start and stop for current peak';
                num_lines = 1;
                defaultans = {'0','20'};
                INPUTVAR = str2double(inputdlg(prompt,dlg_title,num_lines,defaultans));
                curPeakAUC = trapz(Stim1(INPUTVAR(1,1):INPUTVAR(2,1)));
                curPeakAUCseconds = curPeakAUC/Fs;
                
                tempAUC = vertcat(tempAUC,curPeakAUC);
                tempAUC2 = vertcat(tempAUC2,curPeakAUCseconds);
                
                close(figure(100));
            end
            
            temp = mean(tempAUC);
            forAUCavg = temp;

            temp = mean(tempAUC2);
            forAUCsecondsAVG = temp;

            AUClabel = [string('AUC(frames)'),string('AUC(seconds)')];
            tempAUC = horzcat(tempAUC,tempAUC2);

            AvgAUClabel = [string('AvgAuc(frames)'),string('AvgAuc(seconds)')];
            tempAUCavg = horzcat(forAUCavg,forAUCsecondsAVG);
            
            tempAUC = vertcat(AUClabel,tempAUC,AvgAUClabel,tempAUCavg);
            Stim4PeaksData = horzcat(Stim4PeaksData,tempAUC);
            
            clear tempAUC tempAUC2;


            g = size(locs5,1);
            tempAUC = [];
            tempAUC2 = [];
            
            for z = 1:g
                figure(100);
                plot(Stim5);
                set(gcf,'Position',[100,100,1080,360]);
                hold on;
                grid on;
                daspect([8 1 1]);
                hold on;
                SIZE = size(Stim5);
                xticks(0:2:SIZE);
                idx = locs5(z:z,1:1)*Fs + 1;
                idx = round(idx);
                plot(Stim5,'r*','MarkerSize',10,'linewidth',2,'MarkerIndices',idx);
                prompt = {'Enter start for current peak AUC (frame)','Enter stop for current peak AUC (frame)'};
                dlg_title = 'AUC start and stop for current peak';
                num_lines = 1;
                defaultans = {'0','20'};
                INPUTVAR = str2double(inputdlg(prompt,dlg_title,num_lines,defaultans));
                curPeakAUC = trapz(Stim1(INPUTVAR(1,1):INPUTVAR(2,1)));
                curPeakAUCseconds = curPeakAUC/Fs;
                
                tempAUC = vertcat(tempAUC,curPeakAUC);
                tempAUC2 = vertcat(tempAUC2,curPeakAUCseconds);
                
                close(figure(100));
            end
            
            temp = mean(tempAUC);
            forAUCavg = temp;

            temp = mean(tempAUC2);
            forAUCsecondsAVG = temp;

            AUClabel = [string('AUC(frames)'),string('AUC(seconds)')];
            tempAUC = horzcat(tempAUC,tempAUC2);

            AvgAUClabel = [string('AvgAuc(frames)'),string('AvgAuc(seconds)')];
            tempAUCavg = horzcat(forAUCavg,forAUCsecondsAVG);
            
            tempAUC = vertcat(AUClabel,tempAUC,AvgAUClabel,tempAUCavg);
            Stim5PeaksData = horzcat(Stim5PeaksData,tempAUC);
            
            clear tempAUC tempAUC2;


            g = size(locs6,1);
            tempAUC = [];
            tempAUC2 = [];
            
            for z = 1:g
                figure(100);
                plot(Stim6);
                set(gcf,'Position',[100,100,1080,360]);
                hold on;
                grid on;
                daspect([8 1 1]);
                hold on;
                SIZE = size(Stim6);
                xticks(0:2:SIZE);
                idx = locs6(z:z,1:1)*Fs + 1;
                idx = round(idx);
                plot(Stim6,'r*','MarkerSize',10,'linewidth',2,'MarkerIndices',idx);
                prompt = {'Enter start for current peak AUC (frame)','Enter stop for current peak AUC (frame)'};
                dlg_title = 'AUC start and stop for current peak';
                num_lines = 1;
                defaultans = {'0','20'};
                INPUTVAR = str2double(inputdlg(prompt,dlg_title,num_lines,defaultans));
                curPeakAUC = trapz(Stim1(INPUTVAR(1,1):INPUTVAR(2,1)));
                curPeakAUCseconds = curPeakAUC/Fs;
                
                tempAUC = vertcat(tempAUC,curPeakAUC);
                tempAUC2 = vertcat(tempAUC2,curPeakAUCseconds);
                
                close(figure(100));
            end
            
            temp = mean(tempAUC);
            forAUCavg = temp;

            temp = mean(tempAUC2);
            forAUCsecondsAVG = temp;

            AUClabel = [string('AUC(frames)'),string('AUC(seconds)')];
            tempAUC = horzcat(tempAUC,tempAUC2);

            AvgAUClabel = [string('AvgAuc(frames)'),string('AvgAuc(seconds)')];
            tempAUCavg = horzcat(forAUCavg,forAUCsecondsAVG);
            
            tempAUC = vertcat(AUClabel,tempAUC,AvgAUClabel,tempAUCavg);
            Stim6PeaksData = horzcat(Stim6PeaksData,tempAUC);
            
            clear tempAUC tempAUC2;


            g = size(locs7,1);
            tempAUC = [];
            tempAUC2 = [];
            
            for z = 1:g
                figure(100);
                plot(Stim7);
                set(gcf,'Position',[100,100,1080,360]);
                hold on;
                grid on;
                daspect([8 1 1]);
                hold on;
                SIZE = size(Stim7);
                xticks(0:2:SIZE);
                idx = locs7(z:z,1:1)*Fs + 1;
                idx = round(idx);
                plot(Stim7,'r*','MarkerSize',10,'linewidth',2,'MarkerIndices',idx);
                prompt = {'Enter start for current peak AUC (frame)','Enter stop for current peak AUC (frame)'};
                dlg_title = 'AUC start and stop for current peak';
                num_lines = 1;
                defaultans = {'0','20'};
                INPUTVAR = str2double(inputdlg(prompt,dlg_title,num_lines,defaultans));
                curPeakAUC = trapz(Stim1(INPUTVAR(1,1):INPUTVAR(2,1)));
                curPeakAUCseconds = curPeakAUC/Fs;
                
                tempAUC = vertcat(tempAUC,curPeakAUC);
                tempAUC2 = vertcat(tempAUC2,curPeakAUCseconds);
                
                close(figure(100));
            end
            
            temp = mean(tempAUC);
            forAUCavg = temp;

            temp = mean(tempAUC2);
            forAUCsecondsAVG = temp;

            AUClabel = [string('AUC(frames)'),string('AUC(seconds)')];
            tempAUC = horzcat(tempAUC,tempAUC2);

            AvgAUClabel = [string('AvgAuc(frames)'),string('AvgAuc(seconds)')];
            tempAUCavg = horzcat(forAUCavg,forAUCsecondsAVG);
            
            tempAUC = vertcat(AUClabel,tempAUC,AvgAUClabel,tempAUCavg);
            Stim7PeaksData = horzcat(Stim7PeaksData,tempAUC);
            
            clear tempAUC tempAUC2;


            g = size(locs8,1);
            tempAUC = [];
            tempAUC2 = [];
            
            for z = 1:g
                figure(100);
                plot(Stim8);
                set(gcf,'Position',[100,100,1080,360]);
                hold on;
                grid on;
                daspect([8 1 1]);
                hold on;
                SIZE = size(Stim8);
                xticks(0:2:SIZE);
                idx = locs8(z:z,1:1)*Fs + 1;
                idx = round(idx);
                plot(Stim8,'r*','MarkerSize',10,'linewidth',2,'MarkerIndices',idx);
                prompt = {'Enter start for current peak AUC (frame)','Enter stop for current peak AUC (frame)'};
                dlg_title = 'AUC start and stop for current peak';
                num_lines = 1;
                defaultans = {'0','20'};
                INPUTVAR = str2double(inputdlg(prompt,dlg_title,num_lines,defaultans));
                curPeakAUC = trapz(Stim1(INPUTVAR(1,1):INPUTVAR(2,1)));
                curPeakAUCseconds = curPeakAUC/Fs;
                
                tempAUC = vertcat(tempAUC,curPeakAUC);
                tempAUC2 = vertcat(tempAUC2,curPeakAUCseconds);
                
                close(figure(100));
            end
            
            temp = mean(tempAUC);
            forAUCavg = temp;

            temp = mean(tempAUC2);
            forAUCsecondsAVG = temp;

            AUClabel = [string('AUC(frames)'),string('AUC(seconds)')];
            tempAUC = horzcat(tempAUC,tempAUC2);

            AvgAUClabel = [string('AvgAuc(frames)'),string('AvgAuc(seconds)')];
            tempAUCavg = horzcat(forAUCavg,forAUCsecondsAVG);
            
            tempAUC = vertcat(AUClabel,tempAUC,AvgAUClabel,tempAUCavg);
            Stim8PeaksData = horzcat(Stim8PeaksData,tempAUC);
            
            clear tempAUC tempAUC2;


            g = size(locs9,1);
            tempAUC = [];
            tempAUC2 = [];
            
            for z = 1:g
                figure(100);
                plot(Stim9);
                set(gcf,'Position',[100,100,1080,360]);
                hold on;
                grid on;
                daspect([8 1 1]);
                hold on;
                SIZE = size(Stim9);
                xticks(0:2:SIZE);
                idx = locs9(z:z,1:1)*Fs + 1;
                idx = round(idx);
                plot(Stim9,'r*','MarkerSize',10,'linewidth',2,'MarkerIndices',idx);
                prompt = {'Enter start for current peak AUC (frame)','Enter stop for current peak AUC (frame)'};
                dlg_title = 'AUC start and stop for current peak';
                num_lines = 1;
                defaultans = {'0','20'};
                INPUTVAR = str2double(inputdlg(prompt,dlg_title,num_lines,defaultans));
                curPeakAUC = trapz(Stim1(INPUTVAR(1,1):INPUTVAR(2,1)));
                curPeakAUCseconds = curPeakAUC/Fs;
                
                tempAUC = vertcat(tempAUC,curPeakAUC);
                tempAUC2 = vertcat(tempAUC2,curPeakAUCseconds);
                
                close(figure(100));
            end
            
            temp = mean(tempAUC);
            forAUCavg = temp;

            temp = mean(tempAUC2);
            forAUCsecondsAVG = temp;

            AUClabel = [string('AUC(frames)'),string('AUC(seconds)')];
            tempAUC = horzcat(tempAUC,tempAUC2);

            AvgAUClabel = [string('AvgAuc(frames)'),string('AvgAuc(seconds)')];
            tempAUCavg = horzcat(forAUCavg,forAUCsecondsAVG);
            
            tempAUC = vertcat(AUClabel,tempAUC,AvgAUClabel,tempAUCavg);
            Stim9PeaksData = horzcat(Stim9PeaksData,tempAUC);
            
            clear tempAUC tempAUC2;
            
            clear pks1 pks2 pks3 pks4 pks5 pks6 pks7 pks8 pks9 locs1 locs2 locs3 locs4 locs5 locs6 locs7 locs8 locs9

        end
    end
    
    AgCellAVGs_Labels = {'AVGpeaks','AVGwidths(frames)','AVGwidths(seconds)','AVGproms','AVGaucs(frames)','AVGaucs(seconds)'};
    AgCellAVGs = {mean(forAVGpks),mean(forAVGwidthsFrames),mean(forAVGwidthsSeconds),mean(forAVGproms),mean(forAUCavg),mean(forAUCsecondsAVG)};
    AgCellAVGs = vertcat(AgCellAVGs_Labels,AgCellAVGs);
    AgCell = {};
    AgCell = {AgCellAVGs};
    
    tempData = {Stim1PeaksData,Stim2PeaksData,Stim3PeaksData,Stim4PeaksData,Stim5PeaksData,Stim6PeaksData,Stim7PeaksData,Stim8PeaksData,Stim9PeaksData,AgCell};
    
    AllData = vertcat(AllData,tempData);
    
end

AllData_ColLabel = {'Cell number', 'Stim1', 'Stim2', 'Stim3', 'Stim4', 'Stim5', 'Stim6', 'Stim7', 'Stim8', 'Stim9','AvgCellData'};
AllData_RowLabel = {};

for m = 1:numCols
    cnt = num2str(m);
    tempLabel = strcat('Cell ', cnt);
    AllData_RowLabel = vertcat(AllData_RowLabel,tempLabel);
end

AllData = horzcat(AllData_RowLabel,AllData);
AllData = vertcat(AllData_ColLabel,AllData);

DATAtop = {'Cell number', 'Full recording', 'preStim', 'Stim1', 'Stim2', 'Stim3', 'Stim4', 'Stim5', 'Stim6', 'Stim7', 'Stim8', 'Stim9', 'Avg for cell'}
DATAleft = {};

for i=1:numCols
    temp = i;
    DATAleft = vertcat(DATAleft,temp);
end

clearvars -except AllData myDir data;
myDir = uigetdir;
filename = [myDir '/FinalResultsWorkSpace.mat'];
save(filename);