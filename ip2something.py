import struct
import cStringIO
import socket

class Index(object):
	def __init__(self, path):
		self.path = path
		self.step = 150
	def parse(self, csv):
		index = open(self.path, 'w')
		index.write(" " * 8)
		carte = cStringIO.StringIO()
		cpt = 0
		nidx = None
		for line in open(csv):
			cpt += 1
			if cpt == 1: continue
			key = struct.pack('!L', long(line.split(';')[0][1:-1]))
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
	def search(self, ip):
		key = socket.inet_aton(ip)
		f = open(self.path, 'r')
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
	idx = Index('ip.idx')
	#idx.parse('ip_group_country.csv')
	for a in range(100):
		idx.search('213.41.120.195')