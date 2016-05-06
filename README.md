waterlily_pond
=====

Pools for monetdb driver (waterlily)

Build
-----

    $ rebar3 compile


Example
-------

    $ rebar3 shell
    $ waterlily_pond:start().
    $ waterlily_pond:query(<<"select * from query">>).
