%%Quick dF/F0 and plot for cells in excel spreadsheet or txt file
%import spreadsheet as a matrix
%this version should be used if multiple arrays are in a single column
    %(such as output from ImageJ). 

[data,dataName] = uigetvariables('Choose data variable');%chooses variable
data = data{1,1};%converts from a cell format to original format of the variable. 

%prompt for # of ROIs
prompt = {'Number of Frames:','Baseline Start:','Baseline Stop:','Frame Rate (Hz)'};
dlg_title = 'Input variables';
num_lines = 1;
defaultans = {'500','1','50','15.49'};
InputVars = str2double(inputdlg(prompt,dlg_title,num_lines,defaultans));

%pull out input variables
Frames = InputVars(1,1);
BaseStrt = InputVars(2,1);
BaseStop = InputVars(3,1); 
Fs = InputVars(4,1);

%%
%separate ROIs 
Fless1 = Frames - 1;
All_Raw = [];
for kk = 1:Frames:size(data,1);
    starts = data(kk:kk+Fless1,:);
    All_Raw = horzcat(All_Raw,starts);
end

%%
%Convert to dF/F0 using own baseline

Baseline = mean(All_Raw(BaseStrt:BaseStop,:));

for i = 1:length(Baseline)
    All_dF(:,i) = minus(All_Raw(:,i),Baseline(1,i));
end

for j = 1:length(Baseline)
    All_dFoverF0(:,j) = All_dF(:,j)./Baseline(1,j);
end

%%
%... or convert to dF/F0 using a general baseline

% Baseline = mean(BaseRecorded,1);
% 
% for i = 1:length(Baseline)
%     All_dF(:,i) = minus(All_Raw(:,i),Baseline(1,i));
% end
% 
% for j = 1:length(Baseline)
%     All_dFoverF0(:,j) = All_dF(:,j)./Baseline(1,j);
% end

%%
%Plot
t = 1/Fs:1/Fs:size(All_dFoverF0,1)/Fs;
figure
h = plot(t,All_dFoverF0,'DisplayName','All_dFoverF0');
%set(h,{'DisplayName'},{'Whole FOV';'High Res ROI';'Thresh 50%';'Thresh 75%'})
xlabel('Time (s)');
ylabel('\DeltaF/F_0');

%%
clear All_dF Data i All_Raw AneuronROItraces data dataName defaultans dlg_title Fless1 Frames InputVars j kk num_lines prompt starts h