%create variable for sequestered data. Adjust two numbers to fit trace

b = v1(15:40,:);

%%
%find area under the curve (AUC)
t_short = 1/Fs:1/Fs:size(b,1)/Fs;%create a time variable same length as data
AUC_short = trapz(t_short,b);

tAUCs = AUC_short.';%transcribe data for export to excel

%%
%greatest amplitude within selected data
%t_short = 1/Fs:1/Fs:size(b,1)/Fs;
%Amp_short = tAmp_All(t_short,b);