var sys = require('sys'),
	Index = require('../lib/ip2something.js').Index;

exports.testSearch = function(test) {
	test.expect(0);
	var idx = new Index();
	['17.149.160.31', '213.41.120.195', '184.73.76.248', '88.191.52.43'].forEach(function(ip) {
		idx.search(ip, function(data){
			console.log(data);
		});	
	});
};
