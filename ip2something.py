import struct
import socket
import dbm
import os.path
import csv

class Index(object):
	def __init__(self, name, src):
		self.name = name
		self.src = src
		self._keys()
	def _keys(self):
		self.length = os.path.getsize('%s.keys' % self.name) / 4
		self.keys = open('%s.keys' % self.name, 'r')
		if os.path.isfile('%s.db' % self.name):
			self.dbm = dbm.open(self.name, 'r')
		else:
			self.parse()
	def parse(self):
		keys = open('%s.keys' % self.name, 'w')
		db = dbm.open(self.name, 'c')
		cpt = 0
		for line in csv.reader(open(self.src, 'rb'), delimiter=';', quotechar='"'):
			cpt += 1
			if cpt == 1 : continue
			key = struct.pack('!L', long(line[0]))
			keys.write(key)
			db[key] = '|'.join(line[1:])
		print "indexing %i lines" % cpt
		keys.close()
		db.close()
		self._keys()
	def __len__(self):
		return self.length
	def __getitem__(self, poz):
		self.keys.seek(poz * 4)
		return self.keys.read(4)
	def search(self, ip):
		k = socket.inet_aton(ip)
		cpt = 0
		high = self.length
		low = 0
		while True:
			cpt += 1
			pif = (high+low) / 2
			if self[pif] == k or (pif > 1 and self[pif-1] < k and self[pif] > k):
				return socket.inet_ntoa(self[pif-1]), self.dbm[self[pif-1]]
			if self[pif] > k :
				high = pif
			else:
				low = pif

if __name__ == '__main__':
	a = Index('ip', 'ip_group_city.csv')
	for b in range(1):
		for ip in ['17.149.160.31', '213.41.120.195', '184.73.76.248', '88.191.52.43']:
			print "%s is in block " % ip, 
			bloc = a.search(ip)
			print bloc
