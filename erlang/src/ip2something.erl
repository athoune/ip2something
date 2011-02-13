-module(ip2something).

-export([
    read_csv/1
]).

read_csv(Path) ->
    {ok, F} = file:open(Path, [read, {encoding,latin1}]),
    read_line(F),
    ok.

read_line(Fd) ->    case file:read_line(Fd) of 
    {ok, Data} ->
        Tokens = string:tokens(Data, ";"),
        io:format("line ~p", [Tokens]),
        read_line(Fd);
    eof -> ok;
    {error, Reason} -> {stop, Reason}
end.
