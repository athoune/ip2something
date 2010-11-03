<?php
require 'class.ip2something.php';

class IpTest extends PHPUnit_Framework_TestCase {
	function setUp() {
		$this->ip = new IP2Something($_ENV['HOME'] . '/.ip2something');
	}
	public function testKey() {
		var_dump($this->ip->getKey(0));
		var_dump($this->ip->getData(0));
	}
}