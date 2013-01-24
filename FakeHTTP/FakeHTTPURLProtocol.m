#import "FakeHTTPURLProtocol.h"
#import "FakeHTTPURLResponse.h"
#import "FakeHTTP.h"

@implementation FakeHTTPURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    return [[[request URL] scheme]  isEqualToString:@"http"];
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    return NO;
}

- (void)startLoading {
    FakeHTTPURLResponse *response = [FakeHTTP responseForURL:self.request.URL];
    if (response) {
        NSHTTPURLResponse *urlResponse = [[NSHTTPURLResponse alloc] initWithURL:self.request.URL
                                                                     statusCode:response.statusCode
                                                                    HTTPVersion:@"1.1"                                                                   headerFields:response.headers];
        [self.client URLProtocol:self
              didReceiveResponse:urlResponse
              cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        
        if (response.body) {
            [self.client URLProtocol:self didLoadData:response.body];
        }
        if (response.error) {
            [self.client URLProtocol:self didFailWithError:response.error];
        } else {
            [self.client URLProtocolDidFinishLoading:self];            
        }
    } else {
        NSString *message = [NSString stringWithFormat:@"Request for URL: %@ not registered", self.request.URL];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:message, NSLocalizedDescriptionKey, self.request.URL, @"URL", nil];
        NSError *error = [NSError errorWithDomain:@"FakeHTTP" code:1 userInfo:userInfo];
        [self.client URLProtocol:self didFailWithError:error];
    }
}

- (void)stopLoading {
    
}

@end
