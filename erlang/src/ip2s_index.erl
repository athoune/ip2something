-module(ip2s_index).
-author("Mathieu Lecarme <mathieu@garambrogne.net>").

-behaviour(gen_server).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, 
         handle_info/2, terminate/2, code_change/3]).

-include("ip2something.hrl").

-record(state, {index, length, datas}).
-export([start_link/0, nth/1, length/0, search/1]).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

init([]) ->
    {ok, Index} = file:read_file("./index.db"),
    %put(index, Index),
    {ok, Datas} = dets:open_file(?IP2S_DATA, [
        {file,"./data.db"},
        {access, read}
        ]),
    {ok, #state{index=Index, length=round(size(Index) / 4), datas=Datas}}.

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%%--------------------------------------------------------------------
%% Func: code_change(OldVsn, State, Extra) -> {ok, NewState}
%% Description: Convert process state when code is changed
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%--------------------------------------------------------------------
%% Function: %% handle_call(Request, From, State) -> {reply, Reply, State} |
%%                                      {reply, Reply, State, Timeout} |
%%                                      {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, Reply, State} |
%%                                      {stop, Reason, State}
%% Description: Handling call messages
%%--------------------------------------------------------------------
handle_call({get, Position}, _From, #state{length=Length, index=Index} = State) ->
    case Position >= Length of
        true ->
            {reply, {error, out_of_bound}, State};
        false ->
            Ip = binary:part(Index, {Position*4, 4}),
            {reply, {ok, Ip}, State}
    end;

handle_call({length}, _From, #state{length=Length} = State) ->
    {reply, Length, State};

handle_call(Msg, From, State) ->
    io:format("~p~n~p~n", [Msg, From]),
    {reply, ok, State}.

handle_cast(Msg, State) ->
    io:format("~p~n", [Msg]),
    {noreply, State}.

handle_info(Msg, State) ->
    io:format("~p~n", [Msg]),
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

%%--------------------------------------------------------------------
%% API
%%--------------------------------------------------------------------


%% get the nth index
nth(Position) ->
    gen_server:call(?MODULE, {get, Position}).

%% size of the index
length() ->
    gen_server:call(?MODULE, {length}).

search(Ip) ->
    Key = ip2s_convert:ip_to_bin(Ip),
%    case dets:lookup(?IP2S_DATA, Key) of
%        [Data] -> {ok, Data};
%        [] -> 
            dicho(Key, 0, length()).
%    end.

dicho(Key, Low, High) ->
    Pif = round((High+Low)/2),
    {ok, V } = nth(Pif),
    {ok, Vb} = nth(Pif-1),
    %io:format("~p ~p ~p ~p ~p ~p~n", [V > Key, Key, V, Low, High, Pif]),
    if 
        (V == Key) or ((Pif > 1) and (Vb < Key) and (V > Key)) ->
            [{_Key, Ip2s_data}] = dets:lookup(?IP2S_DATA, Vb),
            {ok, format_data(Ip2s_data)};
        High == Low ->
            {error, bad_loop};
        true ->
            if
                V > Key -> dicho(Key, Low, Pif);
                true -> dicho(Key, Pif, High)
            end
    end.

float_or_none(St) when St == "" -> St;
float_or_none(St) -> 
    {F, _} = string:to_float(St),
    case F of
        error -> [];
        _ -> F
    end.

format_data(Data) ->
    io:format("~p~n", [Data]),
    case length(Data) of
        9 -> Metrocode = lists:nth(9, Data);
        _ -> Metrocode = ""
    end,
    #ip2s_city{
        country_code = lists:nth(1, Data),
        country_name = lists:nth(2, Data),
        region_code  = lists:nth(3, Data),
        region_name  = lists:nth(4, Data),
        city         = lists:nth(5, Data),
        zipcode      = lists:nth(6, Data),
        latitude     = float_or_none(lists:nth(7, Data)),
        longitude    = float_or_none(lists:nth(8, Data)),
        metrocode    = Metrocode
    }.

-ifdef(EUNIT).
    % get_test() ->
    %     start_link(),
    %     {ok, _} = nth(42),
    %     {ok, _} = nth(length()-1),
    %     {error, _} = nth(length()).
-endif.