clc;
clear all;
close all;
%%
% Delte webcam object if it is already accessing the camera
delete(imaqfind)

% Create the objects for the color and depth sensors.
% Device 1 is the color sensor and Device 2 is the depth sensor.
vid = videoinput('kinect',1);
vid2 = videoinput('kinect',2);

% Get the source properties for the depth device.
srcDepth = getselectedsource(vid2);

% set tracking mode to skeleton
set(srcDepth,'TrackingMode','Skeleton')

% Set the frames per trigger for both devices to 1.
vid.FramesPerTrigger = 1;
vid2.FramesPerTrigger = 1;

% Set the trigger repeat for both devices to 200, in
% order to acquire 201 frames from both the color sensor and the depth sensor.
vid.TriggerRepeat = 5000;
vid2.TriggerRepeat = 5000;

% Configure the camera for manual triggering for both sensors.
triggerconfig([vid vid2],'manual');

% Start both video objects.
start([vid vid2]);

% Trigger the devices, then get the acquired data.% Trigger 200 times to get the frames.
for i = 1:5000
    
    
    % Trigger both objects.
    trigger([vid vid2])
    
    % Get the acquired frames and metadata.
    [imgColor] = getdata(vid);
    
    [imgDepth, ts_depth, metaData_Depth] = getdata(vid2);
    
    % Find which ID is tracked
    ix = metaData_Depth.IsSkeletonTracked; % Find nonzero terms
    
    % Get x y cordinates according to pixels
    Co = metaData_Depth.JointImageIndices;
    
    % Get x y and z cordinates (normalised)
    Co2 = metaData_Depth.JointWorldCoordinates;
    
    % Get tracked skeleton points
    S = Co(:,:,ix);
    S2 =  Co2(:,:,ix);
    
    if sum(ix)>0
    Hand_right = S2(12,:,1)
    end
    subplot(121)
    imshow(imgColor)
    title('Color image')
    skeletonViewer(S,sum(ix))
    
    
    subplot(122)
    imshow(imgDepth,[]);
    title('Depth image')
    
    
   
end