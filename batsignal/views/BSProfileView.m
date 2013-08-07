//
//  BSProfileView.m
//  batsignal
//
//  Created by Kyle Warren on 4/30/13.
//  Copyright (c) 2013 Kyle Warren. All rights reserved.
//

#import "BSProfileView.h"

@implementation BSProfileView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _username = [[UITextField alloc] init];
        _username.placeholder = @"your handle";
        [self addSubview:_username];
        
        _backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_backButton setTitle:@"->" forState:UIControlStateNormal];
        [_backButton sizeToFit];
        [self addSubview:_backButton];
        
        _logoutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_logoutButton setTitle:@"log out" forState:UIControlStateNormal];
        [_logoutButton sizeToFit];
        [self addSubview:_logoutButton];
    }
    return self;
}

- (void)layoutSubviews
{
    _username.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, 30.0f);
    _backButton.frame = CGRectMake(0.0f, self.frame.size.height - 30.0f, self.frame.size.width, 30.0f);
    _logoutButton.frame = CGRectMake(0.0f, 30.0f, self.frame.size.width, 30.0f);
}

@end
