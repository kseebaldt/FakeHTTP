#import <Foundation/Foundation.h>

@interface FakeHTTPURLResponse : NSObject

@property (nonatomic, readonly) NSInteger statusCode;
@property (nonatomic, strong, readonly) NSDictionary *headers;
@property (nonatomic, strong, readonly) NSData *body;
@property (nonatomic, strong, readonly) NSError *error;

- (id)initWithStatusCode:(int)statusCode
                 headers:(NSDictionary *)headers
                    body:(NSData *)body;

- (id)initWithStatusCode:(int)statusCode
                 headers:(NSDictionary *)headers
                    body:(NSData *)body
                   error:(NSError *)error;

@end
