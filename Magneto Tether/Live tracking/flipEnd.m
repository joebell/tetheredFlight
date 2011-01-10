% flipEnd.m
%
% During tracking using mode 3, flips which centroid blob the algorithm
% tracks. Use this to switch between tracking the head or the tail.
% 
% JSB 11/2010
function flipEnd()

    global trackingParams;
    
    trackingParams.ringBuffer.flip = true;