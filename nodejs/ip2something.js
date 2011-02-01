var BinaryParser = require('./binary_parser'),
	util = require('util'),
//	process = require('process'),
	fs = require('fs');

var Index = function(folder) {
	var f = fs.realpathSync(folder || process.env['HOME'] + '/.ip2something');
	this.keys = fs.openSync(f+"/ip.keys", 'r');
	this.datas = fs.openSync(f+"/ip.data", 'r');
};

Index.prototype.key = function(poz) {
	
}

Index.prototype.data = function(poz) {

}


var i = new Index();