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
    NSLog(@"%@", folder);
    return self;
}
-(NSDictionary *) search:(NSString *) ip {
    return [NSDictionary new];
}
@end
