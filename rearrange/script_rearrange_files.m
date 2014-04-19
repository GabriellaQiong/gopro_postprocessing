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
dataDir   = '/media/Qiong/shops_loop/images';
addpath(genpath(scriptDir));
 
%% Rename files
% Remove . and .. + find directories
dirData = dir(dataDir);
isDir   = [dirData(:).isdir];                 % returns logical vector
dirName = {dirData(isDir).name}';
dirName(ismember(dirName,{'.','..'})) = [];
numCams = length(dirName);

% Rename
for camIdx = 2 : numCams
    if camIdx == 8
        continue;
    end
    camDir  = fullfile(dataDir, char(dirName(camIdx)));
    dirCam  = dir(camDir);
    imgName = {dirCam(:).name}';
    imgName(ismember(imgName,{'.','..'})) = [];
    numImgs = length(imgName);
    for imgIdx = 1 : numImgs
        fprintf('Processing camera #%d frame #%d ...\n', camIdx, imgIdx);
        movefile(fullfile(camDir, char(imgName(imgIdx))), fullfile(camDir, sprintf('camera%02d_%05d.jpg', camIdx, imgIdx)));
    end
end