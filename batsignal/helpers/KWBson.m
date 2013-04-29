//
//  KWBson.m
//  Unison Brain
//
//  Created by Kyle Warren on 2/16/13.
//  Copyright (c) 2013 Kyle Warren. All rights reserved.
//

#import "KWBson.h"

#import <CommonCrypto/CommonDigest.h>

@implementation KWBson

+ (NSString *)bsonId
{
    static NSInteger incrementer = 0;
    
    int i = incrementer++;
    bson_oid_t *oid = malloc(sizeof(bson_oid_t));
    time_t t = time(NULL);
    
    NSString *string = nil;
    int pid = [NSProcessInfo processInfo].processIdentifier;
    NSString *deviceIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *md5Identifier = [self md5:deviceIdentifier];
    const char *cIdentifer = [md5Identifier cStringUsingEncoding:NSUTF8StringEncoding];
    
    bsonSwapEndianLength(&oid->bytes[0], &t, 4);
    bsonSwapEndianLength(&oid->bytes[4], &cIdentifer, 3);
    bsonSwapEndianLength(&oid->bytes[7], &pid, 2);
    bsonSwapEndianLength(&oid->bytes[9], &i, 3);
    
    string = [self stringFromBsonOid:oid];
    
    free(oid);
    
    return string;
}

+ (NSString *)md5:(NSString *)source
{
    const char *cString = [source UTF8String];
    unsigned char result[16];
    
    CC_MD5(cString, strlen(cString), result);
    
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4],
            result[5], result[6], result[7], result[8], result[9],
            result[10], result[11], result[12], result[13],
            result[14], result[15]];
}

+ (NSString *)stringFromBsonOid:(bson_oid_t *)oid
{
    static const char hex[16] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};
    
    NSString *string = nil;
    char *str = malloc(sizeof(char) * 25);
    int i;
    
    for (i = 0; i < 12; i++) {
        str[2 * i] = hex[(oid->bytes[i] & 0xf0) >> 4];
        str[2 * i + 1] = hex[oid->bytes[i] & 0x0f];
    }
    
    str[24] = '\0';
    
    string = [NSString stringWithCString:str encoding:NSUTF8StringEncoding];
    free(str);
    
    return string;
}

void bsonSwapEndianLength(void *output, const void *input, int length) {
    const char *in = (const char *)input;
    char *out = (char *)output;
    
    for (int i = 0; i < length; i++) {
#if __DARWIN_BIG_ENDIAN
        out[i] = in[length - 1 - i];
#elif __DARWIN_LITTLE_ENDIAN
        out[i] = in[i];
#endif
    }
}

@end
