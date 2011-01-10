% abort.m

global analogIn;

stop(timerfindall);
delete(timerfindall);
daqreset;
