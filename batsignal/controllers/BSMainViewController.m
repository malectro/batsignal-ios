//
//  BSMainViewController.m
//  batsignal
//
//  Created by Kyle Warren on 4/29/13.
//  Copyright (c) 2013 Kyle Warren. All rights reserved.
//

#import "BSMainViewController.h"

#import "BSAppDelegate.h"
#import "BSMainView.h"
#import "BSProfileViewController.h"
#import "BSUser.h"
#import "BSBeacon.h"
#import "BSSession.h"

@interface BSMainViewController ()

@property (nonatomic) BOOL shouldUpdateMapCenter;
@property (nonatomic, readonly) NSFetchRequest *fetchRequest;
@property (nonatomic) NSMutableDictionary *userIdCache;
@property (nonatomic) NSMutableArray *groupedBeacons;

@end

@implementation BSMainViewController

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize fetchRequest = _fetchRequest;

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        _shouldUpdateMapCenter = YES;
        self.userIdCache = [[NSMutableDictionary alloc] init];
        self.groupedBeacons = [[NSMutableArray alloc] init];
        
        _profileViewController = [[BSProfileViewController alloc] init];
        [self addChildViewController:_profileViewController];
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
    
    self.mainView.profileView = _profileViewController.profileView;
	
    self.mainView.mapView.showsUserLocation = YES;
    self.mainView.mapView.delegate = self;
    
    [self.mainView.postSignalButton addTarget:self action:@selector(postBeacon) forControlEvents:UIControlEventTouchDown];
    
    [self loadBeacons];
    
    [BSBeacon fetchAll];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.profileViewController viewWillAppear:animated];
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
    beacon.coordinate = self.mainView.mapView.userLocation.coordinate;
    [beacon save];
    [beacon sync];
}

#pragma mark - MKMapViewDelegate methods

- (void)mapView:mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (_shouldUpdateMapCenter) {
        //[self.mainView.mapView setCenterCoordinate:self.mainView.mapView.userLocation.coordinate animated:YES];
        MKCoordinateRegion coordinateRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 1000.0f, 1000.0f);
        [self.mainView.mapView setRegion:coordinateRegion animated:YES];
        
        if (userLocation.coordinate.latitude != 0.0f) {
            _shouldUpdateMapCenter = NO;
        }
    }
}

#pragma mark - data methods

- (void)loadBeacons
{
    [self.fetchedResultsController performFetch:nil];
    [self controllerDidChangeContent:self.fetchedResultsController];
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController == nil) {
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest managedObjectContext:[BSAppDelegate moc] sectionNameKeyPath:nil cacheName:@"beacons"];
        _fetchedResultsController.delegate = self;
    }
    
    return _fetchedResultsController;
}

- (NSFetchRequest *)fetchRequest
{
    if (_fetchRequest == nil) {
        _fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"BSBeacon"];
        [_fetchRequest setFetchBatchSize:100];
        [_fetchRequest setPredicate:[NSPredicate predicateWithValue:YES]];
        [_fetchRequest setSortDescriptors:self.sortDescriptors];
        _fetchRequest.includesSubentities = YES;
    }
    return _fetchRequest;
}

- (NSArray *)sortDescriptors
{
    return @[[NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:YES]];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // reload map annotations
    NSArray *beacons = self.fetchedResultsController.fetchedObjects;
    
    NSLog(@"beacons %@", beacons);
    NSLog(@"user name %@", [BSSession defaultSession].user.name);
    
    [self.mainView.mapView removeAnnotations:self.groupedBeacons];
    
    [self.groupedBeacons removeAllObjects];
    [self.userIdCache removeAllObjects];
    
    for (BSBeacon *beacon in beacons) {
        if (beacon.user && !self.userIdCache[beacon.user.id]) {
            self.userIdCache[beacon.user.id] = beacon;
            [self.groupedBeacons addObject:beacon];
        }
    }
    
    [self.mainView.mapView addAnnotations:self.groupedBeacons];
}

@end
