-module(waterlily_pond).

-behaviour(application).

%% API exports
-export([ start/0
        , start/2
        , stop/0
        , stop/1
        , query/1
        , prepare/1
        , execute/2
        ]).

%%====================================================================
%% API functions
%%====================================================================

start() ->
    application:start(?MODULE).

stop() ->
    application:stop(?MODULE).

start(_Type, _Args) ->
    supervisor:start_link({local, waterlily_pond_sup}, waterlily_pond_sup, []).

stop(_) ->
    ok.

query(Q) ->
    poolboy:transaction(monet_pool, fun(Worker) ->
                                        gen_server:call(Worker, {query, Q})
                                    end).
prepare(P) ->
    poolboy:transaction(monet_pool, fun(Worker) ->
                                        gen_server:call(Worker, {prepare, P})
                                    end).

execute(QID, Params) ->
    poolboy:transaction(monet_pool, fun(Worker) ->
                                        gen_server:call(Worker, 
                                                        {execute, QID, Params})
                                    end).
%%====================================================================
%% Internal functions
%%====================================================================
