<?php
require 'class.ip2something.php';

class IpTest extends PHPUnit_Framework_TestCase {
	function setUp() {
		$this->ip = new IP2Something($_ENV['HOME'] . '/.ip2something');
	}
	public function testKey() {
		$d = explode('|', $this->ip->getData(0));
		$this->assertEquals('RD', $d[0]);
	}
	function testSimple() {
		$s = $this->ip->search('82.227.122.98');
		$this->assertEquals('Vincennes', $s['city']);
	}
}