#import <Foundation/Foundation.h>

typedef BOOL(^checkBlock)();

@interface AsyncHelper : NSObject

@property (assign, nonatomic) NSTimeInterval pollingInterval;
@property (assign, nonatomic) NSTimeInterval timeout;

- (void)runUntil:(checkBlock)block;

@end
