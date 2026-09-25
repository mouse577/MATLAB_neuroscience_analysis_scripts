%% Find beginning and end of CSD wave

% This version applies a smoothing filter for each ROI,
% and uses an average end line to determine the CSD ending 
% when the deltaF/F does not return to BL after CSD

%% Measurements are in the CSDmeasurements variable

% Copy and paste the name is the imported DAT file 
RawData=data;

% Enter frame rate
%frameRate = 3

prompt = "what is the frame rate? "
frameRate = input(prompt)

prompt = "Is there TBOA? (enter 1 for yes, 0 for no) "
TBOA = input(prompt)

% Enter the total number of ROI's (columns in DAT file, number of soma)
ROItotal = size(data,2)

NoReturn = []
NoRetCount = 1

skippedProblems = []
skippedNumbers = []

CSDmeasurements=[string('MaxdF/F');string('HalfMaxdF/F');string('FWHMframes');string('FWHMseconds');string('Time2MaxFrames');string('Time2MaxSeconds');string('Time2BaseFrames');string('Time2BaseSeconds');string('CSDlengthFrames');string('CSDlengthSeconds');string('CSDCaLoadFrames');string('CSDCaLoadSeconds')]



figure(5)

for i=1:ROItotal
    
    if TBOA == 0
        SmoothRaw = RawData(:,i)
    else
        SmoothRaw = smoothdata(RawData(:,i))
    end
    
    SmoothRaw(isnan(SmoothRaw))=0
    nexttile
    plot(SmoothRaw)
    hold on
    %pause
    %disp(i)
    [M, indices] = max(SmoothRaw)
    FinalVar(1,i) = max(SmoothRaw)
    HalfM = M/2
    FinalVar(2,i) = HalfM
    base = SmoothRaw(1:10, 1)
    baseavg=mean(base) % add baseline to traces graphs
    CSDbeg = find(SmoothRaw(:,1)>=(8*std(base)),1, 'first') - 5
    CSDend = SmoothRaw(indices:end,1)
    CSDendIndices = find(CSDend<=baseavg,1,'first') + indices

    TF = isempty(CSDendIndices)
   
    if TF == 0
        CSDendIndices = find(CSDend<=baseavg,1,'first') + indices
    else
        EndLine = SmoothRaw(end-100:end)
        EndLineAvg = mean(EndLine)
    end

    CSDlengthframes = CSDendIndices - CSDbeg % 1
    CSDlengthseconds = CSDlengthframes / frameRate % 2
    TrueCSDbeginCoord = CSDbeg
    TrueCSDmaxCoord = indices
    TrueCSDendCoord = CSDendIndices

    CSDbeg_HalfMax = SmoothRaw(1:indices)
    HalfM_INDICES1 = find(CSDbeg_HalfMax >= M/2,1,'first')
    HalfM_INDICES2 = find(CSDend <= HalfM,1, 'first') + indices

    HalfM_frames = HalfM_INDICES2 - HalfM_INDICES1
    FinalVar(3,i) = HalfM_frames

    HalfM_seconds = HalfM_frames / frameRate
    FinalVar(4,i) = HalfM_seconds

    T2Max_frames = indices - CSDbeg
    FinalVar(5,i) = T2Max_frames

    T2Max_seconds = T2Max_frames / frameRate
    FinalVar(6,i) = T2Max_seconds

    Problem = size(CSDlengthframes,1)
    SM = sum(SmoothRaw)
    if SM <= 0
        continue
    
    elseif Problem > 0
        T2Base_frames = CSDendIndices - indices
        FinalVar(7,i) = T2Base_frames
        T2Base_seconds = T2Base_frames / frameRate
        FinalVar(8,i) = T2Base_seconds

        FinalVar(9,i) = CSDlengthframes
        FinalVar(10,i) = CSDlengthframes/frameRate

        t = 0:1/frameRate:length(RawData(CSDbeg:CSDendIndices,i))/frameRate
        t = t(:,2:end)

        smoothRaw_CSDalone = SmoothRaw(CSDbeg:CSDendIndices)
        CSDaucFrames = trapz(smoothRaw_CSDalone)
        FinalVar(11,i) = CSDaucFrames

        CSDaucSeconds = trapz(t,RawData(CSDbeg:CSDendIndices,i))
        FinalVar(12,i) = CSDaucSeconds

        CSDmeasurements=[string('MaxdF/F');string('HalfMaxdF/F');string('FWHMframes');string('FWHMseconds');string('Time2MaxFrames');string('Time2MaxSeconds');string('Time2BaseFrames');string('Time2BaseSeconds');string('CSDlengthFrames');string('CSDlengthSeconds');string('CSDCaLoadFrames');string('CSDCaLoadSeconds')]
        CSDmeasurements=horzcat(CSDmeasurements,FinalVar)
    else
        skippedProblems = horzcat(skippedProblems, SmoothRaw)
        skippedNumbers = vertcat(skippedNumbers, i)
    end
    plot(SmoothRaw,'r*','MarkerSize',10,'linewidth',2,'MarkerIndices',TrueCSDmaxCoord)
    plot(SmoothRaw,'go','MarkerSize',10,'linewidth',2,'MarkerIndices',TrueCSDbeginCoord)
    plot(SmoothRaw,'bo','MarkerSize',10,'linewidth',2,'MarkerIndices',TrueCSDendCoord)
    yl = yline(baseavg, '--r', {'Base Line'})
    plot([HalfM_INDICES1, HalfM_INDICES2], [HalfM, HalfM], 'Color','g','linewidth',3);
    hold off

    title('CSD Ca++ dF/F cell number ', i)
  
    xlabel('Frames')
    ylabel('df/f')
    alpha(0.3)

    
    
    %plot(SmoothRaw,'r*','MarkerSize',10,'linewidth',2,'MarkerIndices',TrueCSDmaxCoord)
    %plot(SmoothRaw,'go','MarkerSize',10,'linewidth',2,'MarkerIndices',TrueCSDbeginCoord)
    %plot(SmoothRaw,'bo','MarkerSize',10,'linewidth',2,'MarkerIndices',TrueCSDendCoord)
    %yl = yline(baseavg, '--r', {'Base Line'})
    %hold off
    
    %title('CSD Ca++ dF/F cell number ', i)
    %xlabel('Frames')
    %ylabel('df/f')
    %alpha(0.3)
