%
% takes sorting result from excel file and defines usable clusters automatically
%
%
% requires three columns in the excel file: channelNr, threshold, clustersToUse
% channelNr and threshold have to be type numeric
% clustersToUse has to be type text. it is a list of clusters to use, with merges indicated by '+'
% Examples: 128,130,150     (use 3 clusters)
%           128+130,150     (use 2 clusters, merge 128+130)
%
%
% 
%urut/april14

%% ==== define all parameters to process a new session
% clear; clc;

% - Sorting Parameters
basepath='Z:\dataRawConsortium\'; %\\csclvault\RutishauserULab\dataRawEpilepsy\
sortDir='\sort\';
figsDir='\figs\';
finalDir='\final\';
Area = 'A'; % A for AIP, B for BA5

% - Patient Parameters
patientID = 'AMC_PY22NO12\'; % should be the same as the folder
taskStr='NO\var3\'; %NO (i.e., 'NO\var1\') 

% - Excel Parameters
xlsFile=[basepath '\AMC_PY22NO12\NO\var3\AMC_PY22NO12_v3_cells.xlsx']; %path to XLS file 
sheet = 'Sheet1';  % which worksheet has this session
range=[11:18]; % which rows in this worksheet contain all channels to be used (11:90 = Cedars) 
columnChannel=3;
columnThresh=5; 
columnClusterNumbers=6;

% NOTE: code below will reference the  following paths
% basepath\patientID\sortDir --> current location of cells and sorted_new mat-files for all clusters
% basepath\patientID\figsDir --> current location of png files for all clusters
% basepath\patientID\sortDir\final --> where mat files for selected clusters ONLY will be stored
% basepath\patientID\figsDir\final --> where png files for selected clusters ONLY will be stored

%**************************************************************************
% =========== Cedars-Sinai Brain Mapping =================================
% 'mapping' Format: [start1 end1 mapNo1; ... ... ... ; startN endN mapNoN]
% 1=RH, 2=LH, 3=RA, 4=LA, 5=RAC, 6=LAC, 7=RSMA, 8=LSMA, 9=RPT, 10=LPT, 
% 11=ROFC, 12=LOFC, 50 = RFFA , 51 = REC 


mapping = [257 264 4];
% mapping = [ 257 264 4;...
%             265 272 13;...
%             ];



% mapping = [129 136 11; 137 144 5; 145 152 7; 153 160 3; 169 176 50; 177 184 51; 185 192 1]; %P62CS

% mapping = [ 129 136 6; 137 144 8; 145 152 4; 153 160 2; 161 168 5; 169 176 7; ... 
     %177 184 3; 185 192 1; 193 200 12; 201 208 11]; %P61CS
%mapping=[ 129 136 6; 137 144 8; 145 152 4; 153 160 2; 161 168 5; 169 176 7; 177 184 3; 185 192 1; 193 200 12; 201 208 11]; %P60CS

%mapping=[ 1 40 2; 41 80 1 ];
%mapping=[ 1 8 6; 9 16 8; 17 24 4; 25 32 2; 33 40 5; 41 48 7; 49 56 3; 57 64 1; 192 199 12; 200 207 11] 

