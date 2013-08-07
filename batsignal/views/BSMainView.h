//
//  BSMainView.h
//  batsignal
//
//  Created by Kyle Warren on 4/29/13.
//  Copyright (c) 2013 Kyle Warren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class BSProfileView;
@class BSPostSignalView;

@interface BSMainView : UIView

@property (nonatomic, readonly) MKMapView *mapView;
@property (nonatomic, readonly) UIButton *postSignalButton;
@property (nonatomic, readonly) UIButton *profileButton;
@property (nonatomic, readonly) UIButton *refreshButton;

@property (nonatomic) BSPostSignalView *postSignalView;
@property (nonatomic) BSProfileView *profileView;

- (void)presentPostSignalView;
- (void)hidePostSignalView;

@end
