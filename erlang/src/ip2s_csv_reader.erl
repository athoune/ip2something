-module(ip2s_csv_reader).
-author("Mathieu Lecarme <mathieu@garambrogne.net>").

-include("ip2something.hrl").

-export([
    read_csv/1
]).

%% Read CSV source and build index
read_csv(Path) ->
    {ok, F} = file:open(Path, [read, {encoding,latin1}]),
    io:get_line(F, ""), %%I don't care about the first line
    {ok, Index} = file:open("./index.db", [write]),
    {ok, Datas} = dets:open_file(?IP2S_DATA, [
        {file,"./data.db"}
        ]),
    read_line(F, Index, Datas).

read_line(Fd, Index, Datas) ->
    case io:get_line(Fd, "") of 
    eof -> 
        file:close(Index),
        ok;
    {error, Reason} ->
        io:format("Erreur: ~w", [Reason]),
        {stop, Reason};
    Data ->
        %io:format("~p ~n ~p ~n", [Data, string:tokens(string:substr(Data, 1, string:len(Data) -2), ";")]),
        [Ip|Tokens] = lists:map(fun(Dirty) ->
                %io:format("~p~n", [Dirty]),
                case Dirty of
                    "" -> "";
                    "\n" -> "";
                    _ -> string:substr(Dirty, 2, string:len(Dirty) -2)
                end
            end,
            string:tokens(string:substr(Data, 1, string:len(Data) -2), ";")),
        {Ipv, _} = string:to_integer(Ip),
        file:write(Index, <<Ipv:32/unsigned-integer>>),
        dets:insert_new(Datas, {Ip, Tokens}),
        %io:format("line ~B : ~p\n", [Ipv, Tokens]),
        read_line(Fd, Index, Datas)
    end.

