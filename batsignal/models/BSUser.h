//
//  BSUser.h
//  batsignal
//
//  Created by Kyle Warren on 4/29/13.
//  Copyright (c) 2013 Kyle Warren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "KWModel.h"


@interface BSUser : KWModel

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * updatedAt;
@property (nonatomic, retain) NSSet *beacons;
@end

@interface BSUser (CoreDataGeneratedAccessors)

- (void)addBeaconsObject:(NSManagedObject *)value;
- (void)removeBeaconsObject:(NSManagedObject *)value;
- (void)addBeacons:(NSSet *)values;
- (void)removeBeacons:(NSSet *)values;

@end
