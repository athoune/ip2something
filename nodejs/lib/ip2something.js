/*
encoding stolen from https://github.com/danielgtaylor/qtfaststart.js/blob/master/qtfaststart.js
*/

var util = require('util'),
	fs = require('fs');

/*
    Make a string method for converting a four character string into a big
    endian 32-bit unsigned integer.
*/
Buffer.prototype.asUInt32BE = function() {
	return (this[0] * Math.pow(2, 24)) + (this[1] << 16) + (this[2] << 8) + this[3];
};

Buffer.prototype.asShortBE = function() {
	return  (this[0] << 8) + this[1];
};

var Index = function(folder) {
	var f = fs.realpathSync(folder || process.env['HOME'] + '/.ip2something');
	this.keys = fs.openSync(f+"/ip.keys", 'r');
	this.datas = fs.openSync(f+"/ip.data", 'r');
	this.size = fs.statSync(f+"/ip.keys").size / 10;
};

exports.Index = Index;

Index.prototype.key = function(poz, cb) {
	var buffer = new Buffer(4);
	var idx = this;
	fs.read(this.keys, buffer, 0, 4, poz*10, function(err, data) {
		if (err) throw err;
		cb.call(idx, buffer.asUInt32BE());
	});
};

Index.prototype.data = function(poz, cb) {
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

Index.prototype.search = function(ip, cb) {
	var k = inetToInt(ip);
	var cpt = 0;
	var high = this.size;
	var low = 0;
	var idx = this;
	var reduce = function() {
		var pif = Math.round((high+low) / 2);
		idx.key(pif, function(v) {
			if( v == k ) {
				idx.data(pif-1, cb);
				return true;
			} 
			idx.key(pif - 1, function(vbefore) {
				//console.log(vbefore, k, v);
				if((vbefore < k) && (v > k)) {
					idx.data(pif-1, cb);
					return true;
				}
				if( v > k) {
					high = pif;
				} else {
					low = pif;
				}
				if(pif > 1) reduce();
			});
		});
	};
	reduce();
};

var inetToInt = function(ip) {
	var total = 0;
	var cpt = 3;
	ip.split('.').forEach(function(block) {
			total += parseInt(block, 10) * Math.pow(2, 8 * cpt--);
	});
	return total;
};

//lazy test

var i = new Index();

/*i.data(152, function(data) {
	console.log(data);
});*/

//console.log(inetToInt('17.149.160.31'));
//, '213.41.120.195', '184.73.76.248', 
/*
['17.149.160.31', '213.41.120.195', '184.73.76.248', '88.191.52.43'].forEach(function(ip) {
	i.search(ip, function(data){
		console.log(data);
	});	
});
*/