//
//  KWBson.h
//  Unison Brain
//
//  Created by Kyle Warren on 2/16/13.
//  Copyright (c) 2013 Kyle Warren. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef union {
    char bytes[12];
    int ints[3];
} bson_oid_t;

@interface KWBson : NSObject

+ (NSString *)bsonId;

@end
