#import <Cedar/Cedar.h>
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
        __block NSDictionary *headers;
        __block NSHTTPURLResponse *httpResponse = nil;
        __block NSData *responseData = nil;
        __block NSString *urlStr = @"http://example.com/foo";
        __block FakeHTTPURLResponse *response;

        beforeEach(^{
            url = [NSURL URLWithString:urlStr];
            data = [@"hello" dataUsingEncoding:NSUTF8StringEncoding];
            headers = [NSDictionary dictionaryWithObject:@"bar" forKey:@"foo"];
            response = [[FakeHTTPURLResponse alloc] initWithStatusCode:200 headers:headers body:data];
        });

        describe(@"by matching on an exact URL", ^{
            beforeEach(^{
                [FakeHTTP registerURL:url withResponse:response];

                NSURLRequest *request = [NSURLRequest requestWithURL:url];

                [NSURLConnection sendAsynchronousRequest:request
                                                   queue:queue
                                       completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                           httpResponse = (NSHTTPURLResponse *)response;
                                           responseData = data;
                                       }];
                [asyncHelper runUntil:^BOOL{
                    return responseData != nil;
                }];
            });

            it(@"should return the registered response", ^{
                responseData should equal(data);
                httpResponse.statusCode should equal(200);
                httpResponse.allHeaderFields should equal(headers);
            });

            it(@"provides access to the request", ^{
                FakeHTTP.requests.count should equal(1);
                FakeHTTP.lastRequest.URL.absoluteString should equal(urlStr);
            });
        });

        describe(@"by matching using a predicate", ^{
            beforeEach(^{
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"example.com"];
                [FakeHTTP registerURLPredicate:predicate withResponse:response];

                NSURLRequest *request = [NSURLRequest requestWithURL:url];

                [NSURLConnection sendAsynchronousRequest:request
                                                   queue:queue
                                       completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                           httpResponse = (NSHTTPURLResponse *)response;
                                           responseData = data;
                                       }];
                [asyncHelper runUntil:^BOOL{
                    return responseData != nil;
                }];
            });

            it(@"should return the registered response", ^{
                responseData should equal(data);
                httpResponse.statusCode should equal(200);
                httpResponse.allHeaderFields should equal(headers);
            });
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
