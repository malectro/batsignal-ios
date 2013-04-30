//
//  BSMainViewController.m
//  batsignal
//
//  Created by Kyle Warren on 4/29/13.
//  Copyright (c) 2013 Kyle Warren. All rights reserved.
//

#import "BSMainViewController.h"

#import "BSMainView.h"
#import "BSBeacon.h"
#import "BSSession.h"

@interface BSMainViewController ()

@property (nonatomic) BOOL shouldUpdateMapCenter;

@end

@implementation BSMainViewController

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        _shouldUpdateMapCenter = YES;
    }
    return self;
}

- (void)loadView
{
    self.view = self.mainView = [[BSMainView alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.mainView.mapView.showsUserLocation = YES;
    self.mainView.mapView.delegate = self;
    
    [self.mainView.postSignalButton addTarget:self action:@selector(postBeacon) forControlEvents:UIControlEventTouchDown];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)postBeacon
{
    BSBeacon *beacon = [BSBeacon create];
    beacon.user = [BSSession defaultSession].user;
    beacon.location = self.mainView.mapView.userLocation.coordinate;
    [beacon save];
    
    NSLog(@"all beacons %@", [BSBeacon all]);
}

#pragma mark - MKMapViewDelegate methods

- (void)mapView:mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (_shouldUpdateMapCenter) {
        //[self.mainView.mapView setCenterCoordinate:self.mainView.mapView.userLocation.coordinate animated:YES];
        MKCoordinateRegion coordinateRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 1000.0f, 1000.0f);
        [self.mainView.mapView setRegion:coordinateRegion animated:YES];
        _shouldUpdateMapCenter = NO;
    }
}

@end
