function ardSetAutoTau(tau)

% time constant in ms

    global ardVar;

    ardWriteParam(ardVar.Tau, tau); 
    ardFlip();
        