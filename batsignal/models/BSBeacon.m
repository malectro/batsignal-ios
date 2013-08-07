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

+ (NSString *)modelName
{
    return @"BSBeacon";
}

+ (NSString *)modelUrl
{
    return @"/beacons";
}

+ (NSDictionary *)keyMap
{
    return @{@"text": @"text",
             @"user": [BSUser class]};
}

- (void)customUpdate:(NSDictionary *)dict
{
    self.geoLon = dict[@"geo"][@"lng"];
    self.geoLat = dict[@"geo"][@"lat"];
}

- (NSDictionary *)asDict
{
    NSMutableDictionary *dict = [[self dictionaryWithValuesForKeys:@[@"id", @"text"]] mutableCopy];
    
    dict[@"geo"] = @{@"lat": self.geoLat, @"lng": self.geoLon};
    dict[@"user_id"] = self.user.id;
    
    return dict;
}

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(self.geoLat.doubleValue, self.geoLon.doubleValue);
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    self.geoLat = [NSNumber numberWithDouble:newCoordinate.latitude];
    self.geoLon = [NSNumber numberWithDouble:newCoordinate.longitude];
}

- (NSString *)title
{
    return self.user.handle;
}

- (NSString *)subtitle
{
    return self.text;
}

@end
