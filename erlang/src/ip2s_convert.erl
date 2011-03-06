-module(ip2s_convert).
-author("Mathieu Lecarme <mathieu@garambrogne.net>").

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

-export([
    ip_to_int/1,
    ip_to_bin/1
]).

%% Convert Ip to an int32
%% "127.0.0.1" => 2130706433
ip_to_bin(Ip) ->
    erlang:list_to_binary(str_ip_to_list(Ip)).

str_ip_to_list(Ip) ->
    lists:map(
        fun(S) -> 
            {I, _} = string:to_integer(S),
            I
        end,
        string:tokens(Ip, ".")
    ).

%% "127.0.0.1" => 2130706433
ip_to_int(Ip) ->
    <<I:32/unsigned-integer>> = ip_to_bin(Ip),
    I.

-ifdef(EUNIT).
ip_test() ->
    ?assertEqual(2130706433, ip_to_int("127.0.0.1")).
-endif.