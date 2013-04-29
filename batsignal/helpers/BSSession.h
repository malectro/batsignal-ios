//
//  BSSession.h
//  batsignal
//
//  Created by Kyle Warren on 4/25/13.
//  Copyright (c) 2013 Kyle Warren. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Accounts/Accounts.h>

@interface BSSession : NSObject

@property (nonatomic) ACAccount *twitterAccount;

+ (BSSession *)defaultSession;
+ (BOOL)hasAccount;

- (void)auth;

@end
