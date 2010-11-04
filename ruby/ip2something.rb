module Ip2Something
	class Index
		def initialize path='~/.ip2something'
			folder = File.expand_path(path)
			@keys = File.new("#{folder}/ip.keys", 'r')
			@datas = File.new("#{folder}/ip.data", 'r')
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
	end
end

=begin
self.keys.seek(poz * 10 + 4)
poz, size = struct.unpack('!LH', self.keys.read(6))
self.datas.seek(poz)
return self.datas.read(size)

=end