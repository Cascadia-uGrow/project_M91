%% @author Camille Day <camille@cascadiamicrogrow.com>
%% 	[http://www.cascadiamicrogrow.com]
%% @copyright 2015 Camille Day 
%% @version x.x.x
%% @title Sensor Xtor Behaviour  
%% @doc defines the general behaviour of sensor xtor modules
%% display as "YYYY-MM-DD".

-module(sensor_xtor).

-callback init().

-callback start().

-callback stop().

-callback terminate().

-callback read().
