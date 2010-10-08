import struct
import cStringIO

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
			key = struct.pack('L', long(line.split(';')[0][1:-1]))
			if cpt % self.step == 0:
				nidx = cpt // self.step
				carte.write(key)
			index.write(key)
		map_poz = index.tell()
		print "map", map_poz
		index.write(carte.getvalue())
		index.seek(0)
		index.write(struct.pack('L', map_poz))
		index.close()
	def search(self, key):
		f = open(self.path, 'r')
		carte = struct.unpack('L', f.read(8))[0]
		print "carte", carte
		f.seek(carte)
		cpt = 0
		while True:
			cpt += 1
			k = f.read(8)
			if k == "" or None: break
			k = struct.unpack('L', k)[0]
			print k, cpt

if __name__ == '__main__':
	idx = Index('ip.idx')
	idx.parse('ip_group_country.csv')
	idx.search(42)