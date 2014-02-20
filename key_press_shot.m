function key_press_shot(ObjH, EventData)
% KEY_PRESS_SHOT() takes shots for the selected frame in videoreader object

disp('----------------------------');
disp('Press i for initialization');
disp('Please select the frame press space : )');
disp('----------------------------')

global vidObj imgIdx idx currDir fileTitle;
key = get(ObjH, 'CurrentCharacter');
switch key
    case 'i'
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

    otherwise
        disp(double(key));
end

end