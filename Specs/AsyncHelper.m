#import "AsyncHelper.h"

@implementation AsyncHelper

- (id)init {
    self = [super init];
    if (self) {
        self.pollingInterval = 0.01;
        self.timeout = 1.0;
    }
    return self;
}

- (void)runUntil:(checkBlock)block {
    NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:self.timeout];
    while ([[NSDate date] timeIntervalSinceDate:timeoutDate] < 0) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:self.pollingInterval]];
        if (block()) break;
    }
}

@end
