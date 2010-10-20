IP to something
===============

A simple python API to wrap [IPinfoDB data](http://ipinfodb.com/ip_database.php). It's just python, no mysql here.
On a core 2 duo mac, one query take 0.15ms.

Using it
--------

Download a CSV db from IPinfoDB. IP2Something use a lazy index, first time, it parses the csv file, other time, index is used.

	from ip2something import Index
	a = Index('ip', ''ip_group_country.csv')
	print a.search('207.97.227.239')


How it works
------------

This code is pedagogical and use plain old technology.

### Specific
Db is designed to handle multiple case. IP search is very specific, the data are immuable, sorted, with a fixed length.

### Bits
Data are stored and manipulated as bits.

### No database
I like to use dbm (no relational database) with python. But macpython is just the hobo of dbm.
Out of the box, there is no berkeley db, no tokyo/kyoto tyrant, and finally, the classical ndbm is just a piece of crap, it crash when I try to feed it with 300Mo of data.

### Hard drive
You can use file on hard drive to store data, what a revolution. The secret weapon of hardrive is seek. You don't have to read all the book, you can directly go to a page.

### Index
Just like every database, index is the secret of speed. The index format is simple.
4 bytes to store IP, 4 bytes for data position, 2 bytes for data size. Index size is 10 x number of IP.

### Dichotomic search
IP are sorted, so [dichotomic search](http://en.wikipedia.org/wiki/Dichotomic_search) can be used. In my test, 15 step is used to find an IP in 196290 IPs.