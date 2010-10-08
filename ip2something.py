import struct
import cStringIO
import socket
import cPickle as pickle

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
			cpt += 1
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
						#print struct.unpack('!L', kk)[0]
						break
				break

if __name__ == '__main__':
	idx = Index('ip')
	idx.parse('ip_group_country.csv')
	for a in range(10):
		idx.search('213.41.120.195')