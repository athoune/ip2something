import struct
import cStringIO
import socket
import cPickle as pickle
import dbm
import os.path
import csv

class Array(object):
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

class Index(object):
	def __init__(self, path):
		self.path = path
		self.step = 150
	def parse(self, csv):
		index = open('%s.idx' % self.path, 'w')
		index.write(" " * 4)
		data = open('%s.data' % self.path, 'w')
		data.write(" " * 4)
		data_map = cStringIO.StringIO()
		carte = cStringIO.StringIO()
		cpt = 0
		nidx = None
		for line in open(csv):
			cpt += 1
			if cpt == 1: continue
			datas = line.split(';')
			dd = pickle.dumps(datas)
			data.write(dd)
			data_map.write(struct.pack('!L', len(dd)))
			key = struct.pack('!L', long(datas[0][1:-1]))
			if cpt % self.step == 0:
				nidx = cpt // self.step
				carte.write(key)
			index.write(key)
		map_poz = index.tell()
		print "map", map_poz
		index.write(carte.getvalue())
		index.seek(0)
		index.write(struct.pack('!L', map_poz))
		index.close()
		data_poz = data.tell()
		data.write(data_map.getvalue())
		data.seek(0)
		data.write(struct.pack('!L', data_poz))
		data.close()
	def search(self, ip):
		key = socket.inet_aton(ip)
		f = open('%s.idx' % self.path, 'r')
		carte = struct.unpack('!L', f.read(4))[0]
		#print "carte", carte
		f.seek(carte)
		cpt = 0
		while True:
			k = f.read(4)
			if k == "" or None: break
			if k > key:
				k = struct.unpack('!L', k)[0]
				#print k, cpt, struct.unpack('!L', key)[0]
				f.seek(0)
				f.seek(cpt * self.step)
				cc = 0
				while True:
					kk = f.read(4)
					if kk > key:
						print cpt, cc, struct.unpack('!L', kk)[0], (cpt-1) * self.step + cc
						break
					cc += 1
				break
			cpt += 1

if __name__ == '__main__':
	a = Array('ip', 'ip_group_country.csv')
	for b in range(1):
		for ip in ['17.149.160.31', '213.41.120.195', '184.73.76.248', '88.191.52.43']:
			print "%s is in block " % ip, 
			bloc = a.search(ip)
			print bloc
