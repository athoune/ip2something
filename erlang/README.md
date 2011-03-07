IP to something, the Erlang way
===============================

Build it
--------

	./rebar compile eunit
	sudo ./rebar install

You can use it inplace, with _erl -pa ebin/_, if you don't wont to install.

Index it
--------

	ip2s_csv_reader:read_csv("../ip_group_city.csv").

For now, it's a turtle speed indexing, more than 30 minutes.
Index weight is more than 500Mo.

Use it
------

	application:start(ip2something).
	ip2s_index:search("193.180.168.20").

It's the ip of _erlang.org_ :

	{ok,{ip2s_city,"SE","Sweden","26","Stockholms Lan", "Stockholm",[],59.3333,18.05,[]}}

It's a record defined in _ip2something.hrl_

Features
--------

 * √ Index
 * √ Search
 * _ Indexation with a simple command line
 * _ Application parameters

Changelog
---------

 * **0.1** Index and search