
% IMPORT TEXT FILE WITH WAVEFORMS, NAME "spikewaveforms"
% IMPORT TEXT FILE WITH DIRECTION SELECTIVITY MEASUREMENTS, NAME "DS"
% IMPORT BOTH AS NUMERICAL MATRIX

% Inspect plot of all waveforms
spikeformsTranspose = spikewaveforms';
figNum = 1;
figure(figNum);
plot(spikeformsTranspose);
ylim([-8000 8000]);
title('Waveforms all units (n=26862)');
xlabel('1/30000 sec');
ylabel('mV');

Rows = size(spikewaveforms,1);
Cols = size(spikewaveforms, 2);
nans = 0;
nanList = [];
zeroList = [];
numZeros = 0;

tic
parfor i = 1:Rows
    for j = 1:Cols
        curr = spikewaveforms(i, j);
        NotNum = isnan(curr);
        if NotNum == 1
            nans = nans + 1;
            nanList = vertcat(nanList,spikewaveforms(i, j));
        end
        if curr == 0
            numZeros = numZeros + 1;
            zeroList = vertcat(zeroList,spikewaveforms(i, j));
        end
    end
end
toc

% check for existing zeros in DS
Zeros = [];
dsLen = size(DS,1);

tic
parfor i = 1:dsLen
    curr = DS(i,1);
    if curr == 0;
        Zeros = vertcat(Zeros,i);
    end
end
toc

% Convert all NaN's to 0
tic
parfor i = 1:dsLen
    curr = DS(i,1);
    notNum = isnan(curr);
    if notNum == 1
        DS(i,1) = 0;
    end
end
toc

% find MAX, MIN and AUC for each waveform
maxAll = zeros(Rows,1);
minAll = zeros(Rows,1);
aucAll = zeros(Rows,1);
onUnits = [];
offUnits = [];

tic
for i = 1:Rows
    currMax = max(spikewaveforms(i,:));
    maxAll(i,1) = currMax;
    currMin = min(spikewaveforms(i,:));
    minAll(i,1) = currMin;
    currAUC = trapz(spikewaveforms(i,:));
    aucAll(i,1) = currAUC;
    if currMax > abs(currMin)
        temp = horzcat(i,currMax);
        onUnits = vertcat(onUnits,i);
    else
        temp = horzcat(i,currMin);
        offUnits = vertcat(offUnits,i);
    end
end
toc


%Look at timepoints 10-40 to focus on peristimulus activity
maxTen40 = zeros(Rows,1);
maxTen40Idx = zeros(Rows,1);
minTen40 = zeros(Rows,1);
minTen40 = zeros(Rows,1);
onUnitsTen40 = [];
offUnitsTen40 = [];


tic
for i = 1:Rows
    [currMax, I] = max(spikewaveforms(i,10:40));
    maxTen40(i,1) = currMax; 
    maxTen40(i,1) = I;
    [currMin, I] = min(spikewaveforms(i,10:40));
    minTen40(i,1) = currMin;
    minTen40(i,1) = I;
    if currMax > abs(currMin)
        temp = horzcat(i,currMax);
        onUnitsTen40 = vertcat(onUnitsTen40,i);
    else
        temp = horzcat(i,currMin);
        offUnitsTen40 = vertcat(offUnitsTen40,i);
    end
end
toc


%Look at 10-END, sort ON and OFF units
maxTenEnd = zeros(Rows,1);
minTenEnd = zeros(Rows,1);
onUnitsTenEnd = [];
offUnitsTenEnd = [];

tic
for i = 1:Rows
    currMax = max(spikewaveforms(i,10:end));
    maxTenEnd(i,1) = currMax; 
    currMin = min(spikewaveforms(i,10:end));
    minTenEnd(i,1) = currMin;
    
    if currMax > abs(currMin) 
        temp = horzcat(i,currMax);
        onUnitsTenEnd = vertcat(onUnitsTenEnd,i);
    
    elseif maxTen40(i,1) > 1000 
        if minTen40(i,1) < 25 || minTen40(i,1) > 45
            if MinTen40(i,1) < -100
                temp = horzcat(i,currMax);
                onUnitsTenEnd = vertcat(onUnitsTenEnd,i);
            end
        end
    
    else
        temp = horzcat(i,currMin);
        offUnitsTenEnd = vertcat(offUnitsTenEnd,i);
    end
