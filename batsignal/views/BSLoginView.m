//
//  BSLoginView.m
//  batsignal
//
//  Created by Kyle Warren on 4/25/13.
//  Copyright (c) 2013 Kyle Warren. All rights reserved.
//

#import "BSLoginView.h"

@implementation BSLoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.label1 = [[UILabel alloc] init];
        self.label1.text = @"Batsignal!";
        self.label1.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.label1];
        
        self.twitterLoginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.twitterLoginButton setTitle:@"Log in with Twitter" forState:UIControlStateNormal];
        [self addSubview:self.twitterLoginButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [self.label1 sizeToFit];
    self.label1.frame = CGRectMake(0.0f, 10.0f, self.frame.size.width, self.label1.frame.size.height);
    
    [self.twitterLoginButton sizeToFit];
    self.twitterLoginButton.frame = CGRectMake((self.frame.size.width - self.twitterLoginButton.frame.size.width) / 2.0f,
                                                40.0f,
                                                self.twitterLoginButton.frame.size.width,
                                                self.twitterLoginButton.frame.size.height);
}

@end