%mapping=[ 1 97 10; 100 200 11]; %AIP, BA5
%mapping=[ 1 97 11; ]; %BA5
%mapping=[ 129 136 6; 137 144 8; 145 152 4; 153 160 2; 161 168 5; 169 176 7; 177 184 3; 185 192 1; 193 200 12; 201 208 11] %P60CS_100518 
%mapping=[ 129 136 6; 137 144 8; 145 152 4; 153 160 2; 161 168 5; 169 176 7; 177 184 3; 185 192 1; 193 200 12; 201 208 11] %P58CS_071718
%mapping=[ 129 136 6; 137 144 8; 145 152 4; 153 160 2; 161 168 5; 169 176 7; 177 184 3; 185 192 1; 193 200 12; 201 208 11] %P58CS_071218 
%mapping=[ 129 136 6; 137 144 8; 145 152 4; 153 160 2; 161 168 5; 169 176 7; 177 184 3; 185 192 1; 193 200 12; 201 208 11]; %P56CS 043018
%mapping=[ 129 136 6; 137 144 8; 145 152 4; 153 160 2; 161 168 5; 169 176 7; 177 184 3; 185 192 1; 193 200 12; 201 208 11]; %P55CS 031218
%mapping=[ 1 8 6; 9 16 8; 17 24 4; 25 32 2; 33 40 5;41 48 7;49 56 3;57 64 1; 192 199 12; 200 207 11]; %P54CS 012318 & 012518 & 011818
%mapping=[ 1 8 6; 9 16 8; 17 24 4; 25 32 2; 33 40 5; 41 48 7;49 56 3; 57 64 1; 192 199 12; 200 207 11]; %P53CS 110217 & 110917
%mapping=[ 1 8 8; 9 16 4; 17 24 2; 25 32 6; 33 40 3; 41 48 1; 49 56 7; 57 64 5]; %P35CS 022515
%mapping=[ 1 8 5; 9 16 7; 17 24 3; 25 32 1; 33 40 6; 41 48 8; 49 56 4; 57 64 2; 192 199 11; 200 207 12]; %P51CS 070117 
%mapping=[ 1 8 6; 9 16 8; 17 24 4; 25 32 2; 33 40 5;41 48 7;49 56 3;57 64 1; 192 199 12; 200 207 11]; %P49CS 052217 & 052617
%mapping=[ 1 8 6; 9 16 8; 17 24 4; 25 32 2; 33 40 5;41 48 7;49 56 3;57 64 1; 192 199 12; 200 207 11]; %P48CS 031017
%mapping=[ 1 8 6; 9 16 8; 17 24 4; 25 32 2; 33 40 5;41 48 7;49 56 3;57 64 1; 192 199 12; 200 207 11]; %P47CS 022017
%mapping=[ 1 8 6; 9 16 8; 17 24 4; 25 32 2;33 40 5;41 48 7;49 56 3;57 64 1]; %P44CS 090516
%mapping=[ 1 8 6; 9 16 8; 17 24 4; 25 32 2; 33 40 5; 41 48 7; 49 56 3; 57 64 1; 192 199 12; 200 207 11]; %P43CS 110316 
%mapping=[ 1 8 6; 9 16 8; 17 24 4; 25 32 2;33 40 5;41 48 7;49 56 3;57 64 1]; %P42CS 081416, 081516 
%mapping=[ 1 8 6; 9 16 8; 17 24 4; 25 32 2;33 40 1;41 48 7;49 56 3;57 64 5]; %P33CS 032714,033014
%mapping=[ 1 8 8; 9 16 2; 17 24 6; 25 32 4;33 40 5;41 48 1;49 56 3;57 64 7]; %P29CS 103013
%mapping=[ 1 8 8; 9 16 2; 17 24 6; 25 32 4;33 40 1;41 48 5;49 56 3;57 64 7]; %P29CS 103113
%mapping=[ 1 8 7; 9 16 3; 17 24 5; 25 32 1;33 40 2;41 48 8;49 56 4;57 64 6]; %P31CS 020314
%mapping=[ 1 8 7; 9 16 1; 17 24 5; 25 32 3;33 40 6;41 48 8;49 56 4;57 64 2]; %P32CS 021314
%mapping=[ 1 8 5; 9 16 1; 17 24 2; 25 32 3;33 40 6]; %P21 012209
%mapping=[ 1 8 5; 9 16 1; 17 24 2; 25 32 3;33 40 6]; %P21 MA_012309
%mapping=[ 1 8 3; 9 16 2; 17 24 4; 25 32 6 ]; %DL_022109
%mapping=[ 1 8 2; 9 16 4; 17 24 6; 25 32 3;33 40 1; 41 48 5]; %P33HMH
%mapping=[ 1 8 5; 9 16 1; 17 24 3; 25 32 2;49 56 4; ]; %P42HMH