end
toc

% lenOnTenEnd = size(onUnitsTenEnd);
% lenOffTenEnd = size(offUnitsTenEnd);
% figNum = figNum+1;
% figure(figNum)
% hold on
% 
% tic
% for i = 1:lenOnTenEnd
%     idx = onUnitsTenEnd(i,1);
%     temp = spikewaveforms(idx,:);
%     plot(temp);
% end
% toc
% 
% ylim([-8000 8000])
% title('Waveforms ON units')
% hold off
% 
% figNum = figNum + 1;
% figure(figNum)
% hold on
% 
% tic
% for i = 1:lenOffTenEnd
%     idx = offUnitsTenEnd(i,1);
%     temp = spikewaveforms(idx,:);
%     plot(temp);
% end
% toc


%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%
% Perform hierarchical clustering, ward
numClusters = 8; % You can change this to the desired number of clusters
Z = linkage(spikewaveforms, 'ward'); % 'ward' is a common method, you can also use 'average', 'single', etc.


% Cluster assignment
idx8C = cluster(Z, 'MaxClust', numClusters);


% Perform PCA for dimensionality reduction
[coeff8C, score8C, ~] = pca(spikewaveforms);


% Plot the first two principal components with cluster coloring
figNum = figNum+1;
figure(figNum);
gscatter(score8C(:,1), score8C(:,2), idx8C);
title('Hierarchical(ward) Clustering Visualization with PCA');
xlabel('Principal Component 1');
ylabel('Principal Component 2');
legend('Cluster 1', 'Cluster 2', 'Cluster 3', 'Cluster 4', 'Cluster 5', 'Cluster 6', 'Cluster 7', 'Cluster 8'); % Adjust if numClusters is different
grid on;



%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%
% kmeans clustering 8 clusters
numClusters = 8; % You can change this to the desired number of clusters

% Perform k-means clustering
[idx8K, centroids8K] = kmeans(spikewaveforms, numClusters, 'MaxIter', 1000, 'Replicates', 10);

% Perform PCA for dimensionality reduction
[coeff8K, score8K, ~] = pca(spikewaveforms);

% Plot the first two principal components with cluster coloring
figNum = figNum+1;
figure(figNum);
gscatter(score8K(:,1), score8K(:,2), idx8K);
title('K-means Clustering Visualization with PCA');
xlabel('Principal Component 1');
ylabel('Principal Component 2');
legend('Cluster 1', 'Cluster 2', 'Cluster 3', 'Cluster 4', 'Cluster 5', 'Cluster 6', 'Cluster 7', 'Cluster 8'); % Adjust if numClusters is different
grid on;


% Plot Kmeans cluster waveforms separately
kClust1 = [];
kClust2 = [];
kClust3 = [];
kClust4 = [];
kClust5 = [];
kClust6 = [];
kClust7 = [];
kClust8 = [];

tic
for i = 1:Rows
    if idx8K(i,1) == 1 
        tempRow = horzcat(i,minAll(i,1),maxAll(i,1),aucAll(i,1),DS(i,1));
        kClust1 = vertcat(kClust1,tempRow);
    elseif idx8K(i,1) == 2
        tempRow = horzcat(i,minAll(i,1),maxAll(i,1),aucAll(i,1),DS(i,1));
        kClust2 = vertcat(kClust2,tempRow);
    elseif idx8K(i,1) == 3
        tempRow = horzcat(i,minAll(i,1),maxAll(i,1),aucAll(i,1),DS(i,1));
        kClust3 = vertcat(kClust3,tempRow);
    elseif idx8K(i,1) == 4
        tempRow = horzcat(i,minAll(i,1),maxAll(i,1),aucAll(i,1),DS(i,1));
        kClust4 = vertcat(kClust4,tempRow);
    elseif idx8K(i,1) == 5
        tempRow = horzcat(i,minAll(i,1),maxAll(i,1),aucAll(i,1),DS(i,1));
        kClust5 = vertcat(kClust5,tempRow);
    elseif idx8K(i,1) == 6
        tempRow = horzcat(i,minAll(i,1),maxAll(i,1),aucAll(i,1),DS(i,1));
        kClust6 = vertcat(kClust6,tempRow);
    elseif idx8K(i,1) == 7
        tempRow = horzcat(i,minAll(i,1),maxAll(i,1),aucAll(i,1),DS(i,1));
        kClust7 = vertcat(kClust7,tempRow);
    elseif idx8K(i,1) == 8
        tempRow = horzcat(i,minAll(i,1),maxAll(i,1),aucAll(i,1),DS(i,1));
        kClust8 = vertcat(kClust8,tempRow);
    end
