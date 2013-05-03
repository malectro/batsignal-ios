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
#import "KWViewGroup.h"
#import "BSPostSignalView.h"
#import "BSProfileViewController.h"
#import "BSUser.h"
#import "BSBeacon.h"
#import "BSSession.h"

@interface BSMainViewController ()

@property (nonatomic) BOOL shouldUpdateMapCenter;
@property (nonatomic, readonly) NSFetchRequest *fetchRequest;
@property (nonatomic) NSMutableDictionary *userIdCache;
@property (nonatomic) NSMutableArray *groupedBeacons;
@property (nonatomic) BSBeacon *currentBeacon;

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
    
    [self.mainView.postSignalButton addTarget:self action:@selector(newBeacon) forControlEvents:UIControlEventTouchDown];
    
    //[self.mainView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(genericTap)]];
    
    [self loadBeacons];
    
    [BSBeacon fetchAll];
    
    [self.mainView.postSignalView.cancelButton addTarget:self action:@selector(cancelBeacon) forControlEvents:UIControlEventTouchDown];
    [self.mainView.postSignalView.postButton addTarget:self action:@selector(postBeacon) forControlEvents:UIControlEventTouchDown];
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

- (void)genericTap
{
    // resign any text fields
    //[self.mainView.profileView.username resignFirstResponder];
}

- (void)newBeacon
{
    [self.mainView presentPostSignalView];
    [self.mainView.postSignalView.textField becomeFirstResponder];
    self.currentBeacon = [BSBeacon create];
    self.currentBeacon.user = [BSSession defaultSession].user;
    self.currentBeacon.coordinate = self.mainView.mapView.userLocation.coordinate;
    self.currentBeacon.updatedAt = [NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]];
}

- (void)postBeacon
{
    self.currentBeacon.text = self.mainView.postSignalView.textField.text;
    [self.currentBeacon sync:^(id stuff) {
        // probably should do some error handling here
        [self.currentBeacon save];
    }];
    
    [self.mainView.postSignalView.textField resignFirstResponder];
    [self.mainView hidePostSignalView];
    
    [self.mainView.mapView selectAnnotation:self.currentBeacon animated:YES];
    self.currentBeacon = nil;
}

- (void)cancelBeacon
{
    [self.mainView.postSignalView.textField resignFirstResponder];
    [self.mainView hidePostSignalView];
    [self.currentBeacon destroy:NO];
}

#pragma mark - MKMapViewDelegate methods

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
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

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    if (view.annotation == self.currentBeacon) {

    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *beaconId = @"beacon";
    
    NSString *identifier = beaconId;
    
    if (annotation == mapView.userLocation) {
        return nil;
    }
    
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.canShowCallout = YES;
    }
    
    annotationView.annotation = annotation;
    
    if (annotation == self.currentBeacon) {
        annotationView.draggable = YES;
    }
    
    return annotationView;
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
    return @[[NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO]];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // reload map annotations
    NSArray *beacons = self.fetchedResultsController.fetchedObjects;
    
    NSLog(@"beacons %@", beacons);
    
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
