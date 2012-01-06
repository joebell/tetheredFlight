function color = colorFader(index,max)

    max = max + 1;

    pt1 = max/3;
    pt2 = 2*max/3;
    
    if index <= pt1
        color = abs([index/pt1 0 0]);
    elseif (index > pt1 && index <= pt2)
        color = abs([1-(index-pt1)/pt1  (index - pt1)/pt1 0]);
    elseif (index > pt2)
        color = abs([0 1-(index-pt2)/pt1 (index-pt2)/pt1 ]);
    end