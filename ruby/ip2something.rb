module Ip2Something
	class Index
		def initialize path='~/.ip2something'
			folder = File.expand_path(path)
			@keys = File.new("#{folder}/ip.keys", 'r')
			@datas = File.new("#{folder}/ip.data", 'r')
		end
	end
end

Ip2Something::Index.new