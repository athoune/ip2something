var BinaryParser = require('./binary_parser'),
	util = require('util'),
//	process = require('process'),
	fs = require('fs');

var Index = function(folder) {
	var f = fs.realpathSync(folder || process.env['HOME'] + '/.ip2something');
	this.keys = fs.openSync(f+"/ip.keys", 'r');
	this.datas = fs.openSync(f+"/ip.data", 'r');
};

Index.prototype.key = function(poz, cb) {
	//self.keys.seek(poz * 10)
	//return self.keys.read(4)
	var buffer = new Buffer(4);
	var i = this;
	fs.read(this.keys, buffer, 0, 4, poz*10, function(err, data) {
		if (err) throw err;
		cb.call(i, buffer);
	});
}

Index.prototype.data = function(poz) {

}


var i = new Index();
i.key(42, function(key) {
	console.log(key);
})