end
toc

len = size(kClust1,1);
figNum = figNum+1;
figure(figNum);
nexttile;
hold on

tic
for i = 1:len
    idx = kClust1(i,1);
    temp = spikewaveforms(idx,:);
    plot(spikewaveforms(idx,:));
end
toc

ylim([-8000 8000]);
tempLen = size(kClust1,1);
STR = string(tempLen);
title('Kmeans cluster 1 (n= ' + STR + ')');
xlabel('1/30000 sec');
ylabel('mV');
hold off


len = size(kClust2,1);
nexttile;
hold on

tic
for i = 1:len
    idx = kClust2(i,1);
    temp = spikewaveforms(idx,:);
    plot(spikewaveforms(idx,:));
end
toc

ylim([-8000 8000]);
tempLen = size(kClust2,1);
STR = string(tempLen);
title('Kmeans cluster 2 (n= ' + STR + ')');
xlabel('1/30000 sec');
ylabel('mV');
hold off


len = size(kClust3,1);
nexttile;
hold on


tic
for i = 1:len
    idx = kClust3(i,1);
    temp = spikewaveforms(idx,:);
    plot(spikewaveforms(idx,:));
end
toc

ylim([-8000 8000]);
tempLen = size(kClust3,1);
STR = string(tempLen);
title('Kmeans cluster 3 (n= ' + STR + ')');
xlabel('1/30000 sec');
ylabel('mV');
hold off

len = size(kClust4,1);
nexttile;
hold on


tic
for i = 1:len
    idx = kClust4(i,1);
    temp = spikewaveforms(idx,:);
    plot(spikewaveforms(idx,:));
end
toc

ylim([-8000 8000]);
tempLen = size(kClust4,1);
STR = string(tempLen);
title('Kmeans cluster 4 (n= ' + STR + ')');
xlabel('1/30000 sec');
ylabel('mV');
hold off


len = size(kClust5,1);
nexttile;
hold on


tic
for i = 1:len
    idx = kClust5(i,1);
    temp = spikewaveforms(idx,:);
    plot(spikewaveforms(idx,:));
end
toc

ylim([-8000 8000]);
tempLen = size(kClust5,1);
STR = string(tempLen);
title('Kmeans cluster 5 (n= ' + STR + ')');
xlabel('1/30000 sec');
ylabel('mV');
hold off

len = size(kClust6,1);
nexttile;
hold on

tic
for i = 1:len
    idx = kClust6(i,1);
    temp = spikewaveforms(idx,:);
    plot(spikewaveforms(idx,:));
end
toc

ylim([-8000 8000]);
tempLen = size(kClust6,1);
STR = string(tempLen);
title('Kmeans cluster 6 (n= ' + STR + ')');
xlabel('1/30000 sec');
ylabel('mV');
hold off

len = size(kClust7,1);
nexttile;
hold on

tic
for i = 1:len
    idx = kClust7(i,1);
    temp = spikewaveforms(idx,:);
    plot(spikewaveforms(idx,:));
end
toc

ylim([-8000 8000]);
tempLen = size(kClust7,1);
STR = string(tempLen);
title('Kmeans cluster 7 (n= ' + STR + ')');
xlabel('1/30000 sec');
ylabel('mV');
hold off

