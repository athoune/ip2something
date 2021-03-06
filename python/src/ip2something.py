# -*- coding: utf-8 -*-

__author__ = "Mathieu Lecarme <mathieu@garambrogne.net>"

import struct
import socket
import os
import os.path
import csv

def float_or_none(f):
	if f in ['', None]:
		return None
	return float(f)

def parse_csv(src, db = '~/.ip2something', verbose = False):
	folder = os.path.expanduser(db)
	if not os.path.exists(folder) : os.makedirs(folder)
	keys = open(os.path.join(folder, 'ip.keys'), 'w')
	datas = open(os.path.join(folder, 'ip.data'), 'w')
	cpt = 0
	for line in csv.reader(open(src, 'rb'), delimiter=';', quotechar='"'):
		cpt += 1
		if cpt == 1 : continue
		key = struct.pack('!L', long(line[0]))
		keys.write(key)
		data = '|'.join(line[1:])
		keys.write(struct.pack('!L', long(datas.tell())))
		keys.write(struct.pack('!H', len(data)))
		datas.write(data)
		if verbose and cpt % 25000 == 0:
			print "#", cpt
	print "indexing %i lines" % cpt
	keys.close()
	datas.close()

class Index(object):
	def __init__(self, cache = '~/.ip2something'):
		self.folder = os.path.expanduser(cache)
		data = os.path.join(self.folder, 'ip.data')
		key = os.path.join(self.folder, 'ip.keys')
		self.length = os.path.getsize(key) / 10
		self.keys = open(key, 'r')
		self.datas = open(data, 'r')
	def __len__(self):
		return self.length
	def getKey(self, poz):
		self.keys.seek(poz * 10)
		return self.keys.read(4)
	def getData(self, poz):
		self.keys.seek(poz * 10 + 4)
		poz, size = struct.unpack('!LH', self.keys.read(6))
		self.datas.seek(poz)
		return self.datas.read(size)
	def _toDict(self, datas):
		if len(datas) == 9:
			return {
				'country_code' : datas[0],
				'country_name' : datas[1],
				'region_code'  : datas[2],
				'region_name'  : datas[3],
				'city'         : datas[4],
				'zipcode'      : datas[5],
				'latitude'     : float_or_none(datas[6]),
				'longitude'    : float_or_none(datas[7]),
				'metrocode'    : datas[8]
			}
		return len(datas), datas
	def search(self, ip):
		k = socket.inet_aton(ip)
		cpt = 0
		high = self.length
		low = 0
		while True:
			cpt += 1
			pif = (high+low) / 2
			v = self.getKey(pif)
			if v == k or (pif > 1 and self.getKey(pif-1) < k and v > k):
				return self._toDict(self.getData(pif-1).split('|')) #socket.inet_ntoa(self.getKey(pif-1))
			if self.getKey(pif) > k :
				high = pif
			else:
				low = pif

if __name__ == '__main__':
	a = Index()
	for b in range(1):
		for ip in ['17.149.160.31', '213.41.120.195', '184.73.76.248', '88.191.52.43']:
			print "%s is in block " % ip, 
			bloc = a.search(ip)
			print bloc
