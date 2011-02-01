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
	var buffer = new Buffer(4);
	var i = this;
	fs.read(this.keys, buffer, 0, 4, poz*10, function(err, data) {
		if (err) throw err;
		cb.call(i, buffer);
	});
}

Index.prototype.data = function(poz, cb) {
	/*self.keys.seek(poz * 10 + 4)
	poz, size = struct.unpack('!LH', self.keys.read(6))
	self.datas.seek(poz)
	return self.datas.read(size)*/
	var buffer = new Buffer(6);
	fs.read(this.keys, buffer, 0, 6, poz*10+4, function(err, data) {
		if (err) throw err;
		console.log(buffer.to_float());
	});
}


var i = new Index();
i.key(42, function(key) {
	console.log(key);
})

i.data(42);