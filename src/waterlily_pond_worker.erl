-module(waterlily_pond_worker).

-behaviour(gen_server).
-behaviour(poolboy_worker).

-export([start_link/1]).
-export([ init/1
        , handle_call/3
        , handle_cast/2
        , handle_info/2
        , terminate/2
        , code_change/3
        ]).

start_link(Args) ->
    gen_server:start_link(?MODULE, Args, []).

init(Args) ->
    process_flag(trap_exit, true),
    Host = proplists:get_value(host, Args),
    Port = proplists:get_value(port, Args),
    DB = proplists:get_value(database, Args),
    Username = proplists:get_value(username, Args),
    Password = proplists:get_value(password, Args),
    {ok, Pid} = waterlily:connect(Host, Port, DB, Username, Password),
    {ok, Pid}.

handle_call({query, Q}, _From, Pid) ->
    {reply, waterlily:query(Pid, Q), Pid};

handle_call({prepare, Q}, _From, Pid) ->
    Response = waterlily:prepare(Pid, Q),
    QueryId = waterlily:query_id(Response),
    {reply, QueryId, Pid};

handle_call({execute, QID, Params}, _From, Pid) ->
    {reply, waterlily:execute(Pid, QID, Params), Pid};

handle_call(_Requerst, _From, Pid) ->
    {reply, ok, Pid}.


handle_cast(_Msg, Pid) ->
    {noreply, Pid}.

handle_info(_Info, Pid) ->
    {noreply, Pid}.

terminate(_Reason, Pid) ->
    ok = gen_fsm:stop(Pid),
    ok.

code_change(_OldVsn, Pid, _Extra) ->
    {ok, Pid}.
