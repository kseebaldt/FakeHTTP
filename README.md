Simple HTTP Mocking for iOS

# Start mocking HTTP connections
    [FakeHTTP startMocking];

# Mock a request for a URL
    NSURL *url = [NSURL URLWithString:@"http://example.com/foo"];
    NSData *bodyData = [@"hello" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *headers = [NSDictionary dictionaryWithObject:@"bar" forKey:@"foo"];
    FakeHTTPURLResponse *response = [[FakeHTTPURLResponse alloc] initWithStatusCode:200 headers:headers body:data];
            
    [FakeHTTP registerURL:url withResponse:response];

