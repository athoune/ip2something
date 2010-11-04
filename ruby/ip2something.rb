module Ip2Something
	class Index
		def initialize path='~/.ip2something'
			folder = File.expand_path(path)
			@keys = File.new("#{folder}/ip.keys", 'r')
			@datas = File.new("#{folder}/ip.data", 'r')
		end
		def key poz
			@keys.seek poz*10
			@keys.read 4
		end
		def data poz
		end
	end
end

=begin
self.keys.seek(poz * 10)
return self.keys.read(4)

=end