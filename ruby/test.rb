require 'test/unit'
require 'ip2something'
require 'test/unit/ui/console/testrunner'

class Ip2SomethingTest < Test::Unit::TestCase
	def setup
		@idx = Ip2Something::Index.new
	end
end

Test::Unit::UI::Console::TestRunner.run(Ip2SomethingTest)