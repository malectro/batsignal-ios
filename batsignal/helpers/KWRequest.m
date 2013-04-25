//
//  UBRequest.m
//  Unison Brain
//
//  Created by Kyle Warren on 2/10/13.
//  Copyright (c) 2013 Kyle Warren. All rights reserved.
//

#import "KWRequest.h"

#import "Reachability.h"

#define kHostName @"http://localhost:3000"

@interface UBRequest ()

@property (nonatomic) Reachability *reachable;
@property (nonatomic) NSOperationQueue *operationQueue;
@property (nonatomic) NSURL *baseUrl;

@end

@implementation UBRequest

+ (UBRequest *)ubr
{
    static UBRequest *requester = nil;
    
    if (requester == nil) {
        requester = [[UBRequest alloc] init];
    }
    
    return requester;
}

+ (void)get:(NSString *)path callback:(void (^)(id))handler
{
    [[self ubr] get:path callback:handler];
}

+ (void)post:(NSString *)path data:(NSDictionary *)dataDict callback:(void (^)(id))handler
{
    [[self ubr] post:path data:dataDict callback:handler];
}

+ (void)put:(NSString *)path data:(NSDictionary *)dataDict callback:(void (^)(id))handler
{
    [[self ubr] put:path data:dataDict callback:handler];
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

- (void)request:(NSString *)path method:(NSString *)method data:(NSData *)data callback:(void (^)(id))callback
{
    path = [path stringByAppendingString:@".json"];
    
    NSURL *url = [_baseUrl URLByAppendingPathComponent:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = method;
    
    if (data != nil) {
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"Token token=\"%@\"", @"hello"] forHTTPHeaderField:@"Authorization"];
        request.HTTPBody = data;
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:_operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        id jsonObject = nil;
        
        if (data == nil) {
            // not connected!
        }
        else {
            jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        }
        
        if (callback != nil) {
            callback(jsonObject);
        }
    }];
}

@end
