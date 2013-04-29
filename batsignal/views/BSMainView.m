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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.mapView];
    }
    return self;
}

- (void)layoutSubviews
{
    self.mapView.frame = self.frame;
}

#pragma mark - Getters!

- (MKMapView *)mapView
{
    if (_mapView == nil) {
        _mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
    }
    return _mapView;
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
