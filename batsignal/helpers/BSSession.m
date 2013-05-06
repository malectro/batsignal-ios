//
//  BSSession.m
//  batsignal
//
//  Created by Kyle Warren on 4/25/13.
//  Copyright (c) 2013 Kyle Warren. All rights reserved.
//

#import "BSSession.h"

#import <Social/Social.h>
#import <TWAPIManager.h>

#import "KWRequest.h"
#import "BSUser.h"

@interface BSSession ()

@property (nonatomic) ACAccountStore *accountStore;

@end

@implementation BSSession

@synthesize user = _user;

+ (BSSession *)defaultSession
{
    static BSSession *session = nil;
    if (!session) {
        session = [[BSSession alloc] init];
    }
    return session;
}

+ (BOOL)hasAccount
{
    return [BSSession defaultSession].user != nil;
}

- (NSString *)tehKey
{
    static NSString *tehKey = nil;
    
    if (tehKey == nil) {
        NSString *partOne = @"J9SUcmsVhr03";
        NSString *partThree = @"YvRM3Db15bM";
        NSString *partTwo = @"beNXyDGmFKNDuc6zrU45";
        
        tehKey = [NSString stringWithFormat:@"%@%@%@", partOne, partTwo, partThree];
    }
    
    return tehKey;
}

- (id)init
{
    self = [super init];
    if (self) {
        _accountStore = [[ACAccountStore alloc] init];
        
        _user = [BSUser find:[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]];
        _accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"];
        NSLog(@"access token = %@", self.accessToken);
        NSLog(@"user default id %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]);
        //[self attemptToGrabTwitterAccount];
    }
    return self; 
}

- (NSArray *)attemptToGrabTwitterAccount
{
    ACAccountType *accountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    NSArray *accounts = [self.accountStore accountsWithAccountType:accountType];
    return accounts;
}

- (void)getTwitterAccounts:(void (^)(NSArray *accounts, NSString *error))handler
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        ACAccountType *accountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        [self.accountStore requestAccessToAccountsWithType:accountType options:NULL completion:^(BOOL granted, NSError *error) {
            if (granted) {
                handler([self attemptToGrabTwitterAccount], nil);
            } else {
                // access not granted :(
                handler(@[], @"Access denied");
            }
        }];
    } else {
        // not available :(
        handler(@[], @"No accounts available");
    }
}

- (void)authWithTwitterAccount:(ACAccount *)account
{
    self.twitterAccount = account;
    
    [TWAPIManager registerTwitterAppKey:@"hJBWH6EtXOEZaC2AZbxQA" andAppSecret:[self tehKey]];
    [TWAPIManager performReverseAuthForAccount:self.twitterAccount withHandler:^(NSData *responseData, NSError *error) {
        NSString *string = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSString *path = [NSString stringWithFormat:@"/auth/twitter_reverse/callback?%@", string];
        
        [KWRequest get:path callback:^(NSDictionary *response) {
            if (response && response[@"id"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"session:authed" object:nil];
                    
                    _accessToken = response[@"access_token"];
                    _user = [BSUser findOrCreateWithDict:response];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:self.accessToken forKey:@"accessToken"];
                    [[NSUserDefaults standardUserDefaults] setObject:self.user.id forKey:@"userId"];
                    
                    [_user save];
                });
            }
            
            NSLog(@"user default id %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]);
            
            NSLog(@"response %@", response);
        }];
        
        NSLog(@"got the creds %@", string);
    }];
}

- (void)logOut
{
    [KWRequest get:@"/signout" callback:^(id data) {
        [self expired];
    }];
}

- (void)expired
{
    _user = nil;
    //[[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"userId"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"session:expired" object:nil];
    });
}

@end
