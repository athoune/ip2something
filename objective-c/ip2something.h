//
//  ip2something.h
//  ip2something
//
//  Created by Mathieu on 05/11/10.
//  Copyright 2010 garambrogne.net. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Ip2something: NSObject {
    NSString *folder;
}
-(id) init;
-(id) initWithPath:(NSString *) path;

-(NSDictionary *) search:(NSString *) ip;

@end