end

problemSz = size(skippedProblems,2)
    if problemSz > 0
        figure(6)
        for i = 1:problemSz
            nexttile
            plot(skippedProblems(:,i))
            curNum = skippedNumbers(i,:)
            title('CSD Ca++ dF/F cell number ', curNum)
            xlabel('Frames')
            ylabel('df/f')
            alpha(0.3)
        end
    end
% CSDmeasurement=[auc; CSDlengthframes;CSDlengthseconds];

figure(7)
plot(correctedX,correctedY,'-xm')
hold on
plot(origXcoord,origYcoord, 'go', 'MarkerSize', 10, 'LineWidth', 2)
plot(maxCoords(:,1),maxCoords(:,2),'r*','MarkerSize',10, 'linewidth',2)
endCoordX = correctedX(TrueCSDendCoord,:)
endCoordY = correctedY(TrueCSDendCoord,:)
endCoords = [endCoordX endCoordY]
%plot('bo','MarkerSize',10,'linewidth',2,'MarkerIndices',endCoords)
plot(endCoordX, endCoordY, 'bo', 'MarkerSize', 10, 'LineWidth', 2)
%plot(EndXCoordsAll(:,m), EndYCoordsAll(:,m), 'bo', 'MarkerSize',10,'LineWidth',2)
%end
hold off
%xlim([(origXcoord - 20) (origXcoord + 20)])
%ylim([(origYcoord - 20) (origYcoord + 20)])
title('CSD displacement of selected movement feature')
xlabel('x-position (pixels)')
ylabel('y-position (pixels)')

endPair = [origCoords;endCoords]
endDistance = pdist(endPair,"euclidean")

prompt = "Save figures? (1 for yes, 0 for no)"
save = input(prompt)
if save == 1
    figure(4)
    saveas(gca, fullfile(pathstr, 'rawTraces.tif'))
    saveas(gca, fullfile(pathstr, 'rawTraces.fig'))
    figure(5)
    saveas(gca, fullfile(pathstr, 'tiledTraces.tif'))
    saveas(gca, fullfile(pathstr, 'tiledTraces.fig'))
    figure(6)
    saveas(gca, fullfile(pathstr, 'problemTraces.tif'))
    saveas(gca, fullfile(pathstr, 'problemTraces.fig'))
    figure(7)
    saveas(gca, fullfile(pathstr, 'Displacement.tif'))
    saveas(gca, fullfile(pathstr, 'Displacement.fig'))
end

clearvars -except CSDmeasurements data pathstr endDistance maxDistance
filename = [pathstr '\CaCSDmeasurements_workspace.mat']
save(filename)