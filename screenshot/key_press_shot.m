function key_press_shot(ObjH, EventData)
% KEY_PRESS_SHOT() takes shots for the selected frame in videoreader object

global vidObj imgIdx idx dataDir camIdx;
outputDir = fullfile(dataDir, '/images/');
if ~exist(outputDir, 'dir')
    mkdir(outputDir); 
end
fileTitle = sprintf('camera%02d', camIdx);
currDir = fullfile(outputDir, fileTitle);
if ~exist(currDir, 'dir')
    mkdir(currDir);
end
key = get(ObjH, 'CurrentCharacter');
switch key
    case 'i'
        vidObj  =   VideoReader(fullfile(dataDir, '/videos/', [fileTitle, '_001.MP4']));
        img = read(vidObj, 1);
        imshow(img);
        
    case ' '           % Select frame to be extracted
        img = read(vidObj, imgIdx);
        imshow(img);
        imwrite(img,fullfile(currDir, sprintf([fileTitle, '_%05d.bmp'],idx)),'bmp');
        idx = idx + 1;
        
    case 'z'           % zoom in and out
        zoom on
        waitfor(gcf, 'CurrentCharacter', 13)
        zoom reset
        zoom off
        
    case char(29)       % Forward, right arrow
        imgIdx = imgIdx + 1;
        img = read(vidObj, imgIdx);
        imshow(img);
        text(0, size(img,1) - 80, ['#' num2str(imgIdx)], 'FontSize', 20);

    case char(30)       % Fast Forward, up arrow
        imgIdx = imgIdx + 10;
        img = read(vidObj, imgIdx);
        imshow(img);
        text(0, size(img,1) - 80, ['#' num2str(imgIdx)], 'FontSize', 20);

    case char(61)       % FFast Forward, =
        imgIdx = imgIdx + 100;
        img = read(vidObj, imgIdx);
        imshow(img);
        text(0, size(img,1) - 80, ['#' num2str(imgIdx)], 'FontSize', 20);

    case char(28)       % Backward, left arrow
        imgIdx = imgIdx - 1;
        img = read(vidObj, imgIdx);
        imshow(img)
        text(0, size(img,1) - 80,['#' num2str(imgIdx)], 'FontSize', 20);

    case char(31)       % Fast Backward, down arrow
        imgIdx = imgIdx - 10;
        img = read(vidObj, imgIdx);
        imshow(img)
        text(0, size(img,1) - 80,['#' num2str(imgIdx)], 'FontSize', 20);

    case char(45)       % FFast Backward, -
        imgIdx = imgIdx - 100;
        img = read(vidObj, imgIdx);
        imshow(img)
        text(0, size(img,1) - 80,['#' num2str(imgIdx)], 'FontSize', 20);

    case char(27)
        camIdx = camIdx + 1;
        imgIdx = 1;
        idx    = 1;
        fileTitle = sprintf('camera%02d', camIdx);
        currDir = fullfile(outputDir, fileTitle);
        if ~exist(currDir, 'dir')
            mkdir(currDir);
        end
        disp('**************************');
        disp('Please re-initialize by pressing i');
        disp('**************************');
        
    otherwise
        disp(double(key));
end

assert(camIdx <= 10, 'There are only ten cameras, please check your indexvideo reader cannot read files!');

disp('----------------------------')
fprintf('Camera # %02d Actural Frame # %05d Recorded Frame # %05d \n', camIdx, imgIdx, idx);
disp('----------------------------')
disp('Please select the frame press space : )');
disp('----------------------------')

end