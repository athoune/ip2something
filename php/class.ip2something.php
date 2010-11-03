<?php

/*
 http://fr.php.net/manual/en/function.pack.php
 http://fr.php.net/manual/en/function.ip2long.php
*/
class IP2Something {
	public function __construct($path) {
		$this->keys = fopen("$path/ip.keys", 'r');
		$this->datas = fopen("$path/ip.data", 'r');
		$this->length = filesize("$path/ip.keys") / 10;
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
	function search($ip) {
		$k = pack('N', ip2long($ip));
		$cpt = 0;
		$high = $this->length;
		$low = 0;
		while(true) {
			$cpt++;
			$pif = floor(($high + $low) / 2);
			$kpif = $this->getKey($pif);
			if($kpif == $k || ($pif > 1 && $this->getKey($pif-1) < $k && $kpif > $k )) {
				$datas = explode('|', $this->getData($pif-1));
				if(sizeof($datas) == 9) {
					return array(
					'country_code' => $datas[0],
					'country_name' => $datas[1],
					'region_code'  => $datas[2],
					'region_name'  => $datas[3],
					'city'         => $datas[4],
					'zipcode'      => $datas[5],
					'latitude'     => $datas[6],
					'longitude'    => $datas[7],
					'metrocode'    => $datas[8]
					);
				}
				return $datas;
			}
			if($kpif > $k) {
				$high = $pif;
			} else {
				$low = $pif;
			}
		}
		/*
		cpt = 0
		high = self.length
		low = 0
		while True:
			cpt += 1
			pif = (high+low) / 2
			#print pif
			if self.getKey(pif) == k or (pif > 1 and self.getKey(pif-1) < k and self.getKey(pif) > k):
				return self.toDict(self.getData(pif-1).split('|')) #socket.inet_ntoa(self.getKey(pif-1))
			if self.getKey(pif) > k :
				high = pif
			else:
				low = pif
		*/
	}
}
