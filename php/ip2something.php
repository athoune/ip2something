<?php

/*
 http://fr.php.net/manual/en/function.pack.php
 http://fr.php.net/manual/en/function.ip2long.php
*/
class IP2Something {
	function __construct($path) {
		$this->keys = fopen("$path/ip.keys", 'r');
		$this->datas = fopen("$path/ip.data", 'r');
	}
}

$ip = new IP2Something($_ENV['HOME'] . '/.ip2something');