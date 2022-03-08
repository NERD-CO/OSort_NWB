%% TO RUN OSORT-NWB


%% Step 1a Make sure matnwb is ON YOUR PATH (all sub-folders)

%% Step 1b Make sure OSort_NWB is ON YOUR PATH (Top Folder)

%% Step 1c Make sure OSort_NWB/osort-v4-rel is ON YOUR PATH (all sub-folders)

%% Step 2 Create a new folder for spike sorting a session
% i.e., C:/Documents/Data/Study1/SpikeSorting/Session1

%% Step 3 Inside NEW folder create an 'nwb' folder
% i.e., C:/Documents/Dat/Study1/SpikeSorting/Session1/nwb

%% Step 4 Copy and past the NWB file of interest from NWB repo folder
% ONLY copy over the RAW version of the NWB to the '\nwb' folder
% For example:
% In your new folder you should have the following:
% -- /MW1_Session_2_raw.nwb

%% Step 5 Change the following input arguments:
% basepath 
% -- This should be the outer folder you created in STEP 2
basepath = 'I:\01_Coding_Datasets\OSort_TEST\SpikeSorting\Session_5\';
patientID = 'MW_3';
nwbFname = 'MW3_Session_5_raw.nwb';
% Select wires
channS = 257:258;

%% Step 6 Run the main Function

OSort_RunFun_css("basePath",basepath,...
                 "patientID",patientID,...
                 "nwbFILE",nwbFname,...
                 "chann",channS)