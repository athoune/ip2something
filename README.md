IP to something
===============

A simple python API to wrap [IPinfoDB data](http://ipinfodb.com/ip_database.php). It's just python, no mysql here.
On a core 2 duo mac, one query take 5ms.

Using it
--------

Download a CSV db from IPinfoDB. IP2Something use a lazy index, first time, it parses the csv file, other time, index is used.

	from ip2something import Index
	a = Index('ip', ''ip_group_country.csv')
	print a.search('207.97.227.239')