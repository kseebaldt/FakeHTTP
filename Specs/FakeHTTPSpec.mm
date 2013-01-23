#import "FakeHTTP.h"
#import "FakeHTTPURLProtocol.h"
#import "AsyncHelper.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(FakeHTTPSpec)

describe(@"FakeHTTP", ^{
    __block NSOperationQueue *queue;
    __block AsyncHelper *asyncHelper;
    
    beforeEach(^{
        queue = [[NSOperationQueue alloc] init];
        asyncHelper = [[AsyncHelper alloc] init];
        [FakeHTTP startMocking];
    });
    
    describe(@"mocking web requests", ^{
        __block NSURL *url;
        __block NSData *data;
        
        beforeEach(^{
            url = [NSURL URLWithString:@"http://example.com/foo"];
            data = [@"hello" dataUsingEncoding:NSUTF8StringEncoding];
            FakeHTTPURLResponse *response = [[FakeHTTPURLResponse alloc] initWithStatusCode:200 headers:nil body:data];
            
            [FakeHTTP registerURL:url withResponse:response];
        });
        
        it(@"should return the registered response", ^{
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            __block NSData *responseData = nil;

            [NSURLConnection sendAsynchronousRequest:request
                                               queue:queue
                                   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                responseData = data;
            }];
            [asyncHelper runUntil:^BOOL{
                return responseData != nil;
            }];
            responseData should equal(data);
        });
    });
    
    describe(@"making a request that is not registered", ^{
        __block NSURL *url;
        
        beforeEach(^{
            url = [NSURL URLWithString:@"http://example.com/foo"];
        });
        
        it(@"should fail", ^{
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            __block NSError *responseError = nil;
            
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:queue
                                   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                       responseError = error;
                                   }];
            [asyncHelper runUntil:^BOOL{
                return responseError != nil;
            }];
            responseError.domain should equal(@"FakeHTTP");
            [responseError.userInfo objectForKey:@"URL"] should equal(url);
        });
    });
});

SPEC_END
