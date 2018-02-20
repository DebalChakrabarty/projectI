foregroundDetector = vision.ForegroundDetector('NumGaussians', 3, ...
    'NumTrainingFrames', 50);

videoReader = vision.VideoFileReader('bouncingball.mp4');
videoObj = VideoReader('bouncingball.mp4');

for i = 1:vidObj.NumberOfFrames
    frame = step(videoReader); % read the next video frame
    foreground = step(foregroundDetector, frame);
    %figure; imshow(frame); title('Video Frame');

    %figure; imshow(foreground); title('Foreground');


    se = strel('square', 3);
    filteredForeground = imopen(foreground, se);
    %figure; imshow(filteredForeground); title('Clean Foreground');


    blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
    'AreaOutputPort', false, 'CentroidOutputPort', false, ...
    'MinimumBlobArea', 150);
    bbox = step(blobAnalysis, filteredForeground);


    result = insertShape(frame, 'Rectangle', bbox, 'Color', 'green');


    numObject = size(bbox, 1);
    result = insertText(result, [10 10], numObject, 'BoxOpacity', 1, ...
    'FontSize', 14);
    %figure; imshow(result); title('Detected object');
    imwrite(result,[int2str(i),'.jpg']);
end

video = VideoWriter('output.mp4'); %create the video object
open(video); %open the file for writing
for ii=1:150 %where N is the number of images
    I = imread(strcat(int2str(ii),'.jpg')); %read the next image
    writeVideo(video,I); %write the image to file
end
close(video); %close the file
