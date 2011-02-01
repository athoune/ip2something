/*
encoding stolen from https://github.com/danielgtaylor/qtfaststart.js/blob/master/qtfaststart.js
*/

var util = require('util'),
//	process = require('process'),
	fs = require('fs');

var Index = function(folder) {
	var f = fs.realpathSync(folder || process.env['HOME'] + '/.ip2something');
	this.keys = fs.openSync(f+"/ip.keys", 'r');
	this.datas = fs.openSync(f+"/ip.data", 'r');
};

Index.prototype.key = function(poz, cb) {
	var buffer = new Buffer(4);
	var idx = this;
	fs.read(this.keys, buffer, 0, 4, poz*10, function(err, data) {
		if (err) throw err;
		cb.call(idx, buffer);
	});
};

/*
    Make a string method for converting a four character string into a big
    endian 32-bit unsigned integer.
*/
Buffer.prototype.asUInt32BE = function() {
	return (this[0] << 24) + (this[1] << 16) + (this[2] << 8) + this[3];
};

Buffer.prototype.asShortBE = function() {
	return  (this[0] << 8) + this[1];
};

Index.prototype.data = function(poz, cb) {
	/*self.keys.seek(poz * 10 + 4)
	poz, size = struct.unpack('!LH', self.keys.read(6))
	self.datas.seek(poz)
	return self.datas.read(size)*/
	var idx = this;
	var buffer = new Buffer(6);
	fs.read(this.keys, buffer, 0, 6, poz*10+4, function(err, data) {
		if (err) throw err;
		var dataPoz = buffer.slice(0,4).asUInt32BE();
		var dataSize = buffer.slice(4,6).asShortBE();
		var dataBuffer = new Buffer(dataSize);
		fs.read(idx.datas, dataBuffer, 0, dataSize, dataPoz, function(err, data) {
			cb.call(idx, dataBuffer.toString('utf8'));
		});
	});
};


var i = new Index();

i.data(43, function(data) {
	console.log(data);
});