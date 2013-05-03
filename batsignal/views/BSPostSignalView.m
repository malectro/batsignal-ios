//
//  BSPostSignalView.m
//  batsignal
//
//  Created by Kyle Warren on 5/3/13.
//  Copyright (c) 2013 Kyle Warren. All rights reserved.
//

#import "BSPostSignalView.h"

@implementation BSPostSignalView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _textFieldBg = [[UIView alloc] init];
        _textFieldBg.backgroundColor = [UIColor whiteColor];
        [self addSubview:_textFieldBg];
        
        _textField = [[UITextField alloc] init];
        _textField.placeholder = @"What's happening?";
        [self addSubview:_textField];
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [self addSubview:_cancelButton];
        
        _postButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_postButton setTitle:@"Post" forState:UIControlStateNormal];
        [self addSubview:_postButton];
    }
    return self;
}

- (void)layoutSubviews
{
    _textFieldBg.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, 100.0f);
    _textField.frame = CGRectMake(10.0f, 10.0f, self.frame.size.width - 20.0f, 80.0f);
    _cancelButton.frame = CGRectMake(5.0f, self.frame.size.height - 30.0f, 50.0f, 26.0f);
    _postButton.frame = CGRectMake(self.frame.size.width - 55.0f, self.frame.size.height - 30.0f, 50.0f, 26.0f);
}

@end
