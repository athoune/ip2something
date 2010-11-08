#include <Foundation/Foundation.h>
#include "ip2something.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    Ip2something *idx = [[Ip2something alloc] init];
    NSLog(@"%@", [idx getData: 1]);
    [idx search: @"17.251.200.70"];
    [pool release];
    return 0;
}
