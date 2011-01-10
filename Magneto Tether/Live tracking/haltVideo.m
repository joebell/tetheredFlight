% haltVideo.m
%
% Use  this to stop the running video object.  This is called automatically
% when the video preview window is closed.
%
% JSB 11/2010
function haltVideo(obj, event)

    global vid;
    
    stop(vid);
    flushdata(vid);
    delete(gcf);