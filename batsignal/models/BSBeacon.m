//
//  BSBeacon.m
//  batsignal
//
//  Created by Kyle Warren on 4/29/13.
//  Copyright (c) 2013 Kyle Warren. All rights reserved.
//

#import "BSBeacon.h"
#import "BSUser.h"


@implementation BSBeacon

@dynamic text;
@dynamic geoLat;
@dynamic geoLon;
@dynamic id;
@dynamic updatedAt;
@dynamic user;

- (CLLocationCoordinate2D)location
{
    return CLLocationCoordinate2DMake(self.geoLat.doubleValue, self.geoLon.doubleValue);
}

- (void)setLocation:(CLLocationCoordinate2D)location
{
    self.geoLat = [NSNumber numberWithDouble:location.latitude];
    self.geoLon = [NSNumber numberWithDouble:location.longitude];
}

+ (NSString *)modelName
{
    return @"BSBeacon";
}

+ (NSString *)modelUrl
{
    return @"/beacons";
}

@end
