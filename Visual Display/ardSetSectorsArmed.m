function ardSetSectorsArmed(sectors)

    global ardVar;

    ardWriteParam(ardVar.SectorsArmed, sectors);
    ardFlip;
