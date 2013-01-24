#import "FakeHTTPURLResponse.h"

@interface FakeHTTPURLResponse ()

@property (nonatomic, readwrite) NSInteger statusCode;
@property (nonatomic, strong, readwrite) NSDictionary *headers;
@property (nonatomic, strong, readwrite) NSData *body;
@property (nonatomic, strong, readwrite) NSError *error;

@end

@implementation FakeHTTPURLResponse

- (id)initWithStatusCode:(int)statusCode headers:(NSDictionary *)headers body:(NSData *)body {
    return [self initWithStatusCode:statusCode headers:headers body:body error:nil];
}


- (id)initWithStatusCode:(int)statusCode
                 headers:(NSDictionary *)headers
                    body:(NSData *)body
                   error:(NSError *)error {
    self = [super init];
    if (self) {
        self.statusCode = statusCode;
        self.headers = headers;
        self.body = body;
        self.error = error;
    }
    return self;
}

@end