function ardSetAutoVar(targetVariance)

    global ardVar;

    ardWriteParam(ardVar.TargetVar, targetVariance); 
    ardFlip();
        