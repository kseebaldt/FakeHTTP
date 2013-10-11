#import "FakeHTTPURLResponse.h"

@interface FakeHTTP : NSObject

+ (void)startMocking;
+ (void)stopMocking;

+ (NSArray *)requests;
+ (void)addRequest:(NSURLRequest *)request;
+ (NSURLRequest *)lastRequest;

+ (void)registerURL:(NSURL *)url withResponse:(FakeHTTPURLResponse *)response;
+ (void)registerURLPredicate:(NSPredicate *)predicate withResponse:(FakeHTTPURLResponse *)response;
+ (FakeHTTPURLResponse *)responseForURL:(NSURL *)url;
+ (void)reset;

@end
