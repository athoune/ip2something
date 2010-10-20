import struct
import socket
import os
import os.path
import csv

class Index(object):
	def __init__(self, src, cache = '~/.ip2something'):
		self.folder = os.path.expanduser(cache)
		self.src = src
		data = os.path.join(self.folder, 'ip.data')
		if not os.path.isfile(data):
			self.parse()
		key = os.path.join(self.folder, 'ip.keys')
		self.length = os.path.getsize(key) / 10
		self.keys = open(key, 'r')
		self.datas = open(data, 'r')
	def parse(self):
		if not os.path.exists(self.folder) : os.makedirs(self.folder)
		keys = open(os.path.join(self.folder, 'ip.keys'), 'w')
		datas = open(os.path.join(self.folder, 'ip.data'), 'w')
		cpt = 0
		for line in csv.reader(open(self.src, 'rb'), delimiter=';', quotechar='"'):
			cpt += 1
			if cpt == 1 : continue
			key = struct.pack('!L', long(line[0]))
			keys.write(key)
			data = '|'.join(line[1:])
			keys.write(struct.pack('!L', long(datas.tell())))
			keys.write(struct.pack('!H', len(data)))
			datas.write(data)
		print "indexing %i lines" % cpt
		keys.close()
		datas.close()
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
	def search(self, ip):
		k = socket.inet_aton(ip)
		cpt = 0
		high = self.length
		low = 0
		while True:
			cpt += 1
			pif = (high+low) / 2
			if self.getKey(pif) == k or (pif > 1 and self.getKey(pif-1) < k and self.getKey(pif) > k):
				return socket.inet_ntoa(self.getKey(pif-1)), self.getData(pif-1)
			if self.getKey(pif) > k :
				high = pif
			else:
				low = pif

if __name__ == '__main__':
	a = Index('ip_group_city.csv')
	for b in range(1):
		for ip in ['17.149.160.31', '213.41.120.195', '184.73.76.248', '88.191.52.43']:
			print "%s is in block " % ip, 
			bloc = a.search(ip)
			print bloc
