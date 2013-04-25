//
//  BSSession.m
//  batsignal
//
//  Created by Kyle Warren on 4/25/13.
//  Copyright (c) 2013 Kyle Warren. All rights reserved.
//

#import "BSSession.h"

#import <Social/Social.h>

@interface BSSession ()

@property (nonatomic) ACAccountStore *accountStore;

@end

@implementation BSSession

+ (BSSession *)defaultSession
{
    static BSSession *session = nil;
    if (!session) {
        session = [[BSSession alloc] init];
    }
    return session;
}

- (id)init
{
    self = [super init];
    if (self) {
        _accountStore = [[ACAccountStore alloc] init];
    }
    return self;
}

- (void)auth
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        ACAccountType *accountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        [self.accountStore requestAccessToAccountsWithType:accountType options:NULL completion:^(BOOL granted, NSError *error) {
            if (granted) {
                NSArray *accounts = [self.accountStore accountsWithAccountType:accountType];
                self.twitterAccount = [accounts lastObject];
                
                NSLog(@"Logged in with %@ %@ %@", self.twitterAccount.username, self.twitterAccount.credential, self.twitterAccount.identifier);
            } else {
                // access not granted :(
                NSLog(@"Access denied");
            }
        }];
    } else {
        // not available :(
        NSLog(@"No accounts available");
    }
}

@end
