%% CSD analysis for mouse cortex CSD GluSnFR %%

% 1) Select ROI in image j, plot z-axis profile

% 2) Type: "data = []" and paste both columns from imagej into data

% 3) Find the first frame when the CSD wave front reaches the ROI in imageJ

% 4) Enter the the frame number in CSDbeg

% 5) Press "Run"

%Enter CSD beginning frame here
CSDbeg = 239;

%Enter acquisition frame rate here
frameRate = 7.815;

dataSignal = data(:,2);
dataPixels = data(:,1);
time = dataPixels/frameRate;
time = time/2;

dataSize = size(data);
dataSize = dataSize(:,1);


TIME = [1:dataSize];
TIME = TIME/frameRate;
TIME = TIME';

base = dataSignal(1:CSDbeg-10,1);
baseAVG = mean(base);

sz = size(dataSignal);
SZ = sz(:,1);
deltaFcomputed = [];
temp = [];
for i = 1:SZ
    temp = dataSignal(i,1);
    temp = ((temp - baseAVG) / baseAVG);
    deltaFcomputed(i,1) = temp;
end

BASE = deltaFcomputed(1:CSDbeg-10,1);
BASEavg = mean(BASE);

[M,indices] = max(deltaFcomputed(:,1));
Max = M;
halfM = M/2; 

for k = CSDbeg:indices
    temp2 = deltaFcomputed(k,1);
    if temp2 >= halfM;
        firstHalf = k;
        break
    end
end



lastHalfArr = deltaFcomputed(indices:end,1);
lastHalfSize = size(lastHalfArr);
for j = 1:lastHalfSize
    temp3 = lastHalfArr(j,1);
    if temp3 <= halfM;
        secondHalf = j;
        break
    end
end

endFWHM = secondHalf + indices

FWHMframes = endFWHM - firstHalf;
FWHMsec = FWHMframes/frameRate;


T2maxFrames = indices;
T2maxFramesFromCSDbeg = T2maxFrames - CSDbeg;
T2maxSeconds = indices/frameRate;
T2maxSecondsFromCSDbeg = T2maxSeconds - (CSDbeg/frameRate);

%CSDbeg = find(deltaFcomputed(:,1)>(4*std(base)),1,'first')-1;

CSDend = deltaFcomputed(indices:end,1);
trueCSDend = find(CSDend <= BASEavg,1,'first') + indices;
%trueCSDend = CSDend(1:find(CSDend <= baseAVG,1));
SZ = size(CSDend);
SZ = SZ(:,1);
for i = 1:SZ
    cur = CSDend(i);
    if cur <= BASEavg
        trueCSDend = i + indices
        break
    end
end 
trueCSD = deltaFcomputed(CSDbeg:trueCSDend,1);
trueCSDlengthFrames = length(trueCSD);
trueCSDlengthSeconds = trueCSDlengthFrames / frameRate;
T2CSDendFramesFromMax = trueCSDend - indices;
T2CSDendSecondsFromMax = T2CSDendFramesFromMax / frameRate;

%[m,idx] = min(deltaFcomputed((trueCSDend+10):end,1));
%[m,idx] = min(deltaFcomputed(trueCSDend:end),1);
%min = m;

PostCSDend = deltaFcomputed(trueCSDend:end,1);
[m,idx] = min(PostCSDend);
Min = m;
realMinIdx = idx+10+trueCSDend;

postCSDfindMax = deltaFcomputed(realMinIdx:end,1);
[N,index] = max(postCSDfindMax);
if N < baseAVG
    truePostCSDend = index+realMinIdx;
else
    truePostCSDend = find(PostCSDend >= BASEavg,1,'first') + realMinIdx;
end
truePostCSD = deltaFcomputed(trueCSDend:truePostCSDend,1);

T2minFramesFromCSDend = realMinIdx - trueCSDend;
T2minFramesFromStart = trueCSDlengthFrames + CSDbeg + T2minFramesFromCSDend;
T2minSecondsFromCSDend = T2minFramesFromCSDend / frameRate;
truePostCSDlengthFrames = length(truePostCSD);
truePostCSDlengthSeconds = truePostCSDlengthFrames / frameRate;
T2postCSDendFramesToBaseFromMin = truePostCSDend - idx; 
T2postCSDendSecondsToBaseFromMin = T2postCSDendFramesToBaseFromMin / frameRate;
T2postCSDend = truePostCSDlengthFrames + trueCSDlengthFrames + CSDbeg;
T2postCSDFramesToBaseFromMin = truePostCSDlengthFrames - T2minFramesFromCSDend;
T2postCSDSecondsToBaseFromMin = T2postCSDFramesToBaseFromMin / frameRate;

