//
//  KWModel.h
//  Unison Brain
//
//  Created by Kyle Warren on 2/1/13.
//  Copyright (c) 2013 Kyle Warren. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface KWModel : NSManagedObject

@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSNumber *updatedAt;

+ (NSString *)bsonId;
+ (id)find:(NSString *)modelId;
+ (id)create;
+ (NSArray *)all;
+ (id)findOrCreateWithDict:(NSDictionary *)dict;

+ (void)fetchAll;
+ (void)fetchUrl:(NSString *)url;
+ (void)fetchUrl:(NSString *)url handler:(void (^) (NSArray *))handler;

+ (NSString *)modelName;
+ (NSString *)modelUrl;
+ (NSArray *)modelSort;
+ (NSDictionary *)keyMap;
- (NSDictionary *)asDict;
- (void)customUpdate:(NSDictionary *)dict;

- (void)save;
- (void)destroy:(BOOL)forRealz;
- (void)sync;
- (void)sync:(void (^) (id))handler;

@end
