%% Find beginning and end of CSD wave

% This version uses applies a smoothing filter for each ROI,
% and uses an average end line to determine the CSD ending 
% when the deltaF/F does not return to BL after CSD

%% Measurements are in the CSDmeasurements variable

% Copy and paste the name is the imported DAT file 
RawData=AVGSD0000046Hzreduced3hztrueF;

% Enter frame rate
frameRate = 3

% Enter the total number of ROI's (columns in DAT file, number of soma)
ROItotal = 65

NoReturn = []
NoRetCount = 1

figure
%tiledlayout(ROItotal,4, 'TileSpacing','compact','Padding','compact')
%tiledlayout(ROItotal,1)

for i=1:ROItotal
    %SmoothRaw = smoothdata(RawData(:,i))
    SmoothRaw = RawData(:,i)
    %f2 = figure
    %plot(RawData(:,i))
    nexttile
    plot(SmoothRaw)
    hold on
    %pause
    %disp(i)
    %[M,indices]=max(RawData(:,i))
    [M, indices] = max(SmoothRaw)
    %FinalVar(1,i) = max(RawData(:,i))
    FinalVar(1,i) = max(SmoothRaw)
    %base=RawData(1:(indices-20),i)
    %base = SmoothRaw(1:(indices - 20), 1)
    base = SmoothRaw(1:10, 1)
    baseavg=mean(base)
    %CSDbeg =find(RawData(:,i)>=(4*std(base),1,'first')-1);%begging
    
    %CSDbegThreshold = find(RawData(:,i)>=(10*std(base)),1,'first')
    CSDbegThreshold = find(SmoothRaw(3:end,1)>=(8*std(base)),1, 'first') %+ 5
    
    if CSDbegThreshold > 1
        CSDbeg = CSDbegThreshold - 1
    else 
        CSDbeg = CSDbegThreshold
    end
        %CSD=RawData(indices:end,i)
    CSD = SmoothRaw(indices:end,1)
    %trueCSD1 = RawData(CSDbeg:end,i)
    trueCSD1 = SmoothRaw(CSDbeg:end, 1)
 
    retBLindices = find(CSD<=baseavg,1,'first') + indices
    TF = isempty(retBLindices)
    

    if TF == 0
        CSDlengthframes=find(CSD<=baseavg,1,'first')+CSDbeg+1;%end
        FinalVar(2,i) = CSDlengthframes
        FinalVar(3,i) = CSDlengthframes/frameRate
        t = 0:1/frameRate:length(RawData(CSDbeg:CSDlengthframes,i))/frameRate 
        t = t(:,2:end)
        FinalVar(4,i) = trapz(t,RawData(CSDbeg:CSDlengthframes,i))
        %plot(t,RawData(CSDbeg:CSDlengthframes,i))
        CSDmeasurements=[string('Max');string('CSDlengths');string('CSDseconds');string('CSDCaLoads')]
        CSDmeasurements=horzcat(CSDmeasurements,FinalVar)
        %close(f2)
    else
        EndLine = CSD(end-200:end)
        EndLineAvg = mean(EndLine)
        CSDlengthframes = find(CSD<=EndLineAvg,1,'first') + CSDbeg + 1
        NoReturn(NoRetCount,1) = i
        NoRetCount = NoRetCount + 1
        FinalVar(2,i) = CSDlengthframes
        FinalVar(3,i) = CSDlengthframes/frameRate
        t = 0:1/frameRate:length(RawData(CSDbeg:CSDlengthframes,i))/frameRate 
        t = t(:,2:end)
        FinalVar(4,i) = trapz(t,RawData(CSDbeg:CSDlengthframes,i))
        %plot(t,RawData(CSDbeg:CSDlengthframes,i))
        CSDmeasurements=[string('Max');string('CSDlengths');string('CSDseconds');string('CSDCaLoads')]
        CSDmeasurements=horzcat(CSDmeasurements,FinalVar)
        %close(f2)
    end

    
    plot(SmoothRaw,'r*','MarkerSize',10,'linewidth',2,'MarkerIndices',indices)
    plot(SmoothRaw,'bo','MarkerSize',10,'linewidth',2,'MarkerIndices',(CSDlengthframes + (indices - CSDbeg)))
    plot(SmoothRaw,'go','MarkerSize',10,'linewidth',2,'MarkerIndices',CSDbeg)
    hold off
    
    title('CSD Ca++ dF/F')
    xlabel('Frames')
    ylabel('df/f')
    alpha(0.3)

%     
%     
%     
%     CSDmeasurement.lengthseconds(i)=CSDmeasurement.lengthframes(i)/2.96%creates structure
%     CSDmeasurement(:,i) = CSDmeasurement.lengthframes(i)/2.96;%creates double
%     CSDmeasurement{:,i} = CSDmeasurement.lengthframes(i)/2.96;%creates cell
%     
%     trueCSD=RawData(CSDbeg:(CSDbeg+CSDmeasurement.lengthframes(i)-1),i);
%     t=1/2.96:1/2.96:CSDmeasurement.lengthframes(i)/2.96;
% %     auc(i)=trapz(t,trueCSD);
%     CSDmeasurement.auc(i)=trapz(t,trueCSD);
end
% CSDmeasurement=[auc; CSDlengthframes;CSDlengthseconds];

