#include <Foundation/Foundation.h>
#include "ip2something.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    Ip2something *idx = [[Ip2something alloc] init];
    NSLog(@"%@", [idx getKey: 2]);
    [pool release];
    return 0;
}
