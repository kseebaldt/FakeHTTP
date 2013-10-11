#import "FakeHTTP.h"
#import "FakeHTTPURLProtocol.h"

static __strong NSMutableDictionary *__responseForURL;
static __strong NSMutableDictionary *__responseForPredicate;
static __strong NSMutableArray *__requests;

@implementation FakeHTTP

+ (void)startMocking {
    __responseForURL        = [NSMutableDictionary dictionary];
    __responseForPredicate  = [NSMutableDictionary dictionary];
    __requests              = [NSMutableArray array];
    [NSURLProtocol registerClass:[FakeHTTPURLProtocol class]];
}

+ (void)stopMocking {
    [NSURLProtocol unregisterClass:[FakeHTTPURLProtocol class]];
}

+ (NSArray *)requests {
    return __requests;
}

+ (void)addRequest:(NSURLRequest *)request {
    [__requests addObject:request];
}

+ (NSURLRequest *)lastRequest {
    return __requests.lastObject;
}

+ (void)registerURL:(NSURL *)url withResponse:(FakeHTTPURLResponse *)response {
    [__responseForURL setObject:response forKey:url];
}

+ (void)registerURLPredicate:(NSPredicate *)predicate withResponse:(FakeHTTPURLResponse *)response
{
    [__responseForPredicate setObject:response forKey:predicate];
}

+ (FakeHTTPURLResponse *)responseForURL:(NSURL *)url {
    if ( ![__responseForURL objectForKey:url] ) {
        for ( NSPredicate *predicate in __responseForPredicate ) {
            if ( [predicate evaluateWithObject:url.absoluteString] ) {
                return [__responseForPredicate objectForKey:predicate];
            }
        }
    } else {
        return [__responseForURL objectForKey:url];
    }

    return nil;
}

+ (void)reset {
    [__responseForURL removeAllObjects];
    [__responseForPredicate removeAllObjects];
    [__requests removeAllObjects];
}

@end
