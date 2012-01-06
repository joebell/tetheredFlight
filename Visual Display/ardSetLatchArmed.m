function ardSetLatchArmed(sectors)

    global ardVar;

    ardWriteParam(ardVar.LatchArmed, sectors);
    ardFlip;
