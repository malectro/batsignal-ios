//
//  BSBeacon.h
//  batsignal
//
//  Created by Kyle Warren on 4/29/13.
//  Copyright (c) 2013 Kyle Warren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>

#import "KWModel.h"

@class BSUser;

@interface BSBeacon : KWModel<MKAnnotation>

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * geoLat;
@property (nonatomic, retain) NSNumber * geoLon;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * updatedAt;
@property (nonatomic, retain) BSUser *user;

@end
