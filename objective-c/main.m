#include <Foundation/Foundation.h>
#include "ip2something.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    Ip2something *idx = [[Ip2something alloc] init];
    NSLog(@" %@", [idx dataAtIndex: 2470079]);
    NSLog(@"ip as int : %@", [NSNumber numberWithInt:[idx keyAtIndex: 1]]);
    //[idx search: @"17.251.200.70"];
    [idx search: @"17.149.160.31"];//Cupertino
    [pool release];
    return 0;
}
