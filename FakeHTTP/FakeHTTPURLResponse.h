#import <Foundation/Foundation.h>

@interface FakeHTTPURLResponse : NSURLResponse

@property (nonatomic, readonly) NSInteger statusCode;
@property (nonatomic, strong, readonly) NSDictionary *allHeaderFields;
@property (nonatomic, strong, readonly) NSData *body;

- (id)initWithStatusCode:(int)statusCode
                 headers:(NSDictionary *)headers
                    body:(NSData *)body;

@end
