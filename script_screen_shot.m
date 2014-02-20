% Run Script for screen shot from video
% Written by Qiong Wang at University of Pennsylvania
% 02/19/2014

%% Clear up
clear all;
close all;
clc;

%% Parameters
cams     = 1 : 10;                    % Cameras in the array
verbose  = false;                     % Whether to show the details
global vidObj imgIdx idx currDir fileTitle;

%% Path
scriptDir = fileparts(mfilename('fullpath'));
% dataDir   = fullfile(scriptDir, '/videos');
% outputDir = fullfile(scriptDir, '/images');
dataDir   = '/media/Gabriella/GoPro-20140217-calib_data/videos/';
outputDir = '/media/Gabriella/GoPro-20140217-calib_data/images/';
if ~exist(outputDir, 'dir')
    mkdir(outputDir); 
end
addpath(genpath(scriptDir));

%% Extract Frame
for i = 1 : 1%numel(cams)
    imgIdx = 1;
    idx    = 1;
    fileTitle = sprintf('camera%02d', i); 
    currDir = fullfile(outputDir, fileTitle);
    if ~exist(currDir, 'dir')
        mkdir(currDir);
    end
    vidObj  = VideoReader(fullfile(dataDir, [fileTitle, '_001.MP4']));
    figure('KeyPressFcn', @key_press_shot,'units','normalized','outerposition',[0 .4 .6 .6]);
end