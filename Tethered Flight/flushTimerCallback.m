function flushTimerCallback(obj, event, handles, currentChannel)

    global running;
    global myTimer;
    global ardVar;
    global USB;
    global daqParams;
    
    if (running)
        if (currentChannel == 0)
            ardWriteParam(ardVar.Olf1Armed, 'ffff');
            ardWriteParam(ardVar.Olf2Armed, '0000');
            ardWriteParam(ardVar.Olf3Armed, '0000');
            ardFlip;
            myTimer = timer('ExecutionMode','singleShot','StartDelay',5,...
                'TimerFcn',{'flushTimerCallback',handles,1});
            start(myTimer);
        elseif (currentChannel == 1)
            ardWriteParam(ardVar.Olf1Armed, '0000');
            ardWriteParam(ardVar.Olf2Armed, 'ffff');
            ardWriteParam(ardVar.Olf3Armed, '0000');
            ardFlip;
            myTimer = timer('ExecutionMode','singleShot','StartDelay',5,...
                'TimerFcn',{'flushTimerCallback',handles,2});
            start(myTimer);
        elseif (currentChannel == 2)
            ardWriteParam(ardVar.Olf1Armed, '0000');
            ardWriteParam(ardVar.Olf2Armed, '0000');
            ardWriteParam(ardVar.Olf3Armed, 'ffff');
            ardFlip;
            myTimer = timer('ExecutionMode','singleShot','StartDelay',5,...
                'TimerFcn',{'flushTimerCallback',handles, 3});
            start(myTimer);
        elseif (currentChannel == 3)
            ardWriteParam(ardVar.Olf1Armed, '0000');
            ardWriteParam(ardVar.Olf2Armed, '0000');
            ardWriteParam(ardVar.Olf3Armed, '0000');
            ardFlip;
            myTimer = timer('ExecutionMode','singleShot','StartDelay',5,...
                'TimerFcn',{'flushTimerCallback',handles, 0});
            start(myTimer);
            
            numTimes = str2num(get(handles.repsText,'String'));
            set(handles.repsText,'String',num2str(numTimes+1));
        end
    end