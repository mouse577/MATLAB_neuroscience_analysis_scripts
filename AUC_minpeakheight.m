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

       

%prompt for # of ROIs
prompt = {'Baseline start (frame)','baseline stop (frame)','Sampling Rate (Hz)','Threshold for events (SD)',};
dlg_title = 'Input variables';
num_lines = 1;
defaultans = {'1','50','2.96','3'};
InputVars = str2double(inputdlg(prompt,dlg_title,num_lines,defaultans));

%pull out input variables
BaseStrt = InputVars(1,1);
BaseStp = InputVars(2,1);
Fs = InputVars(3,1); 
EvSD = InputVars(4,1);
%%
%useful for visualzing many cells, though suppress (%) if desired. 
set(0,'DefaultAxesFontSize',16,'DefaultFigureWindowStyle','docked')

%%
%Find the number of events and characteristics of events

%create variables to populate
Amp_All = {};
Index_All = {};
Duration_All = {};
Prom_All = {};
Amp_Means = [];
Index_Means = [];
Duration_Means = [];
Prom_Means = [];
Event_Hz = [];

%find events
for i = 1:size(data,2)
    
    findpeaks(data(:,i),Fs,'MinPeakHeight',0.5);
    [pks,locs,widths,proms] = findpeaks(data(BaseStrt:BaseStp,i)); %find all peaks for individual trace
    %figure,plot(data(:,i));
    MeanProms = mean(proms);%mean prominence of all peaks for individual trace
    StdProms = std(proms);%standard deviation of prominence of all peaks for individual trace
    UseProms = MeanProms + StdProms*EvSD;%determine standard deviations
    %clear pks locs widths proms
    [pks,locs,widths,proms] = findpeaks(data(:,i),Fs,'MinPeakProminence',UseProms,'WidthReference','halfprom','MinPeakHeight',0.5); %find peaks > 3 std for individual trace
    if isempty(pks)
    else
        figure,findpeaks(data(:,i),Fs,'MinPeakProminence',UseProms,'Annotate','extents','WidthReference','halfprom') %annotate peaks >3 std on individual figures
        xlabel('Time (s)');
        ylabel('\DeltaF/F_0');
        title(i)
    end
    Amp_Means = horzcat(Amp_Means,mean(pks));
    Index_Means = horzcat(Index_Means,mean(locs));
    Duration_Means = horzcat(Duration_Means,mean(widths));
    Prom_Means = horzcat(Prom_Means,mean(proms));
    Event_Hz = horzcat(Event_Hz,(length(pks)/(size(data,1)/Fs)));
    Amp_All{1,i} = pks;
    Index_All{1,i} = locs;
    Duration_All{1,i} = widths;
    Prom_All{1,i} = proms;
    %clear pks locs widths proms
end 

%%
%find area under the curve (AUC)
t = 1/Fs:1/Fs:size(data,1)/Fs;%create a time variable same length as data
AUC = trapz(t,data);

%%
%plot all traces
figure, plot(data)

%%

%clear data dataName defaultans dlg_title i InputVars MeanProms num_lines prompt StdProms UseProms

%%
%transpose data to import into excel
tAUC = AUC.';
tAmp_All = Amp_All.';
tDuration_All = Duration_All.';
tEventHz = Event_Hz.';


