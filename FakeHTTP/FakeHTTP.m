#import "FakeHTTP.h"
#import "FakeHTTPURLProtocol.h"

static __strong NSMutableDictionary *__responseForURL;

@implementation FakeHTTP

+ (void)startMocking {
    __responseForURL = [NSMutableDictionary dictionary];
    [NSURLProtocol registerClass:[FakeHTTPURLProtocol class]];
}

+ (void)stopMocking {
    [NSURLProtocol unregisterClass:[FakeHTTPURLProtocol class]];
}

+ (void)registerURL:(NSURL *)url withResponse:(FakeHTTPURLResponse *)response {
    [__responseForURL setObject:response forKey:url];
}

+ (FakeHTTPURLResponse *)responseForURL:(NSURL *)url {
    return [__responseForURL objectForKey:url];
}

@end
