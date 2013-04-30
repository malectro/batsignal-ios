//
//  KWModel.m
//  Unison Brain
//
//  Created by Kyle Warren on 2/1/13.
//  Copyright (c) 2013 Kyle Warren. All rights reserved.
//

#import "KWModel.h"

#import "BSAppDelegate.h"
#import "KWBson.h"
#import "KWRequest.h"

@implementation KWModel

@dynamic id;
@dynamic updatedAt;

// Override these method
+ (NSString *)modelName
{
    NSLog(@"Error: 'modelName' method not implemented");
    abort();
}

+ (NSString *)modelUrl
{
    NSLog(@"Error: 'modelUrl' method not implemented");
    abort();
}

+ (NSArray *)modelSort
{
    return nil;
}

+ (NSDictionary *)keyMap
{
    return @{@"updated_at": @"updatedAt",
             @"id": @"id"};
}

+ (NSDictionary *)reverseKeyMap
{
    return @{@"updatedAt": @"updated_at"};
}

+ (NSFetchRequest *)modelRequest
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:[self modelName] inManagedObjectContext:[BSAppDelegate moc]];
    
    fetchRequest.entity = entity;
    
    return fetchRequest;
}

+ (NSArray *)modelResults:(NSFetchRequest *)fetchRequest
{
    NSError *error = nil;
    NSArray *results = [[BSAppDelegate moc] executeFetchRequest:fetchRequest error:&error];
    
    if (results == nil) {
        NSLog(@"Error %@: Fetch request failed", [self modelName]);
        abort();
    }
    
    return results;
}

+ (id)find:(NSString *)modelId
{
    NSFetchRequest *fetchRequest = [self modelRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", modelId];
    
    fetchRequest.predicate = predicate;
    
    NSArray *results = [self modelResults:fetchRequest];
    KWModel *returnal = nil;
    
    if (results.count > 0) {
        returnal = results[0];
    }
    
    return returnal;
}

+ (KWModel *)create
{
    KWModel *model = [NSEntityDescription insertNewObjectForEntityForName:[self modelName] inManagedObjectContext:[BSAppDelegate moc]];
    
    // set the unique mongo bson objectId
    model.id = [KWBson bsonId];
    
    return model;
}

+ (NSArray *)all
{
    NSFetchRequest *fetchRequest = [self modelRequest];
    
    fetchRequest.fetchBatchSize = 40;
    [fetchRequest setSortDescriptors:[self modelSort]];
    
    return [self modelResults:fetchRequest];
}

+ (void)fetchAll
{
    [self fetchUrl:[self modelUrl]];
}

+ (void)fetchUrl:(NSString *)url
{
    [self fetchUrl:url handler:nil];
}

+ (void)fetchUrl:(NSString *)url handler:(void (^)(NSArray *))handler
{
    [KWRequest get:url callback:^(NSArray *models) {
        for (NSDictionary *dict in models) {
            [self findOrCreateWithDict:dict];
        }
        
        [[BSAppDelegate moc] save:nil];
        
        NSString *notification = [NSString stringWithFormat:@"%@:fetchAll", [self modelName]];
        [[NSNotificationCenter defaultCenter] postNotificationName:notification object:self];
        
        if (handler != nil) {
            handler(@[]);
        }
    }];
}

+ (id)findOrCreateWithDict:(NSDictionary *)dict
{
    KWModel *model = [self find:dict[@"id"]];
    
    if (model == nil) {
        model = [self create];
    }
    
    if (model.updatedAt.integerValue <= [dict[@"updated_at"] integerValue]) {
        [model updateWithDict:dict];
    }
    
    return model;
}

- (void)customUpdate:(NSDictionary *)dict
{
    // override this if you want cooler stuff to happen
}

- (void)updateWithDict:(NSDictionary *)dict
{
    NSMutableDictionary *keyMap = [NSMutableDictionary dictionaryWithDictionary:[[self class] keyMap]];
    
    keyMap[@"updated_at"] = @"updatedAt";
    keyMap[@"id"] = @"id";
    
    [self customUpdate:dict];
    
    for (NSString *key in dict) {
        //NSLog(@"mapping %@ : %@", [[self class] modelName], key);
        if (keyMap[key] && dict[key] != [NSNull null]) {
            // is this a relationship?
            if ([keyMap[key] superclass] == [KWModel class] || [[keyMap[key] superclass] superclass] == [KWModel class]) {
                id model = nil;
                
                if ([dict[key] isKindOfClass:[NSArray class]]) {
                    NSArray *toMap = dict[key];
                    NSMutableSet *relations = [NSMutableSet setWithSet:[self valueForKey:key]];
                    
                    for (id relation in toMap) {
                        if ([relation isKindOfClass:[NSString class]]) {
                            model = [keyMap[key] find:relation];
                            if (model) {
                                [relations addObject:model];
                            }
                        }
                        else {
                            [relations addObject:[keyMap[key] findOrCreateWithDict:relation]];
                        }
                    }
                    
                    [self setValue:relations forKey:key];
                }
                else if ([dict[key] isKindOfClass:[NSDictionary class]]) {
                    [self setValue:[keyMap[key] findOrCreateWithDict:dict[key]] forKey:key];
                }
                else if ([dict[key] isKindOfClass:[NSString class]]) {
                    model = [keyMap[key] find:dict[key]];
                    if (model) {
                        [self setValue:model forKey:key];
                    }
                }
            }
            else {
                if ([key isEqualToString:@"time"]) {
                    [self setValue:[NSDate dateWithTimeIntervalSince1970:[dict[key] floatValue]] forKey:keyMap[key]];
                }
                else {
                    [self setValue:dict[key] forKey:keyMap[key]];
                }
            }
        }
    }
}

- (NSDictionary *)asDict
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self dictionaryWithValuesForKeys:@[@"id", @"updatedAt"]]];
    
    dict[@"updated_at"] = dict[@"updatedAt"];
    [dict removeObjectForKey:@"updatedAt"];
    
    return dict;
}

- (void)save
{
    NSError *error = nil;
    
    // this needs to go somewhere else
    //self.updatedAt = [NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]];
    
    if (![[BSAppDelegate moc] save:&error]) {
        NSLog(@"Error %@: Failed to save managed object context", [[self class] modelName]);
        abort();
    }
}

- (void)destroy
{
    // kill self
    [[BSAppDelegate moc] deleteObject:self];
    [self save];
}

- (void)sync
{
    __weak KWModel *model = self;
    
    if (self.id == nil) {
        // create
        [KWRequest post:[[self class] modelUrl] data:[self asDict] callback:^(id dict) {
            model.id = dict[@"id"];
            model.updatedAt = dict[@"updated_at"];
        }];
    } else {
        // update
        NSString *url = [[self class] modelUrl];
        url = [url stringByAppendingFormat:@"/%@", self.id];
        [KWRequest put:url data:[self asDict] callback:^(id dict) {
            model.updatedAt = dict[@"updated_at"];
        }];
    }
}

@end
