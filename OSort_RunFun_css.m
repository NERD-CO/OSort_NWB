function [trialLog] = OSort_RunFun_css(inargs)


arguments

    inargs.basePath (1,1) string = "I:\01_Coding_Datasets\OSort_TEST\EVENTs\testNLX\"
    inargs.patientID (1,1) string = 'MW_1'
    inargs.chann (1,:) double = 257:264
    inargs.sub (1,1) string = '1'
    inargs.sess (1,1) string = "1"
    inargs.wireType (1,1) string = "macro"
    inargs.Epoch (1,1) double = 1
    inargs.defaultAlignM (1,1) double = 3
    inargs.nwbFILE (1,1) string = 'MW1_Session_2_filter.nwb'

end


% which files to sort
paths = [];

% paths.basePath='J:\01_Coding_Datasets\LossAVERSION_Figure\AMC_PY21NO03\Behavioral Session 2\';
paths.basePath = char(inargs.basePath);
paths.pathOut = [paths.basePath , 'sort\'];
paths.pathRaw = [paths.basePath 'rawDemo\'];
paths.pathFigs = [paths.basePath 'figs\'];
paths.pathNWB = [paths.basePath 'nwb\'];
% if a timestampsInclude.txt file is found in this directory, 
% only the range(s) of timestamps specified will be processed.
paths.timestampspath = paths.basePath;        

paths.patientID = inargs.patientID; % label in plots

filesToProcess = inargs.chann;  %which channels to detect/sort

noiseChannels = [   ]; % which channels to ignore
groundChannels = [];

doGroundNormalization = 0;
normalizeOnly = []; %which channels to use for normalization

% if exist('groundChannels','var') && ~doGroundNormalization
%     filesToProcess = setdiff(filesToProcess, groundChannels);
% end

% default align is mixed, unless listed below as max or min.



%% global settings
paramsIn = [];

paramsIn.rawFilePrefix = 'CSC';        % some systems use CSC instead of A
paramsIn.processedFilePrefix = 'A';
paramsIn.NWB2process = inargs.nwbFILE;

paramsIn.rawFileVersion = 6; % see defineFileFormat.m for options
paramsIn.samplingFreq = 0; %only used if rawFileVersion==3

%which tasks to execute
paramsIn.tillBlocks = 999;  %how many blocks to process (each ~20s). 0=no limit.
paramsIn.doDetection = 1;
paramsIn.doSorting = 1;
paramsIn.doFigures = 1;
paramsIn.noProjectionTest = 1;
paramsIn.doRawGraphs = 1;
paramsIn.doshortRawGraphs = 1; %zoomed-in raw graphs
paramsIn.doGroundNormalization = doGroundNormalization;

paramsIn.displayFigures = 0 ;  %1 yes (keep open), 0 no (export and close immediately); for production use, use 0

paramsIn.minNrSpikes = 50; %min nr spikes assigned to a cluster for it to be valid

%params
paramsIn.blockNrRawFig = [ 1 2 100 110];   % for which block will a raw figure be made
paramsIn.outputFormat = 'png';
paramsIn.thresholdMethod = 1; %1=approx, 2=exact
paramsIn.prewhiten = 0; %0=no, 1=yes,whiten raw signal (dont)
paramsIn.defaultAlignMethod = inargs.defaultAlignM;  %only used if peak finding method is "findPeak". 1=max, 2=min, 3=mixed %%%%%% % first min and then max
paramsIn.peakAlignMethod = 1; %1 find Peak, 2 none, 3 peak of power, 4 MTEO peak                         %%%%%%

switch paramsIn.defaultAlignMethod
    case 1
        alignStr = 'max';
        filesAlignMax = inargs.chann;
        filesAlignMin = [ ];

    case 2
        alignStr = 'min';
        filesAlignMax = [ ];
        filesAlignMin =  inargs.chann;

    case 3
        alignStr = 'mixed';
        filesAlignMax = [ ];
        filesAlignMin = [ ];

end

%for wavelet detection method
%paramsIn.detectionMethod=5; %1 power, 2 T pos, 3 T min, 4 T abs, 5 wavelet
%dp.scalesRange = [0.2 1.0]; %in ms
%dp.waveletName='bior1.5';
%paramsIn.detectionParams=dp;
%extractionThreshold=0.1; %for wavelet method

%for power detection method
paramsIn.detectionMethod = 1; %1 power, 2 T pos, 3 T min, 4 T abs, 5 wavelet & USE 4 %%%%%%
dp.kernelSize = 18;
paramsIn.detectionParams = dp;
extractionThreshold = 5;  % extraction threshold
if paramsIn.doGroundNormalization == 1 % Separate identifiers for ground normalization
    extractionThreshold = extractionThreshold + 0.003;
end

%automatically adjust threshold to indicate min/max
if isequal(filesToProcess,filesAlignMax) && isempty(filesAlignMin)
    extractionThreshold=extractionThreshold+0.001;
end
if isequal(filesToProcess,filesAlignMin) && length(filesAlignMax)==0
    extractionThreshold=extractionThreshold+0.002;
end

thres = [repmat(extractionThreshold, 1, length(filesToProcess))];

% execute
[normalizationChannels,paramsIn,filesToProcess] = StandaloneGUI_prepare(noiseChannels,... % new
    doGroundNormalization,paramsIn,filesToProcess,filesAlignMax,...
    filesAlignMin, normalizeOnly, groundChannels);

% Run Standalone gui

StandaloneGUI_css(paths, filesToProcess, thres, normalizationChannels, paramsIn);
trialLog = sprintf('COMPLETE: %s (var%d) [%s]',inargs.patientID,alignStr);


end
