-module(waterlily_pond_sup).
-behaviour(supervisor).

-export([init/1]).

init([]) ->
    {ok, [Pool]} = application:get_env(waterlily_pond, pools),
    {Name, SizeArgs, WorkerArgs} = Pool,
    PoolArgs = [{name, {local, Name}}
               ,{worker_module, waterlily_pond_worker}] ++ SizeArgs,
    PoolSpec = poolboy:child_spec(Name, PoolArgs, WorkerArgs),
    {ok , {{one_for_one, 10, 10}, [PoolSpec]}}.
