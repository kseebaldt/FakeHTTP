#import <Cedar/Cedar.h>
#import "FakeHTTPURLProtocol.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(FakeHTTPURLProtocolSpec)

describe(@"FakeHTTPURLProtocol", ^{
    describe(@"canInitWithRequest:", ^{
        __block NSURLRequest *request;
        
        context(@"with a http request", ^{
            beforeEach(^{
                NSURL *url = [NSURL URLWithString:@"http://example.com"];
                request = [[NSURLRequest alloc] initWithURL:url];
            });
            
            it(@"can init request", ^{
                [FakeHTTPURLProtocol canInitWithRequest:request] should be_truthy;
            });
        });
        
        context(@"with a non http request", ^{
            beforeEach(^{
                NSURL *url = [NSURL URLWithString:@"ftp://example.com"];
                request = [[NSURLRequest alloc] initWithURL:url];
            });
            
            it(@"can init request", ^{
                [FakeHTTPURLProtocol canInitWithRequest:request] should_not be_truthy;
            });
        });
    });
});

SPEC_END
