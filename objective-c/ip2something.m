//
//  ip2something.m
//  ip2something
//
//  Created by Mathieu on 05/11/10.
//  Copyright 2010 garambrogne.net. All rights reserved.
//

#import "ip2something.h"
//#include <sys/socket.h>
//#include <netinet/in.h>
//#include <arpa/inet.h>

@implementation Ip2something
-(id) init {
    return [self initWithPath: @"~/.ip2something"];
}

-(id) initWithPath: (NSString *) path {
    folder = [path stringByExpandingTildeInPath];
    NSLog(@"ip db is here : %@", folder);
    datas = [NSFileHandle fileHandleForReadingAtPath: [NSString stringWithFormat: @"%@/ip.data", folder]];
    NSString * k = [NSString stringWithFormat: @"%@/ip.keys", folder];
    keys = [NSFileHandle fileHandleForReadingAtPath: k];
    NSFileManager *man = [[NSFileManager alloc] init];
    NSDictionary *attrs = [man attributesOfItemAtPath: k error: NULL];
    length = [attrs fileSize] / 10;
    return self;
}

-(NSUInteger) keyAtIndex:(NSUInteger) n {
    [keys seekToFileOffset: n * 10];
    int poz;
    [[keys readDataOfLength: 4] getBytes:&poz length:4];
    poz = CFSwapInt32BigToHost(poz);
    return poz;
}

-(NSString *) dataAtIndex:(NSUInteger) n {
    [keys seekToFileOffset: n * 10 + 4];
    NSData * pozSize = [keys readDataOfLength:6];
    int poz;
    [pozSize getBytes:&poz length:4];
    short size;
    [pozSize getBytes:&size range:NSMakeRange(4,2)];
    [datas seekToFileOffset:CFSwapInt32BigToHost(poz)];
    return [[NSString alloc] initWithData:[datas readDataOfLength:CFSwapInt16BigToHost(size)] encoding:NSUTF8StringEncoding];
}

-(NSDictionary *) search:(NSString *) ip {
    NSArray * blocs = [ip componentsSeparatedByString:@"."];
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    int k = 0;
    for(int a=0 ;a < [blocs count]; a++) {
	k += [[f numberFromString: [blocs objectAtIndex:a]] intValue] << (8*(3-a));
    }
    [f release];
    k = CFSwapInt32BigToHost(k);
    //NSLog(@"%@", k);
    NSInteger high = length;
    NSInteger low = 0;
    NSInteger pif;
    NSInteger v;
    while(true) {
	pif = (high + low)/2;
	NSLog(@"pif : %@", [NSNumber numberWithInt:pif]);
	v = [self keyAtIndex:pif];
	//NSLog(@"%@", v);
	if( v == k || (pif > 1 && [self keyAtIndex:(pif-1)] < k && v > k)) {
	    NSLog(@"data %@", [self dataAtIndex:(pif-1)]);
	    return [NSDictionary new];
	}
	if([self keyAtIndex:pif] > k) {
	    high = pif;
	} else {
	    low = pif;
	}
    }
    /*struct sockaddr_in k;
    inet_aton([ip cStringUsingEncoding:NSUTF8StringEncoding], &k.sin_addr);
    NSLog(@"%@", [NSNumber numberWithInt: k.sin_addr ]);*/
}
@end
