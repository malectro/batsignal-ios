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

- (id)init
{
    self = [super init];
    if (self) {
        _accountStore = [[ACAccountStore alloc] init];
        
        _user = [BSUser find:[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]];
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
    
    [TWAPIManager registerTwitterAppKey:@"YtG2yx3ltHAFx7RtXtKoA" andAppSecret:[[[NSBundle mainBundle] infoDictionary] valueForKey:@"TWITTER_SECRET"]];
    [TWAPIManager performReverseAuthForAccount:self.twitterAccount withHandler:^(NSData *responseData, NSError *error) {
        NSString *string = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSString *path = [NSString stringWithFormat:@"/auth/twitter_reverse/callback?%@", string];
        
        [KWRequest get:path callback:^(NSDictionary *response) {
            if (response && response[@"id"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"session:authed" object:nil];
                });
                
                _user = [BSUser findOrCreateWithDict:response];
                [_user save];
                [[NSUserDefaults standardUserDefaults] setValue:self.user.id forKey:@"userId"];
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
        _user = nil;
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"userId"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"session:expired" object:nil];
        });
    }];
}

@end
