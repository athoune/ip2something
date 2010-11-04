require 'test/unit'
require 'ip2something'
require 'test/unit/ui/console/testrunner'

class Ip2SomethingTest < Test::Unit::TestCase
	def setup
		@idx = Ip2Something::Index.new
	end
	def testread
		assert_equal "RD",  @idx.data(0).split('|')[0]
	end
end

Test::Unit::UI::Console::TestRunner.run(Ip2SomethingTest)