%************************************************************************
% ============= Toronto Mapping (TWH) =====================================

% 1=RH, 2=LH, 3=RA, 4=LA, 5=RAC, 6=LAC, 7=RSMA, 8=LSMA, 11=ROFC, 12=LOFC, 
%13 = LAHC, 14 =  LPHC, 15 = LPHG, 16 = LPL, 17 = LPRSMA, 18 = RAHC, 19 = 
% = RPHC, 20 = RPHG, 21 = RPL, 22 = RPRSMA, 23 = 'LINS', 24 = 'LPCC', 25 = LAIN 
%26 = LMIN, 27 = LMCC, 28 = LSTG , 29 = RAIN , 30 = RMCC , 31 = RMIN , 32 =
%RPIN, 33 = RTOC, 34 = 'LAPHG', 35 = 'LPPH', 36 = 'RAPHG', 37 = 'RPPHG'; 
% 38 = 'LPAIN', 39 = 'RPAIN'
 

%mapping = [129 136 13;137 144 25;145 152 4;153 160 38;161 168 14;169 176 15; 
    %177 184 18;185 192 29;193 200 3;201 208 39; 209 216 19;217 224 20]; %TWH101

%mapping = [129 136 13; 137 144 4; 145 152 14; 153 160 15; 161 168 18; 169 176 3; ...
    %177 184 19; 185 192 20]; %TWH096

%mapping = [129 136 6; 137 144 13; 145 152 4; 153 160 23; 161 168 12; 169 176 24; ...
    %177 184 14; 185 192 15]; %TWH091 

%mapping  = [129 136 6; 137 144 13; 145 152 4; 153 160 14; 161 168 15; 169 176 16; ...
    %177 184 17; 185 192 5; 193 200 18;  201 208 3; 209 216 19; 217 224 20; ... 
    %225 232 21; 233 240 22] %TWH098 
   
%mapping = [129 136 6; 137 144 13; 145 152 25; 153 160 4; 161 168 27; 169 176 26; ...
    %177 184 12; 185 192 14; 193 200 15]; %TWH107
    
%mapping = [129 136 6; 137 144 25; 145 152 2; 153 160 27; 161 168 12; 169 176 17; 177 184 8;  ...
    %185 192 28; 193 200 5; 201 208 18; 209 216 29; 217 224 3; 225 232 30; 233 240 11; 241 248 19; ...
    %249 256 7] %TWH100
    
%mapping = [129 136 5; 137 144 18; 145 152 29; 153 160 3; 161 168 30; 169 176 31; 177 184 11;  ...
    %185 192 19; 193 200 32; 201 208 33] %TWH103   
    
%Need to create Function for Toronto Brain Mapping!!!!!!!!!   
% ========== [mapping] = createTWHmapping
% ==========================================================================

