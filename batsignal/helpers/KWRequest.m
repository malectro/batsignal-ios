//
//  KWRequest.m
//  Unison Brain
//
//  Created by Kyle Warren on 2/10/13.
//  Copyright (c) 2013 Kyle Warren. All rights reserved.
//

#import "KWRequest.h"

#import "Reachability.h"

#import "BSSession.h"

#ifdef DEBUG
#define kHostName @"http://localhost:3000"
#else
#define kHostName @"http://sygnal.herokuapp.com"
#endif

@interface KWRequest ()

@property (nonatomic) Reachability *reachable;
@property (nonatomic) NSOperationQueue *operationQueue;
@property (nonatomic) NSURL *baseUrl;

@end

@implementation KWRequest

+ (KWRequest *)kwr
{
    static KWRequest *requester = nil;
    
    if (requester == nil) {
        requester = [[KWRequest alloc] init];
    }
    
    return requester;
}

+ (void)get:(NSString *)path callback:(void (^)(id))handler
{
    [[self kwr] get:path callback:handler];
}

+ (void)post:(NSString *)path data:(NSDictionary *)dataDict callback:(void (^)(id))handler
{
    [[self kwr] post:path data:dataDict callback:handler];
}

+ (void)put:(NSString *)path data:(NSDictionary *)dataDict callback:(void (^)(id))handler
{
    [[self kwr] put:path data:dataDict callback:handler];
}

- (id)init
{
    self = [super init];
    if (self) {
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 1;
        
        _baseUrl = [NSURL URLWithString:kHostName];
        
        _reachable = [Reachability reachabilityWithHostname:kHostName];
        
        __weak NSOperationQueue *operationQueue = _operationQueue;
        _reachable.reachableBlock = ^(Reachability *reach) {
            [operationQueue setSuspended:NO];
        };
        _reachable.unreachableBlock = ^(Reachability *reach) {
            [operationQueue setSuspended:YES];
        };
        
        //[_reachable startNotifier];
    }
    return self;
}

- (void)get:(NSString *)path callback:(void (^)(id))handler
{
    [self request:path method:@"GET" data:nil callback:handler];
}

- (void)post:(NSString *)path data:(NSDictionary *)dataDict callback:(void (^)(id))handler
{
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:0 error:&error];
    
    if (data == nil) {
        NSLog(@"Could not serialize dictionary for POST request. %@", dataDict);
        abort();
    }
    
    [self request:path method:@"POST" data:data callback:handler];
}

- (void)put:(NSString *)path data:(NSDictionary *)dataDict callback:(void (^)(id))handler
{
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:0 error:&error];
    
    if (data == nil) {
        NSLog(@"Could not serialize dictionary for POST request. %@", dataDict);
        abort();
    }
    
    [self request:path method:@"PUT" data:data callback:handler];
}

- (void)requestData:(NSString *)path method:(NSString *)method data:(NSData *)data callback:(void (^)(id))callback
{
    path = [path stringByAppendingString:@".json"];
    
    NSURL *url = [[NSURL alloc] initWithString:path relativeToURL:_baseUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = method;
    
    if (data != nil) {
        request.HTTPBody = data;
    }
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    if ([BSSession defaultSession].accessToken) {
        [request setValue:[NSString stringWithFormat:@"Token token=\"%@\"", [BSSession defaultSession].accessToken] forHTTPHeaderField:@"Authorization"];
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:_operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        NSLog(@"made request %d %@ %@ %@", httpResponse.statusCode, httpResponse.allHeaderFields, data, error);
        
        if (httpResponse.statusCode == 403) {
            NSLog(@"session expired");
            [[BSSession defaultSession] expired];
        } else if (error != nil) {
            NSLog(@"request error %@", error);
        } else if (httpResponse.statusCode == 200 && callback != nil) {
            callback(data);
        }
    }];
}

- (void)request:(NSString *)path method:(NSString *)method data:(NSData *)data callback:(void (^)(id))callback
{    
    [self requestData:path method:method data:data callback:^(id data) {
        if (callback != nil) {
            id jsonObject = nil;
            
            if (data == nil) {
                // not connected!
            }
            else {
                jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            }
            
            callback(jsonObject);
        }
    }];
}

@end
