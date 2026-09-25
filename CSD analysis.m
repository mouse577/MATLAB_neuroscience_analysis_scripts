Fs = 7.815; %%change this based on dataset
%time=(1/Fs:1/Fs:length(data)/Fs)';

%%
%data=1;
% paste imagej data into data
% delete data 1st column
data = [4496,2]
data1 = data(:,2)
pixels = data(:,1)
time = pixels/15.72

figure(1)
plot(time, data1)

[M,indices]=max(data1(:,1));
FinalVar(1,1) = max(data1(:,1));
base = data1(1:indices-10,1);
baseavg = mean(base);
CSDbeg = find(data1(:,1)>(4*std(base)),1,'first')-1;
CSD = data1(indices:end,1);
trueCSD1 = data1(CSDbeg:end,1);
CSDlengthframes = find(CSD <= baseavg,1,'first') + CSDbeg+1;
FinalVar(2,1) = CSDlengthframes;
FinalVar(3,1) = CSDlengthframes/15.72;
t = 0:1/15.72:length(data1(CSDbeg:CSDlengthframes,1));
t = t(:,2:end);
FinalVar(4,1) = trapz(t, data1(CSDbeg:CSDlengthframes,1));
plot(t,data1(CSDbeg:CSDlengthframes,1))
CSDmeasurements = [string('Max');string('CSDlength');string('CSDseconds');string('CSDCaLoad')];
CSDmeasurements = harzcat(CSDmeasurements, FinalVar)

%%



%%Find beginning and end of CSD wave
RawData=ch2170529089trueF;
figure
hold on
for i=1:21
    [M,indices]=max(RawData(:,i));
    FinalVar(1,i) = max(RawData(:,i));
    base=RawData(1:(indices-10),i);
    baseavg=mean(base);
    CSDbeg =find(RawData(:,i)>(8*std(base)),1,'first')-1;%begging
    CSD=RawData(indices:end,i);
    trueCSD1 = RawData(CSDbeg:end,i);
    CSDlengthframes=find(CSD<=baseavg,1,'first')+CSDbeg+1;%end
    FinalVar(2,i) = CSDlengthframes;
    FinalVar(3,i) = CSDlengthframes/2.96;
    t = 0:1/2.96:length(RawData(CSDbeg:CSDlengthframes,i))/2.96; 
    t = t(:,2:end);
    FinalVar(4,i) = trapz(t,RawData(CSDbeg:CSDlengthframes,i));
    plot(t,RawData(CSDbeg:CSDlengthframes,i))
    CSDmeasurements=[string('Max');string('CSDlengths');string('CSDseconds');string('CSDCaLoads')];
    CSDmeasurements=horzcat(CSDmeasurements,FinalVar)
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
hold off










figure(1)
plot(time, data);

figure(2)
plot(data);
%% identify pre and post csd frames
%% max amplitude
CSDamp = max(data(1:length(data))); %change 1 to start of wave, change length(data) to stop of wave
CSDamp = max(data(812:1092)); %change 1 to start of wave, change length(data) to stop of wave

figure(2)
hold all
plot([1;length(data)],[CSDamp/2;CSDamp/2]);
plot([1;length(data)],[0;0]);

%% duration
CSDdur = length(find(data>CSDamp/2))/Fs;

%% AUC
%% points above zero
CSDauc = trapz(time(812:1092),data(812:1092));