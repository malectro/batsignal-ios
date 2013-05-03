//
//  BSMainView.m
//  batsignal
//
//  Created by Kyle Warren on 4/29/13.
//  Copyright (c) 2013 Kyle Warren. All rights reserved.
//

#import "BSMainView.h"

#import "KWFunctions.h"
#import "KWViewGroup.h"
#import "BSProfileView.h"
#import "BSPostSignalView.h"

@interface BSMainView ()

@property (nonatomic) UIView *mainControlPanel;

@end

@implementation BSMainView

@synthesize mapView = _mapView;
@synthesize postSignalButton = _postSignalButton;
@synthesize profileButton = _profileButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.mapView];
        [self.mainControlPanel addSubview:self.postSignalButton];
        [self.mainControlPanel addSubview:self.profileButton];
        [self addSubview:self.mainControlPanel];
        [self addSubview:self.postSignalView];
    }
    return self;
}

- (void)layoutSubviews
{
    self.mapView.frame = self.frame;
    self.mainControlPanel.frame = CGRectMake(0.0f, self.frame.size.height - 40.0f, self.frame.size.width, 40.0f);
    self.postSignalButton.center = CGPointMake(self.mainControlPanel.frame.size.width / 2.0f, self.mainControlPanel.frame.size.height - 30.0f);
    self.profileButton.frame = CGRectMake(self.mainControlPanel.frame.size.width - self.profileButton.frame.size.width - 10.0f,
                                          self.mainControlPanel.frame.size.height - 35.0f,
                                          self.profileButton.frame.size.width,
                                          30.0f);
    
    self.postSignalView.frame = CGRectMake(0.0f, self.frame.size.height, self.frame.size.width, self.frame.size.height - 218.0f);
    
    // profile view sits to the right of the screen
    if (self.profileView != nil) {
        self.profileView.frame = CGRectMake(self.frame.size.width, 0.0f, self.frame.size.width / 2.0f, self.frame.size.height);
    }
}

- (void)presentProfile
{
    self.profileView.frame = CGRectMake(self.frame.size.width, 0.0f, self.frame.size.width / 2.0f, self.frame.size.height);
    [UIView animateWithDuration:0.2f animations:^{
        self.mainControlPanel.frame = CGRectPosition(self.mainControlPanel.frame, -self.frame.size.width, 0.0f);
        self.profileView.frame = CGRectOffset(self.profileView.frame, -self.profileView.frame.size.width, 0.0f);
    }];
}

- (void)hideProfile
{
    [UIView animateWithDuration:0.2f animations:^{
        self.mainControlPanel.frame = CGRectPosition(self.mainControlPanel.frame, 0.0f, self.frame.size.height - 40.0f);
        self.profileView.frame = CGRectMake(self.frame.size.width, 0.0f, self.frame.size.width / 2.0f, self.frame.size.height);
    }];
}

- (void)presentPostSignalView
{
    [UIView animateWithDuration:0.2f animations:^{
        self.mainControlPanel.frame = CGRectPosition(self.mainControlPanel.frame, 0.0f, -self.frame.size.height);
        self.postSignalView.frame = CGRectPosition(self.postSignalView.frame, 0.0f, 0.0f);
    }];
}

- (void)hidePostSignalView
{
    [self addSubview:self.mapView];
    [self sendSubviewToBack:self.mapView];
    
    [UIView animateWithDuration:0.2f animations:^{
        self.mainControlPanel.frame = CGRectPosition(self.mainControlPanel.frame, 0.0f, self.frame.size.height - 40.0f);
        self.postSignalView.frame = CGRectPosition(self.postSignalView.frame, 0.0f, self.frame.size.height);
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

- (BSPostSignalView *)postSignalView
{
    if (_postSignalView == nil) {
        _postSignalView = [[BSPostSignalView alloc] init];
    }
    
    return _postSignalView;
}

- (UIView *)mainControlPanel
{
    if (_mainControlPanel == nil) {
        _mainControlPanel = [[UIView alloc] init];
    }
    return _mainControlPanel;
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
