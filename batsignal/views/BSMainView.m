//
//  BSMainView.m
//  batsignal
//
//  Created by Kyle Warren on 4/29/13.
//  Copyright (c) 2013 Kyle Warren. All rights reserved.
//

#import "BSMainView.h"

#import "BSProfileView.h"

@implementation BSMainView

@synthesize mapView = _mapView;
@synthesize postSignalButton = _postSignalButton;
@synthesize profileButton = _profileButton;
@synthesize signalTextField = _signalTextField;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.mapView];
        [self addSubview:self.postSignalButton];
        [self addSubview:self.profileButton];
        [self addSubview:self.signalTextField];
    }
    return self;
}

- (void)layoutSubviews
{
    self.mapView.frame = self.frame;
    self.postSignalButton.center = CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height - 30.0f);
    self.profileButton.frame = CGRectMake(self.frame.size.width - self.profileButton.frame.size.width - 10.0f,
                                          self.frame.size.height - 35.0f,
                                          self.profileButton.frame.size.width,
                                          30.0f);
    self.signalTextField.frame = CGRectMake(0.0f, -100.0f, self.frame.size.width, 100.0f);
    
    // profile view sits to the right of the screen
    if (self.profileView != nil) {
        self.profileView.frame = CGRectMake(self.frame.size.width, 0.0f, self.frame.size.width / 2.0f, self.frame.size.height);
    }
}

- (void)presentProfile
{
    [UIView animateWithDuration:0.2f animations:^{
        self.profileView.frame = CGRectOffset(self.profileView.frame, -self.profileView.frame.size.width, 0.0f);
    }];
}

- (void)hideProfile
{
    [UIView animateWithDuration:0.2f animations:^{
        self.profileView.frame = CGRectMake(self.frame.size.width, 0.0f, self.frame.size.width / 2.0f, self.frame.size.height);
    }];
}

#pragma mark - Getters!

- (MKMapView *)mapView
{
    if (_mapView == nil) {
        _mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
    }
    return _mapView;
}

- (UIButton *)postSignalButton
{
    if (_postSignalButton == nil) {
        _postSignalButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_postSignalButton setTitle:@"s" forState:UIControlStateNormal];
        _postSignalButton.titleLabel.font = [UIFont systemFontOfSize:32.0f];
        [_postSignalButton sizeToFit];
    }
    return _postSignalButton;
}

- (UIButton *)profileButton
{
    if (_profileButton == nil) {
        _profileButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_profileButton setTitle:@"profile" forState:UIControlStateNormal];
        _profileButton.titleLabel.font = [UIFont systemFontOfSize:26.0f];
        [_profileButton sizeToFit];
        
        [self.profileButton addTarget:self action:@selector(presentProfile) forControlEvents:UIControlEventTouchDown];
    }
    return _profileButton;
}

- (UITextField *)signalTextField
{
    if (_signalTextField == nil) {
        _signalTextField = [[UITextField alloc] init];
    }
    return _signalTextField;
}

- (void)setProfileView:(BSProfileView *)profileView
{
    if (_profileView != nil) {
        [_profileView removeFromSuperview];
    }
    _profileView = profileView;
    [self addSubview:_profileView];
    
    [_profileView.backButton addTarget:self action:@selector(hideProfile) forControlEvents:UIControlEventTouchDown];
}

@end