CSDauc = trapz(trueCSD);
CSDaucTIME = trapz(TIME(1:trueCSDlengthFrames),trueCSD);
postCSDauc = trapz(truePostCSD);
postCSDaucTIME = trapz(TIME(1:truePostCSDlengthFrames),truePostCSD);

FinalVar(1,1) = Max;
FinalVar(2,1) = trueCSDlengthFrames;
FinalVar(3,1) = trueCSDlengthSeconds;
FinalVar(4,1) = T2maxFramesFromCSDbeg;
FinalVar(5,1) = T2maxSecondsFromCSDbeg;
FinalVar(6,1) = T2CSDendFramesFromMax;
FinalVar(7,1) = T2CSDendSecondsFromMax
FinalVar(8,1) = CSDauc;
FinalVar(9,1) = CSDaucTIME;
FinalVar(10,1) = Min;
FinalVar(11,1) = truePostCSDlengthFrames;
FinalVar(12,1) = truePostCSDlengthSeconds;
FinalVar(13,1) = T2minFramesFromCSDend;
FinalVar(14,1) = T2minSecondsFromCSDend;
FinalVar(15,1) = T2postCSDFramesToBaseFromMin;
FinalVar(16,1) = T2postCSDSecondsToBaseFromMin;
FinalVar(17,1) = postCSDauc;
FinalVar(18,1) = postCSDaucTIME;
FinalVar(19,1) = FWHMframes;
FinalVar(20,1) = FWHMsec;
FinalVar(21,1) = halfM;

CSDmeasurements = [string('CSD Max (df/f)');string('CSD Length (frames)');string('CSD Length (seconds)');string('CSD Time-to-Peak (frames)');string('CSD Time-to-Peak (seconds)');string('CSD Decay time (frames)');string('CSD Decay time (seconds)');string('CSD glu Load FRAMES (auc)');string('CSD glu Load TIME (auc)');string('post-CSD Min (%df/f)');string('post-CSD Length (frames)');string('post-CSD Length (seconds)');string('post-CSD Time-to-Trough (frames)');string('post-CSD Time-to-Trough (seconds)');string('post-CSD Time-to-Base (frames)');string('post-CSD Time-to-Base (seconds)');string('post-CSD glu Load FRAMES (auc)');string('post-CSD glu Load TIME (auc)');string('CSD FWHM frames');string('CSD FWHM seconds');string('CSD FWHM amplitude')];
CSDmeasurements = horzcat(CSDmeasurements, FinalVar);

plot(deltaFcomputed,'Color','k','linewidth',2)
hold on
plot(deltaFcomputed,'r*','MarkerSize',10,'linewidth',2,'MarkerIndices',indices)
plot(deltaFcomputed,'ro','MarkerSize',10,'linewidth',2,'MarkerIndices',realMinIdx)
xl = xline(CSDbeg, '-', {'CSD start'})
xl.LabelVerticalAlignment = 'middle'
xl.LabelHorizontalAlignment = "left"
xm = xline(trueCSDend, '-', {'CSD end'})
xm.LabelVerticalAlignment = 'middle'
xm.LabelHorizontalAlignment = "left"
xn = xline(T2postCSDend, '-', {'postCSD end'})
xn.LabelVerticalAlignment = 'middle'
xn.LabelHorizontalAlignment = "left"
yl = yline(BASEavg, '--r', {'Base Line'})

plot([firstHalf, endFWHM], [halfM, halfM], 'Color','g','linewidth',3);
%title("FWHM");
text(firstHalf, endFWHM, 'FWHM');
%A = (x1, halfM);
%B = (x2, halfM);
%plot(A,B);
%ym = yline(halfM, '-b', {'CSD FWHM'})

hold off
title('GluSnFR %df/f CSD')
xlabel('Frames')
ylabel('df/f')
alpha(0.3)

clear base
clear BASE
clear baseAVG
clear CSDauc
clear CSDaucTIME
clear CSDbeg
clear CSDend
clear cur
clear i
clear idx
clear index
clear indices
clear m
clear M
clear Max
clear Min
clear N
clear postCSDauc
clear postCSDaucTIME
clear PostCSDend
clear postCSDfindMax
clear realMinIdx
clear sz
clear SZ
clear T2CSDendFramesFromMax
clear T2CSDendSecondsFromMax
clear T2maxFrames
clear T2maxFramesFromCSDbeg
clear T2maxSeconds
clear T2maxSecondsFromCSDbeg
clear T2minFramesFromStart
clear T2minFramesFromCSDend
clear T2minSecondsFromCSDend
clear T2postCSDend
clear T2postCSDendFramesToBaseFromMin
clear T2postCSDendSecondsToBaseFromMin
clear temp
clear time
clear TIME
clear trueCSD
clear trueCSDend
clear trueCSDlengthFrames
clear trueCSDlengthSeconds
clear truePostCSD
clear truePostCSDend
clear truePostCSDlengthFrames
clear truePostCSDlengthSeconds
