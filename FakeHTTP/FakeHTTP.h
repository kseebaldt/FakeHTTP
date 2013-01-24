#import "FakeHTTPURLResponse.h"

@interface FakeHTTP : NSObject

+ (void)startMocking;
+ (void)stopMocking;

+ (void)registerURL:(NSURL *)url withResponse:(FakeHTTPURLResponse *)response;
+ (FakeHTTPURLResponse *)responseForURL:(NSURL *)url;
+ (void)reset;

@end
