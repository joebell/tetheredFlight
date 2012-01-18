function code = expCode(index)

    baseCode = '110118-';
    
    load('randomOrder.mat');
    
    codeSuffix = odorList{randOrder(index)};
    
    code = [baseCode,codeSuffix];