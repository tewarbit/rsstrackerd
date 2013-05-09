-module(rsstrackerd_11_inets). 
-export([init/0, stop/0]). 

init() -> 
     inets:start(). 

stop() -> 
     inets:stop(). 
%% 