len = size(kClust8,1);
nexttile;
hold on

tic
for i = 1:len
    idx = kClust8(i,1);
    temp = spikewaveforms(idx,:);
    plot(spikewaveforms(idx,:));
end
toc

ylim([-8000 8000]);
tempLen = size(kClust8,1);
STR = string(tempLen);
title('Kmeans cluster 8 (n= ' + STR + ')');
xlabel('1/30000 sec');
ylabel('mV');
hold off




% Plot C cluster waveforms separately
cClust1 = [];
cClust2 = [];
cClust3 = [];
cClust4 = [];
cClust5 = [];
cClust6 = [];
cClust7 = [];
cClust8 = [];

tic
parfor i = 1:Rows
    if idx8C(i,1) == 1 
        tempRow = horzcat(i,minAll(i,1),maxAll(i,1),aucAll(i,1),DS(i,1));
        cClust1 = vertcat(cClust1,tempRow);
    elseif idx8C(i,1) == 2
        tempRow = horzcat(i,minAll(i,1),maxAll(i,1),aucAll(i,1),DS(i,1));
        cClust2 = vertcat(cClust2,tempRow);
    elseif idx8C(i,1) == 3
        tempRow = horzcat(i,minAll(i,1),maxAll(i,1),aucAll(i,1),DS(i,1));
        cClust3 = vertcat(cClust3,tempRow);
    elseif idx8C(i,1) == 4
        tempRow = horzcat(i,minAll(i,1),maxAll(i,1),aucAll(i,1),DS(i,1));
        cClust4 = vertcat(cClust4,tempRow);
    elseif idx8C(i,1) == 5
        tempRow = horzcat(i,minAll(i,1),maxAll(i,1),aucAll(i,1),DS(i,1));
        cClust5 = vertcat(cClust5,tempRow);
    elseif idx8C(i,1) == 6
        tempRow = horzcat(i,minAll(i,1),maxAll(i,1),aucAll(i,1),DS(i,1));
        cClust6 = vertcat(cClust6,tempRow);
    elseif idx8C(i,1) == 7
        tempRow = horzcat(i,minAll(i,1),maxAll(i,1),aucAll(i,1),DS(i,1));
        cClust7 = vertcat(cClust7,tempRow);;
    elseif idx8C(i,1) == 8
        tempRow = horzcat(i,minAll(i,1),maxAll(i,1),aucAll(i,1),DS(i,1));
        cClust8 = vertcat(cClust8,tempRow);
    end
end
toc

len = size(cClust1,1);
figNum = figNum+1;
figure(figNum);
nexttile;
hold on

tic
for i = 1:len
    idx = cClust1(i,1);
    temp = spikewaveforms(idx,:);
    plot(spikewaveforms(idx,:));
end
toc

ylim([-8000 8000]);
tempLen = size(cClust1,1);
STR = string(tempLen);
title('H cluster 1 (n= ' + STR + ')');
xlabel('1/30000 sec');
ylabel('mV');
hold off


len = size(cClust2,1);
nexttile;
hold on

tic
for i = 1:len
    idx = cClust2(i,1);
    temp = spikewaveforms(idx,:);
    plot(spikewaveforms(idx,:));
end
toc

ylim([-8000 8000]);
tempLen = size(cClust2,1);
STR = string(tempLen);
title('H cluster 2 (n= ' + STR + ')');
xlabel('1/30000 sec');
ylabel('mV');
hold off


len = size(cClust3,1);
nexttile;
hold on

tic
for i = 1:len
    idx = cClust3(i,1);
    temp = spikewaveforms(idx,:);
    plot(spikewaveforms(idx,:));
end
toc

ylim([-8000 8000]);
tempLen = size(cClust3,1);
STR = string(tempLen);
title('H cluster 3 (n= ' + STR + ')');
xlabel('1/30000 sec');
ylabel('mV');
hold off

len = size(cClust4,1);
nexttile;
hold on

tic
for i = 1:len
    idx = cClust4(i,1);
    temp = spikewaveforms(idx,:);
    plot(spikewaveforms(idx,:));
end
toc

