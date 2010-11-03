import sys
import os.path
import unittest

sys.path.insert(0, os.path.abspath('../src/'))
import ip2something

class TestIP(unittest.TestCase):
	def setUp(self):
		self.ip = ip2something.Index()
	def test_simple(self):
		self.assertEqual('Vincennes', self.ip.search('82.227.122.98')['city'])
		self.assertEqual('Cupertino', self.ip.search('17.251.200.70')['city'])
	def test_min(self):
		self.assertEqual('RD', self.ip.search('127.0.0.1')['country_code'])
	def test_private(self):
		self.assertEqual('RD', self.ip.search('192.168.1.1')['country_code'])
	#[TODO] managing extrema
	def _test_max(self):
		self.assertEqual('RD', self.ip.search('255.255.255.255')['country_code'])
if __name__ == '__main__':
	unittest.main()
