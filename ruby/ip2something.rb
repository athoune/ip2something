require 'ipaddr'

module Ip2Something
	class Index
		def initialize path='~/.ip2something'
			folder = File.expand_path(path)
			@keys = File.new("#{folder}/ip.keys", 'r')
			@datas = File.new("#{folder}/ip.data", 'r')
			@length = File.size("#{folder}/ip.keys") / 10
		end
		def key poz
			@keys.seek poz * 10
			@keys.read 4
		end
		def data poz
			@keys.seek poz * 10 + 4
			poz, size = @keys.read(6).unpack('Nn')
			@datas.seek poz
			@datas.read size
		end
		def search ip
			k = Array[IPAddr.new(ip).to_i].pack('N')
			high = @length
			low = 0
			while true:
				pif = (high+low) / 2
				if key(pif) == k or (pif > 1 and key(pif-1) < k and key(pif) > k)
					return data(pif -1).split('|')
				end
				if key(pif) > k
					high = pif
				else
					low = pif
				end
			end
		end
	end
end

=begin
k = socket.inet_aton(ip)
cpt = 0
high = self.length
low = 0
while True:
	cpt += 1
	pif = (high+low) / 2
	#print pif
	if self.getKey(pif) == k or (pif > 1 and self.getKey(pif-1) < k and self.getKey(pif) > k):
		return self.toDict(self.getData(pif-1).split('|')) #socket.inet_ntoa(self.getKey(pif-1))
	if self.getKey(pif) > k :
		high = pif
	else:
		low = pif

=end