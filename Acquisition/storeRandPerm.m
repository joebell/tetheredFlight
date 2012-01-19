function storeRandPerm(num)

    randOrder = randperm(num);
    
    odorList = {...
        'EV',...
        'H2O',...
        'PO',...
        '8AC-2',...
        'ACV-1',...
        'ACV-2',...
        'ACV-4',...
        'ACV-6',...
        'MeS-2',...
        'Benz-3',...
        'Butyric-2',...
        '3MT1P-2',...
        'ETA-9',...
        'Phenyl-2',...
        'GerAc-2',...
        'EtOH-2'};
    
    save('randomOrder.mat','randOrder','odorList');