function revealRandom(index)

    load('randomOrder.mat');
    disp(['Use odor #',num2str(randOrder(index)),...
        ' ',odorList{randOrder(index)}]);
    