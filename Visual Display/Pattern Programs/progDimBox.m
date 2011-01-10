function progDimBox() 

width = 5;
length = 9;
height = 8;
ZEROLOC = 9;

global ardVar;

panelConstants;

           init  = [SETGSBITS,3,0,0,0; ...
                    CLEARBUFF,0,0,0,0; ...
                    CLEARMEM, 1, 1, 0, 0; ...
                    SETDATA, X1, 3, 0, 0; ...
                    SETDATA, X2, 7, 0, 0; ...
                    SETDATA, X3, 0, 0, 0; ...
                    SETDATA, Y1, 4, 0, 0; ...
                    SETDATA, Y2, 2, 0, 0; ...
                    SETDATA, Y3,  0, 0, 0; ...
                    SETDATA, ZEROLOC, 0, 0, 0; ...
                    SETDATA, ONVAL, 7, 0, 0; ...
                    SETDATA, OFFVAL, 0, 0, 0];
 
                %void DrawBoxArray(u08 xWidth, u08 xSpacing, u08 xOffset, u08 yWidth, u08 ySpacing, u08 yOffset, u08 value) {              
prog = [C1ICLEARBUFF, ...               % Clear buffer
       RADD, X3, ZEROLOC, X3, 0, ...    % Copy X0 to X3
       C1DIAGLINE,...                  % Draw the box array
       C1FLIPBUFF, C1ENDPROG, ENDPROG];
  

ardDispOff();
for i=1:size(init,1)
    ardI2Cecho(init(i,1),init(i,2),init(i,3),init(i,4),init(i,5));
end    
for i=1:size(prog,2)
    ardI2Cecho(SETPROG, i-1, prog(i), 0, 0);
end