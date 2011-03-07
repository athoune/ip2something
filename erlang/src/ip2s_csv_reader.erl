-module(ip2s_csv_reader).
-author("Mathieu Lecarme <mathieu@garambrogne.net>").

-include("ip2something.hrl").

-export([
    read_csv/1
]).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

%% Read CSV source and build index
% [TODO] using dets:init_table/2
read_csv(Path) ->
    {ok, F} = file:open(Path, [read, {encoding,latin1}]),
    io:get_line(F, ""), %%I don't care about the first line
    {ok, Index} = file:open("./index.db", [write]),
    {ok, Datas} = dets:open_file(?IP2S_DATA, [
        {file,"./data.db"},
        {min_no_slots, 4047600}
        ]),
    read_line(F, Index, Datas).

read_line(Fd, Index, Datas) ->
    case io:get_line(Fd, "") of 
    eof -> 
        ok = file:close(Index),
        ok = dets:close(?IP2S_DATA),
        ok;
    {error, Reason} ->
        io:format("Erreur: ~w", [Reason]),
        {stop, Reason};
    Data ->
        %io:format("~p ~n ~p ~n", [Data, string:tokens(string:substr(Data, 1, string:len(Data) -2), ";")]),
        {ok, Ipb, Tokens } = parse_line(Data),
        file:write(Index, Ipb),
        dets:insert_new(Datas, {Ipb, Tokens}),
        %io:format("line ~B : ~p\n", [Ipv, Tokens]),
        read_line(Fd, Index, Datas)
    end.

parse_line(Line) ->
    [Ip|Tokens] = lists:map(fun(Dirty) ->
            %io:format("~p~n", [Dirty]),
            case Dirty of
                "" -> "";
                "\n" -> "";
                _ -> string:substr(Dirty, 2, string:len(Dirty) -2)
            end
        end,
        re:split(string:substr(Line, 1, string:len(Line) -2), ";",[{return,list}])),
    {Ipv, _} = string:to_integer(Ip),
    Ipb = <<Ipv:32/unsigned-integer>>,
    {ok, Ipb, Tokens}.

-ifdef(TEST).
% [TODO] more complete unit test
parse_line_test() ->
    parse_line("\"3651660428\";\"FR\";\"France\";\"A8\";\"Ile-de-France\";\"Vincennes\";;\"48.85\";\"2.4333\";").
-endif.