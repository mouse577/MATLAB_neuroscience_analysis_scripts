%%Quick dF/F0 and plot for cells in excel spreadsheet or txt file
%import spreadsheet as a matrix
%this version should be used if multiple arrays are in a single column
    %(such as output from ImageJ). 
    
%%

[data,dataName] = uigetvariables('Choose data variable');%chooses variable
data = data{1,1};%converts from a cell format to original format of the variable. 

%prompt for # of ROIs
prompt = {'Number of Frames:','Baseline Start:','Baseline Stop:','Frame Rate (Hz)'};
dlg_title = 'Input variables';
num_lines = 1;
defaultans = {'4096','1000','1499','500'};
InputVars = str2double(inputdlg(prompt,dlg_title,num_lines,defaultans));

%pull out input variables
Frames = InputVars(1,1);
BaseStrt = InputVars(2,1);
BaseStop = InputVars(3,1); 
FRate = InputVars(4,1);

%%
%separate ROIs 
Fless1 = Frames - 1;
All_Raw = [];
for kk = 1:Frames:length(data);
    starts = data(kk:kk+Fless1,:);
    All_Raw = horzcat(All_Raw,starts);
end

%%
%Convert to dF/F0
Baseline = mean(All_Raw(BaseStrt:BaseStop,:));

for i = 1:length(Baseline)
    All_dF(:,i) = minus(All_Raw(:,i),Baseline(1,i));
end

for j = 1:length(Baseline)
    All_dFoverF0(:,j) = All_dF(:,j)./Baseline(1,j);
end

%%
%Plot
t = 0:1/FRate:length(All_dFoverF0)/FRate;
t = t(:,2:end)';
figure
h = plot(t,All_dFoverF0);
%set(h,{'DisplayName'},{'Whole FOV';'High Res ROI';'Thresh 50%';'Thresh 75%'})
xlabel('Time (s)');
ylabel('\DeltaF/F_0');

%%
clear All_dF Data i All_Raw AneuronROItraces data dataName defaultans dlg_title Fless1 Frames InputVars j kk num_lines prompt starts Baseline h