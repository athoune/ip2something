//
//  ip2something.m
//  ip2something
//
//  Created by Mathieu on 05/11/10.
//  Copyright 2010 garambrogne.net. All rights reserved.
//

#import "ip2something.h"


@implementation Ip2something
-(id) init {
    return [self initWithPath: @"~/.ip2something"];
}

-(id) initWithPath: (NSString *) path {
    folder = [path stringByExpandingTildeInPath];
    NSLog(@"ip db is here : %@", folder);
    NSLog(@"%@", [NSString stringWithFormat: @"%@/ip.keys", folder]);
    datas = [NSFileHandle fileHandleForReadingAtPath: [NSString stringWithFormat: @"%@/ip.data", folder]];
    keys = [NSFileHandle fileHandleForReadingAtPath: [NSString stringWithFormat: @"%@/ip.keys", folder]];
    return self;
}

-(NSData *) getKey:(unsigned long) poz {
    [keys seekToFileOffset: poz * 10l];
    return [keys readDataOfLength: 4];
}
-(NSDictionary *) search:(NSString *) ip {
    return [NSDictionary new];
}
@end
