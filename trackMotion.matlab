
%use in the Computer Vision System Toolbox
%
%This property applies only when the file contains video. This property can be set to RGB, Intensity, or YCbCr 4:2:2.
hvfr = vision.VideoFileReader('C:\####\viptraffic.avi', ...
                              'ImageColorSpace', 'Intensity', ...
                              'VideoOutputDataType', 'uint8');
converter = vision.ImageDataTypeConverter;
opticalFlow = vision.OpticalFlow('Method','Lucas-Kanade');
% the other one is Magnitude-squared
opticalFlow.OutputValue = 'Horizontal and vertical components in complex form';
%Draw rectangles, lines, polygons, or circles on an image，The output image can then be displayed or saved to a file.
%Specify the appearance of the shape's border as Black, White, or Custom. When you set this property to Custom, you can use the CustomBorderColor property to specify the value. This property applies when you set the BorderColorSource property to Property.
%draw a white line in the color image
%saturates， ype UINT8, which has a maximum value of 255. 
shapeInserter = vision.ShapeInserter('Shape','Lines','BorderColor','Custom', 'CustomBorderColor', 255);
videoPlayer = vision.VideoPlayer('Name','Motion Vector');
k = 0;
%before the whole video is finishsed
while ~isDone(videoReader)
  %抽取每一帧出来，% Play video. Every call to the step method reads another frame
    frame = step(videoReader);
    %把每一帧用converter转化
    im = step(converter, frame);
    %% compute optical flow for the video
    of = step(opticalFlow, im);
    %% generate coordinate points
    %Essentially the function does the basic math to create vector lines that indicate optic flow direction. 
    lines = videooptflowlines(of, 10);
    if ~isempty(lines)
      k = k+1;
      out =  step(shapeInserter, im, lines); % draw lines to indicate flow
      step(videoPlayer, out);   % view in video player
      imshow(out);
      M(k) = getframe;  %获得这一帧的信息
end end
release(videoReader);
movie2avi(M, 'homework.avi', 'compression', 'None');  %输出视频