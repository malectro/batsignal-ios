//
//  BSMainView.m
//  batsignal
//
//  Created by Kyle Warren on 4/29/13.
//  Copyright (c) 2013 Kyle Warren. All rights reserved.
//

#import "BSMainView.h"

@implementation BSMainView

@synthesize mapView = _mapView;
@synthesize postSignalButton = _postSignalButton;
@synthesize profileButton = _profileButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.mapView];
        [self addSubview:self.postSignalButton];
        [self addSubview:self.profileButton];
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
}

- (void)presentProfile
{
    
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
