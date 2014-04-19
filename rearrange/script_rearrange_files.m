% Run Script for rearrangin files
% Written by Qiong Wang at University of Pennsylvania
% 02/23/2014

%% Clear up
clear all;
close all;
clc;

%% Parameters
verbose  = false;                             % Whether to show the details

%% Path
scriptDir = fileparts(mfilename('fullpath'));
dataDir   = '/media/Gabriella/GoPro-20140319-building_data/';
addpath(genpath(scriptDir));

%% Rename files
% Remove . and .. + find directories
dirData = dir(dataDir);
isDir   = [dirData(:).isdir];                 % returns logical vector
dirName = {dirData(isDir).name}';
dirName(ismember(dirName,{'.','..'})) = [];
numCams = length(dirName);

% Rename
for camIdx = 1 : numCams
    camDir  = fullfile(dataDir, char(dirName(camIdx)), ['images_raw', num2str(camIdx, '%02d')]);
    dirCam  = dir(camDir);
    imgName = {dirCam(:).name}';
    imgName(ismember(imgName,{'.','..'})) = [];
    numImgs = length(imgName);
    for imgIdx = 600 - (camIdx == 2) : numImgs
        fprintf('Processing camera #%d frame #%d ...\n', camIdx, imgIdx);
        rmfile(fullfile(camDir, char(imgName(imgIdx + 1))));
        movefile(fullfile(camDir, char(imgName(imgIdx))), fullfile(camDir, sprintf('camera%02d_%05d.jpg', camIdx, imgIdx + (camIdx == 2))));
    end
end