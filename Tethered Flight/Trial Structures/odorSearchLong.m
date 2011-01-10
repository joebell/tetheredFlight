
% odorSearchLong.m

% 0-1  box only
% 1-3  EV with box
% 3-5  odor with box
% 5-7  EV with box
% 7-9  odor with box
% 9-11  EV with box
% 11-13  odor with box
% 13-15  EV with box
% 15-17  odor with box
% 17-19  EV with box
% 19-21  odor with box
% 21-23  EV with box
% 23-25  odor with box
% Use EV @ ch0, odor @ ch1

% Constants
global ts;

center = 0;

% Format: {time, visStim}
%          [Mode, K0, K1, K2]
visStimN = [1, 0, -2, center];
LaserOn  = '0000';
LaserOff = '0000';
odorOn = '3c00';
EVOn   = '3c00';
olfOff = '0000';

histogramBounds = [1,1*60; 1*60,3*60 ; 3*60,5*60 ; 5*60,7*60 ; 7*60,9*60 ; 9*60,11*60 ; 11*60,13*60 ; 13*60,15*60 ; 15*60,17*60 ; 17*60,19*60 ; 19*60,21*60 ; 21*60,23*60 ; 23*60,25*60];

trialStructureList = [...
        {0,      visStimN, LaserOff, olfOff,  olfOff};...     %nb. First line is initial settingss
        {1*60,   visStimN, LaserOff,   EVOn,  olfOff};...
        {3*60,   visStimN, LaserOff, olfOff,  odorOn};...
        {5*60,   visStimN, LaserOff,   EVOn,  olfOff};...
        {7*60,   visStimN, LaserOff, olfOff,  odorOn};...
        {9*60,   visStimN, LaserOff,   EVOn,  olfOff};...
        {11*60,   visStimN, LaserOff, olfOff,  odorOn};...
        {13*60,   visStimN, LaserOff,   EVOn,  olfOff};...
        {15*60,   visStimN, LaserOff, olfOff,  odorOn};...
        {17*60,   visStimN, LaserOff,   EVOn,  olfOff};...
        {19*60,   visStimN, LaserOff, olfOff,  odorOn};...
        {21*60,   visStimN, LaserOff,   EVOn,  olfOff};...
        {23*60,   visStimN, LaserOff, olfOff,  odorOn};...
        {25*60,  visStimN, LaserOff, olfOff,  olfOff};...
    ];

    