%Epilepsy (Cedars-Sinai) 
pathIn=['Z:\dataRawConsortium\'];
pathOut=['Z:\dataRawConsortium\'];

%utah
%pathIn=['V:\dataRawEpilepsy\'];
%pathOut=['V:\dataRawEpilepsy\'];

%Epilepsy (TWH)
%pathIn=['V:\dataRawConsortium\NO\'];
%pathOut=['V:\dataRawConsortium\NO\'];


%% ===
[num,txt,raw] = xlsread(xlsFile, sheet, '','basic');  % range selection does not work in basic mode (unix)

masterTable=[]; %List of all final clusters: Channel Th Cluster

masterMerges=[]; %list all merges: Channel Th MergeTarget MergeSource

for k=range
    channelNr = (raw{k,columnChannel});
    thresh = raw{k,columnThresh};
    clusters = raw{k,columnClusterNumbers};

    if isnumeric(clusters)
        clusters=num2str(clusters);
    end
    
    if ~isempty(thresh) & ~isnan(thresh)
        
        %define clusters
        cls = strsplit(clusters, ',');
        clsToUse=[];
        for jj=1:length(cls)
            
            %see if this is a merge operation
            indsPlus = strfind(cls{jj},'+');
            if ~isempty(indsPlus)
                %assume merge was done already, only use first entry (main cl)
                clToUse=str2num( cls{jj}(1:indsPlus-1) );
                
                mergeSources = cls{jj}(indsPlus+1:end);
                
                mergeSources_list = strsplit(mergeSources,'+');
                
                for i=1:length(mergeSources_list)
                    masterMerges = [ masterMerges; [channelNr thresh clToUse str2num(mergeSources_list{i}) ]];
                end
            else
                clToUse = str2num(cls{jj});
            end
            if clToUse>0
                clsToUse = [clsToUse clToUse];
                
                
                masterTable = [masterTable; [ channelNr thresh clToUse ]];
            end
        end
        
        disp([num2str(k) ' Using: Ch=' num2str(channelNr) ' Th=' num2str(thresh) ' ClsOrig:' clusters]);
        disp(['ClsParsed:' num2str(clsToUse)]);
    end
end

%% execute merges
for j=1:size(masterMerges,1)
    overwriteParams = [ masterMerges(j,:) ];
    
    mergeClusters( [basepath patientID taskStr], sortDir, figsDir, finalDir, overwriteParams );
end

%% execute define usable clusters
channelsToProcess = unique( masterTable(:,1) );
for j = 1:length(channelsToProcess)
    
    channelNr = channelsToProcess(j);    
    inds = find(masterTable(:,1)==channelNr);
    
    cls = masterTable(inds,3);
    thresh = masterTable(inds,2);  %all thresholds are the same
    thresh = thresh(1);
    
    overwriteParams = [ channelNr thresh unique(cls') ];
    
    if ~defineUsableClusters( [basepath patientID taskStr], sortDir, figsDir, finalDir, overwriteParams );
%    if ~defineUsableClusters_v2( [basepath patientID],Area, sortDir, figsDir, finalDir, overwriteParams );
        error('error, fix manually and repeat');
    end
    
end


%% next processing steps
overwriteWarningDisable=1;
rangeToRun=[257:264]; %for Cedars (129:208)
% convertClustersToCells(basepath, patientID, ['/' sortDir '/' finalDir '/'], rangeToRun,overwriteWarningDisable);
convertClustersToCells_v2( Area, basepath, [patientID, taskStr], ['/' sortDir '/' finalDir '/'], rangeToRun,overwriteWarningDisable)

%% copy *_cells.mat files 
for k=1:length(rangeToRun)
    fnameFrom=[basepath patientID taskStr sortDir  finalDir num2str(Area) num2str(rangeToRun(k)) '_cells.mat'];
    fnameTo=[pathIn patientID taskStr];
    if exist(fnameFrom) & exist(fnameTo)
        disp(['Copying: ' fnameFrom ' ' fnameTo ])
        copyfile(fnameFrom,fnameTo);
    end
end

%% make brain area file


rangeToRun=[257:264];
defineBrainArea(pathIn,pathOut,patientID,taskStr, mapping,overwriteWarningDisable,rangeToRun, Area);


%% Move *_cells.mat files and event files into Share sorted/events folder.

shareFolder_events = 'Z:\dataRawConsortium\events\';
shareFolder_sorted = 'Z:\dataRawConsortium\sorted\';

%Create session file in 'R:\'
patientID(strfind(patientID, '\')) = [];

%Write the patient folder within '\sorted'
sortedFolder = [shareFolder_sorted, patientID,filesep, taskStr]
if exist(sortedFolder) 
    warning('This folder already exists: %s', sortedFolder) 
else 
    mkdir(sortedFolder)
end 

%Write the patient folder within '\events'
eventsFolder = [shareFolder_events, patientID, filesep, taskStr];
if exist(eventsFolder) 
    warning('This folder already exists: %s', eventsFolder) 
else 
    mkdir(eventsFolder)
end 

sessionFolder_main = [basepath, patientID, filesep, taskStr]; 
if ~exist(sessionFolder_main)
    error('This file does not exist: %s', sessionFolder_main)
else 
    directory_contents = dir(sessionFolder_main); 
end 

%Move files
for i = 1:length(directory_contents) 
    
    directoryFile = [directory_contents(i).folder, filesep, ... 
        directory_contents(i).name]; 
    
    %Move *_cells.mat files -----> sorted folder 
    if contains(directory_contents(i).name, '_cells') && contains(directory_contents(i).name, '.mat')
        %fprintf('%s \n',directory_contents(i).name )
        
        copyfile(directoryFile,sortedFolder);
        disp(['Copied: ' directoryFile ' ' sortedFolder ])
    end 
    
    %Move Events files
    if contains(directory_contents(i).name, 'brainArea.mat') ||  ... 
            contains(directory_contents(i).name, 'newold80.txt') || ... 
            contains(directory_contents(i).name, 'newold81.txt') || ... 
            contains(directory_contents(i).name, 'eventsRaw.mat')
        
        %fprintf('%s \n',directory_contents(i).name )
        
        copyfile(directoryFile,eventsFolder);
        disp(['Copied: ' directoryFile ' ' eventsFolder ])
    end  
    
end 



%% =============================== below this -- manual things, usually not needed

%% manual min/max merge

channelNr=22;
sortDirMin='5.502';
sortDirMax='5.501';
sortDirMerge='5.509';

clustersMin=[565 537];
clustersMax=[269 523 455];

% list clusters here which are clearly miss-aligned to make spikes available to merge into other clusters. this has to be a subset of what is given in clustersMin/Max
nonPriorityClusters=[455];  

priorityFile=2;

clustersMinMaxMerge([basepath patientID '/' sortDir '/'], channelNr, sortDirMin, sortDirMax, sortDirMerge, clustersMin, clustersMax, priorityFile,nonPriorityClusters);

%% manual define usable
%defineUsableClusters( [basepath patientID], sortDir, figsDir, finalDir, [27 5.03 706 683 349 710 419] );

%defineUsableClusters( [basepath patientID], sortDir, figsDir, finalDir, [47 4.5 1323 1324 1428 1558 1593 1604 1606] );
%defineUsableClusters( [basepath patientID], sortDir, figsDir, finalDir, [47 4 1960 1998 2009 2024 2035 1932 2020] );
%defineUsableClusters( [basepath patientID], sortDir, figsDir, finalDir, [47 5.5 1059 1029 997 861 444] );
%defineUsableClusters( [basepath patientID], sortDir, figsDir, finalDir, [47 5.2 1146 1142 1129 1044 1029 998] );
%defineUsableClusters( [basepath patientID], sortDir, figsDir, finalDir, [47 5.01 1166 1277 1307 1309 1022 1271 1180] );

%defineUsableClusters( [basepath patientID], sortDir, figsDir, finalDir, [44 5 625 614 611 515 622] );
%defineUsableClusters( [basepath patientID], sortDir, figsDir, finalDir, [41 5.005 1851,1823,  1741] );

defineUsableClusters( [basepath patientID], sortDir, figsDir, finalDir, [33 5.302 775 763 774] );

  %mergeClusters( [basepath patientID], sortDir, figsDir, finalDir, [22 5.091 446 448] );

%% next processing steps
overwriteWarningDisable=1;
rangeToRun=1:32;
%rangeToRun=33;
convertClustersToCells( basepath, patientID, ['/' sortDir '/' finalDir '/'], rangeToRun,overwriteWarningDisable);

%% copy cell files
%(manual)
copyFrom=[basepath patientID '/' sortDir '/' finalDir '/A' num2str(rangeToRun) '_cells.mat'];
copyTo=[pathIn patientID '/' taskStr];
disp(['Copy from/to: ' copyFrom ' / ' copyTo]);
copyfile(copyFrom,copyTo);


%%
%need to manually define params in below before running

overwriteWarningDisable=1;


defineBrainArea(pathIn,pathOut,patientID,taskStr, mapping,1);

