var sys = require('sys'),
	Index = require('../lib/ip2something.js').Index;

var idx = new Index();

var stdin = process.openStdin();

stdin.setEncoding('utf8');


var tmp = "";

stdin.on('data', function (chunk) {
	tmp += chunk;
	var lines = tmp.split("\n");
	if(lines.length > 1) {
		tmp = lines.pop();
		lines.forEach(function(line) {
			//console.log(line);
			idx.search(line, function(data){
				console.log(data);
			});
		});
	}
});

stdin.on('end', function () {
  //process.stdout.write('end');
});