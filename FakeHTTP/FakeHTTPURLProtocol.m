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


- (void)startLoading {
    FakeHTTPURLResponse *response = [FakeHTTP responseForURL:self.request.URL];
    if (response) {
        [self.client URLProtocol:self
              didReceiveResponse:response
              cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        
        [self.client URLProtocol:self didLoadData:response.body];
        [self.client URLProtocolDidFinishLoading:self];
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
