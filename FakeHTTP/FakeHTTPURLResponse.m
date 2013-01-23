#import "FakeHTTPURLResponse.h"

@interface FakeHTTPURLResponse ()

@property (nonatomic, readwrite) NSInteger statusCode;
@property (nonatomic, strong, readwrite) NSDictionary *allHeaderFields;
@property (nonatomic, strong, readwrite) NSData *body;

@end

@implementation FakeHTTPURLResponse

- (id)initWithStatusCode:(int)statusCode headers:(NSDictionary *)headers body:(NSData *)body {
    if ((self = [super initWithURL:[NSURL URLWithString:@"http://www.example.com"] MIMEType:@"text/plain" expectedContentLength:-1 textEncodingName:nil])) {
        self.statusCode = statusCode;
        self.allHeaderFields = headers;
        self.body = body;
    }
    return self;
}

@end