ylim([-8000 8000]);
tempLen = size(cClust4,1);
STR = string(tempLen);
title('H cluster 4 (n= ' + STR + ')');
xlabel('1/30000 sec');
ylabel('mV');
hold off

len = size(cClust5,1);
nexttile;
hold on

tic
for i = 1:len
    idx = cClust5(i,1);
    temp = spikewaveforms(idx,:);
    plot(spikewaveforms(idx,:));
end
toc

ylim([-8000 8000]);
tempLen = size(cClust5,1);
STR = string(tempLen);
title('H cluster 5 (n= ' + STR + ')');
xlabel('1/30000 sec');
ylabel('mV');
hold off

len = size(cClust6,1);
nexttile;
hold on

tic
for i = 1:len
    idx = cClust6(i,1);
    temp = spikewaveforms(idx,:);
    plot(spikewaveforms(idx,:));
end
toc

ylim([-8000 8000]);
tempLen = size(cClust6,1);
STR = string(tempLen);
title('H cluster 6 (n= ' + STR + ')');
xlabel('1/30000 sec');
ylabel('mV');
hold off

len = size(cClust7,1);
nexttile;
hold on

tic
for i = 1:len
    idx = cClust7(i,1);
    temp = spikewaveforms(idx,:);
    plot(spikewaveforms(idx,:));
end
toc

ylim([-8000 8000]);
tempLen = size(cClust7,1);
STR = string(tempLen);
title('H cluster 7 (n= ' + STR + ')');
xlabel('1/30000 sec');
ylabel('mV');
hold off

len = size(cClust8,1);
nexttile;
hold on

tic
for i = 1:len
    idx = cClust8(i,1);
    temp = spikewaveforms(idx,:);
    plot(spikewaveforms(idx,:));
end
toc

ylim([-8000 8000]);
tempLen = size(cClust8,1);
STR = string(tempLen);
title('H cluster 8 (n= ' + STR + ')');
xlabel('1/30000 sec');
ylabel('mV');
hold off
        


% Calculate unit attributes: MAX, MIN, AUC 

allIndices = (1:Rows)';
allAttributes = horzcat(allIndices, minAll, maxAll, aucAll, DS);
AllAttributesKmeans = horzcat(allAttributes,idx8K);
AllAttributesHierarchical = horzcat(allAttributes,idx8C);

AllAttributesKmeansLog = log10(AllAttributesKmeans);

minTenEnd_abs = abs(minTenEnd);
minLog = log10(minTenEnd_abs);


%Scatter plots

figNum = figNum+1;
figure(figNum);
scatter(AllAttributesKmeans(:,2),AllAttributesKmeans(:,4));
md1 = fitlm(AllAttributesKmeans(:,2),AllAttributesKmeans(:,4));
plot(md1);
title('Min Amplitude vs AUC');
xlabel('minAmplitude (mV)');
ylabel('AUC');

figNum = figNum+1;
figure(figNum);
scatter(AllAttributesKmeans(:,3),AllAttributesKmeans(:,4));
md1 = fitlm(AllAttributesKmeans(:,3),AllAttributesKmeans(:,4));
plot(md1);
title('Max Amplitude vs AUC');
xlabel('maxAmplitude (mV)');
ylabel('AUC');

figNum = figNum+1;
figure(figNum);
scatter(minLog,AllAttributesKmeansLog(:,4));
title('log(Min Amplitude) vs log(AUC)')
xlabel('log(minAmplitude) (mV)');
ylabel('log(AUC)');

figNum = figNum+1;
figure(figNum);
scatter(AllAttributesKmeansLog(:,3),AllAttributesKmeansLog(:,4));
title('log(Max Amplitude) vs log(AUC)');
xlabel('log(maxAmplitude) (mV)');
ylabel('log(AUC)');


figNum = figNum+1;
figure(figNum);
scatter(AllAttributesKmeansLog(:,2),AllAttributesKmeansLog(:,3));
title('log(Min Amplitude) vs log(Max Amplitude)');
xlabel('log(minAmplitude) (mV)');
ylabel('log(maxAmplitude) (mV)');






