-module(ip2something).

-export([
    read_csv/1
]).

read_csv(Path) ->
    {ok, F} = file:open(Path, [read, {encoding,latin1}]),
    file:read_line(F), %%I don't care about the first line
    read_line(F),
    ok.

read_line(Fd) ->
    case file:read_line(Fd) of 
    {ok, Data} ->
        [Ip|Tokens] = lists:map(fun(Dirty) ->
            case Dirty of
                "" -> "";
                "\n" -> "";
                _ -> string:substr(Dirty, 2, string:len(Dirty) -2)
            end
        end, string:tokens(string:substr(Data, 1, string:len(Data) -2), ";")),
        {Ipv, _} = string:to_integer(Ip),
        io:format("line ~B : ~p\n", [Ipv, Tokens]),
        read_line(Fd);
    eof -> ok;
    {error, Reason} -> {stop, Reason}
end.
    