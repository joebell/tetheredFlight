function progVerticalGrate()


% X1: Width
% X2: Spacing
% 0: Offset
% ONVAL: value

panelConstants;

           init  = [SETGSBITS,3,0,0,0; ...
                    CLEARBUFF,0,0,0,0; ...
                    CLEARMEM, 1, 1, 0, 0; ...
                    SETDATA, X1, 4, 0, 0; ...
                    SETDATA, X2, 16, 0, 0; ...
                    SETDATA, ONVAL, 0, 0, 0; ...
                    SETDATA, OFFVAL, 7, 0, 0];
                    

prog = [C1ICLEARBUFF,RVERTGRATE, X1, X2, X0, ONVAL, ...
        C1FLIPBUFF,C1ENDPROG,ENDPROG];

ardDispOff();
for i=1:size(init,1)
    ardI2Cecho(init(i,1),init(i,2),init(i,3),init(i,4),init(i,5));
end    
for i=1:size(prog,2)
    ardI2Cecho(SETPROG, i-1, prog(i), 0, 0);
end
