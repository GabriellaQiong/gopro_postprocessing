% Run Script for saving results from the server part
% Written by Qiong Wang at University of Pennsylvania
% 02/21/2014

%% Load data
dataDir = '/home/qiong/'; 
str     = input('Please input the file name: ');
load(fullfile(dataDir, str));

%% Show 
h1 = figure(1);imagesc(disp_left.img);axis image;title('left disparity');
h2 = figure(2);imagesc(disp_right.img);axis image;title('right disparity');
h3 = figure(3);imagesc(occlusion.img);axis image;title('occlusion');

%% Save
print(h1, '-djpeg90', '-r0', fullfile(dataDir, [str(1 : end - 4), '_left_disp']));
print(h2, '-djpeg90', '-r0', fullfile(dataDir, [str(1 : end - 4), '_right_disp']));
print(h3, '-djpeg90', '-r0', fullfile(dataDir, [str(1 : end - 4), '_occlusion_disp']));