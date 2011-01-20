function ardSetLaserPower(varargin)

 global ardVar;
 
    if nargin == 1
        constPower = varargin{1};
        rampPower  = constPower;
        rampDur = 800;
        decay = 3;
        plateauDecay = 0;
    elseif nargin == 5
        constPower = varargin{1};
        rampPower  = varargin{2};
        rampDur = varargin{3};
        decay = varargin{4};
        plateauDecay = varargin{5};
    end
    
    ardWriteParam(ardVar.LaserPower, constPower);
    ardWriteParam(ardVar.LaserPowerF, rampPower);
    ardWriteParam(ardVar.LaserFDur, rampDur);
    ardWriteParam(ardVar.LaserDecay, decay);
    ardWriteParam(ardVar.LaserPlateauDecay, plateauDecay);
       
    ardFlip();