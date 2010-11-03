<?php

/*
 http://fr.php.net/manual/en/function.pack.php
 http://fr.php.net/manual/en/function.ip2long.php
*/
class IP2Something {
	public function __construct($path) {
		$this->keys = fopen("$path/ip.keys", 'r');
		$this->datas = fopen("$path/ip.data", 'r');
	}
	function getKey($poz) {
		fseek($this->keys, $poz * 10);
		return fread($this->keys, 4);
	}
	function getData($poz) {
		fseek($this->keys, $poz * 10 + 4);
		$values = unpack('Npoz/nsize', fread($this->keys, 6));
		fseek($this->datas, $values['poz']);
		return fread($this->datas, $values['size']);
	}
}
