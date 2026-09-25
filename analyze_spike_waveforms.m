%% Concise spike-waveform analysis
% Place this script beside spike_waveforms.txt and DS.txt, then run it.

clear; close all; clc

scriptDir = fileparts(mfilename('fullpath'));
waveformFile = fullfile(scriptDir, 'spike_waveforms.txt');
dsFile = fullfile(scriptDir, 'DS.txt');
numClusters = 8;
rng default                        % Reproducible k-means initialization

%% Load and validate data
spikewaveforms = readmatrix(waveformFile, 'FileType', 'text');
[Rows, Cols] = size(spikewaveforms);
assert(Cols >= 40, 'Each waveform must contain at least 40 samples.');

if isfile(dsFile)
    DS = readmatrix(dsFile);
    DS = DS(:,1);
    assert(numel(DS) == Rows, 'DS must have one value per waveform.');
    DS(isnan(DS)) = 0;
else
    DS = nan(Rows,1);               % DS was not included with the data
end

% Data-quality information (lists contain linear indices into the matrix).
nanList = find(isnan(spikewaveforms));
zeroList = find(spikewaveforms == 0);
nans = numel(nanList);
numZeros = numel(zeroList);
Zeros = find(DS == 0);

if nans > 0
    error('Waveform data contain %d NaN values; clean them before clustering.', nans);
end

%% Plot every waveform
figure;
plot(spikewaveforms.');
ylim([-8000 8000]);
title(sprintf('Waveforms all units (n=%d)', Rows));
xlabel('Sample (1/30000 s)'); ylabel('mV');

%% Waveform attributes and ON/OFF classifications
maxAll = max(spikewaveforms, [], 2);
minAll = min(spikewaveforms, [], 2);
aucAll = trapz(spikewaveforms, 2);
onUnits = find(maxAll > abs(minAll));
offUnits = find(maxAll <= abs(minAll));

[maxTen40, maxTen40Idx] = max(spikewaveforms(:,10:40), [], 2);
[minTen40, minTen40Idx] = min(spikewaveforms(:,10:40), [], 2);
maxTen40Idx = maxTen40Idx + 9;      % Convert to full-waveform indices
minTen40Idx = minTen40Idx + 9;
onUnitsTen40 = find(maxTen40 > abs(minTen40));
offUnitsTen40 = find(maxTen40 <= abs(minTen40));

maxTenEnd = max(spikewaveforms(:,10:end), [], 2);
minTenEnd = min(spikewaveforms(:,10:end), [], 2);
onMaskTenEnd = maxTenEnd > abs(minTenEnd);

% Preserve the apparent intent of the original special-case rule while
% using the correct values and indices.
specialOn = maxTen40 > 1000 & ...
            (minTen40Idx < 25 | minTen40Idx > 45) & minTen40 < -100;
onUnitsTenEnd = find(onMaskTenEnd | specialOn);
offUnitsTenEnd = find(~(onMaskTenEnd | specialOn));

%% Hierarchical and k-means clustering, visualized with one PCA calculation
Z = linkage(spikewaveforms, 'ward');
idx8C = cluster(Z, 'MaxClust', numClusters);
[idx8K, centroids8K] = kmeans(spikewaveforms, numClusters, ...
    'MaxIter', 1000, 'Replicates', 10);
[coeff, score, latent] = pca(spikewaveforms);

plotPCA(score, idx8C, 'Hierarchical (Ward) clustering with PCA');
plotPCA(score, idx8K, 'K-means clustering with PCA');
plotClusterWaveforms(spikewaveforms, idx8K, numClusters, 'K-means');
plotClusterWaveforms(spikewaveforms, idx8C, numClusters, 'Hierarchical');

%% Attribute tables (equivalent information without eight separate arrays)
unit = (1:Rows).';
baseAttributes = table(unit, minAll, maxAll, aucAll, DS);
AllAttributesKmeans = addvars(baseAttributes, idx8K, ...
    'NewVariableNames', 'Cluster');
AllAttributesHierarchical = addvars(baseAttributes, idx8C, ...
    'NewVariableNames', 'Cluster');
kClusters = arrayfun(@(c) AllAttributesKmeans(idx8K == c,:), ...
    (1:numClusters).', 'UniformOutput', false);
cClusters = arrayfun(@(c) AllAttributesHierarchical(idx8C == c,:), ...
    (1:numClusters).', 'UniformOutput', false);

%% Attribute scatterplots
plotFit(minAll, aucAll, 'Min amplitude vs AUC', 'Min amplitude (mV)', 'AUC');
plotFit(maxAll, aucAll, 'Max amplitude vs AUC', 'Max amplitude (mV)', 'AUC');

% Use log10(abs(.)) and omit zeros. The original log10 of negative values
% produces complex numbers, which are unsuitable for these scatterplots.
plotLog(abs(minTenEnd), abs(aucAll), 'log(Min amplitude) vs log(AUC)', ...
    'log_{10}|min amplitude|', 'log_{10}|AUC|');
plotLog(abs(maxAll), abs(aucAll), 'log(Max amplitude) vs log(AUC)', ...
    'log_{10}|max amplitude|', 'log_{10}|AUC|');
plotLog(abs(minAll), abs(maxAll), 'log(Min amplitude) vs log(Max amplitude)', ...
    'log_{10}|min amplitude|', 'log_{10}|max amplitude|');

fprintf(['Analyzed %d waveforms x %d samples. NaNs: %d; zeros: %d. ' ...
         'Created %d clusters with each method.\n'], ...
         Rows, Cols, nans, numZeros, numClusters);

%% Local plotting functions
function plotPCA(score, groups, plotTitle)
    figure;
    gscatter(score(:,1), score(:,2), groups);
    title(plotTitle); xlabel('Principal component 1');
    ylabel('Principal component 2'); grid on
end

function plotClusterWaveforms(waveforms, groups, nClusters, method)
    figure;
    tiledlayout(ceil(nClusters/2), 2, 'TileSpacing', 'compact');
    for c = 1:nClusters
        nexttile;
        members = groups == c;
        plot(waveforms(members,:).');
        ylim([-8000 8000]);
        title(sprintf('%s cluster %d (n=%d)', method, c, nnz(members)));
        xlabel('Sample (1/30000 s)'); ylabel('mV');
    end
end

function plotFit(x, y, plotTitle, xLabel, yLabel)
    figure;
    scatter(x, y, 8, 'filled'); hold on
    model = fitlm(x, y);
    plot(model); hold off
    title(plotTitle); xlabel(xLabel); ylabel(yLabel);
end

function plotLog(x, y, plotTitle, xLabel, yLabel)
    keep = isfinite(x) & isfinite(y) & x > 0 & y > 0;
    figure;
    scatter(log10(x(keep)), log10(y(keep)), 8, 'filled');
    title(plotTitle); xlabel(xLabel); ylabel(yLabel);
end
