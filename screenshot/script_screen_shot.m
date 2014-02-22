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
global vidObj imgIdx idx dataDir camIdx

% Path
scriptDir = fileparts(mfilename('fullpath'));
% dataDir   = fullfile(scriptDir, '/videos');
% outputDir = fullfile(scriptDir, '/images');
dataDir   = '/media/Gabriella/GoPro-20140217-calib_data/';
addpath(genpath(scriptDir));

%% Extract Frame
disp('----------------------------');
disp('Press i for initialization');
disp('----------------------------');
fig    = figure;
imgIdx = 1;
idx    = 1;
camIdx = 1;
vidObj = [];
set(fig, 'KeyPressFcn', @key_press_shot);