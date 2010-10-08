import struct
import cStringIO

class Index(object):
	def __init__(self, path):
		self.path = path
	def parse(self, csv):
		index = open(self.path, 'w')
		index.write("    ")
		carte = cStringIO.StringIO()
		cpt = 0
		nidx = None
		for line in open(csv):
			cpt += 1
			if cpt == 1: continue
			key = struct.pack('L', long(line.split(';')[0][1:-1]))
			if cpt % 100 == 0:
				nidx = cpt // 100
				carte.write(key)
				carte.write(struct.pack('L', long(nidx)))
			index.write(key)
		map_poz = index.tell()
		index.write(carte.getvalue())
		index.seek(0)
		index.write(struct.pack('L', map_poz))
		index.close()

if __name__ == '__main__':
	idx = Index('ip.idx')
	idx.parse('ip_group_country.csv')