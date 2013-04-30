//
//  BSMainViewController.h
//  batsignal
//
//  Created by Kyle Warren on 4/29/13.
//  Copyright (c) 2013 Kyle Warren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class BSMainView;
@class BSProfileViewController;

@interface BSMainViewController : UIViewController<MKMapViewDelegate,NSFetchedResultsControllerDelegate>

@property (nonatomic) BSMainView *mainView;
@property (nonatomic, readonly) BSProfileViewController *profileViewController;

@property (nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;

@end
