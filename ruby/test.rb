require 'test/unit'
require 'ip2something'
require 'test/unit/ui/console/testrunner'

class Ip2SomethingTest < Test::Unit::TestCase
	def setup
		@idx = Ip2Something::Index.new
	end
	def test_read
		assert_equal "RD",  @idx.data(0).split('|')[0]
	end
	def test_search
		assert_equal 'RD', @idx.search('127.0.0.1')[:country_code]
	end
	def test_city
		assert_equal 'Vincennes', @idx.search('82.227.122.98')[:city]
		assert_equal 'Cupertino', @idx.search('17.251.200.70')[:city]
		
	end
end

Test::Unit::UI::Console::TestRunner.run(Ip2SomethingTest)
