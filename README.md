# MATLAB Neuroscience Analysis Scripts

A collection of MATLAB scripts developed for experimental neuroscience analyses, including cortical spreading depolarization (CSD), GluSnFR fluorescence, pattern electroretinography (pERG), visual evoked potentials (VEP), and neuronal spike waveforms.

These are experiment-specific analysis scripts, not a single automated pipeline. Many expect data already imported into the MATLAB workspace and parameters such as frame rate, event onset, or analysis windows to be set for a particular recording.

## Find an analysis

| Area | Starting points | What the scripts examine |
| --- | --- | --- |
| CSD and GluSnFR | [`GluSnFR_CSD_analysis_current.m`](GluSnFR_CSD_analysis_current.m), [`CSD_measurements_script.m`](CSD_measurements_script.m), [`latest_Glusnfr_analysis.m`](latest_Glusnfr_analysis.m) | Fluorescence changes, event timing, peak response, duration, and area under the response curve |
| pERG and VEP | [`pERG_VEP_analysis_NEW.m`](pERG_VEP_analysis_NEW.m), [`pERG_4groups_latest.m`](pERG_4groups_latest.m) | Evoked-response waveforms, amplitudes, and timing across recordings or groups |
| Spike waveforms | [`analyze_spike_waveforms.m`](analyze_spike_waveforms.m), [`neuroPixels_crossCorr_night.m`](neuroPixels_crossCorr_night.m) | Waveform attributes, clustering, and cross-correlation analyses |
| Fluorescence and AUC utilities | [`GluSnFR_dFoF.m`](GluSnFR_dFoF.m), [`dFoverF0_from_spreadsheet_v5.m`](dFoverF0_from_spreadsheet_v5.m), `AUC_*.m` | Normalization and response-area calculations |

Several dated, `Dev`, `Test`, and numbered files record iterations of an analysis. The names above are navigation points, not a claim that every script accepts the same inputs or reproduces a final figure unchanged.

## How to use a script

1. Open the relevant `.m` file in MATLAB and read its initial comments and data-import lines.
2. Supply the expected input file or workspace variable. For example, `CSD_measurements_script.m` refers to an imported `RawData` variable, and `GluSnFR_CSD_analysis_current.m` expects a `data` array.
3. Set the recording-specific parameters in the script, including frame rate and analysis window.
4. Run it on an appropriate recording and inspect the plots and generated variables.

Input recordings and a unified environment are not included here. MATLAB and any functions or toolboxes called by the chosen script are required. Validate units, baseline selection, and event boundaries against your experiment before interpreting results.

## Related repository

For a more focused MATLAB and Python waveform-clustering project with example figures, see [MATLAB_neuropixels_clustering](https://github.com/mouse577/MATLAB_neuropixels_clustering).
