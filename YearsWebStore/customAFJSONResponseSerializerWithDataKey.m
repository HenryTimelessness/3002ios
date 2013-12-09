//
//  customAFJSONResponseSerializerWithDataKey.m
//  Squigur
//
//  Created by Henry Chua on 27/10/13.
//  Copyright (c) 2013 Squigur. All rights reserved.
//

#import "customAFJSONResponseSerializerWithDataKey.h"

@implementation CustomAFJSONResponseSerializerWithDataKey
- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    if (![self validateResponse:(NSHTTPURLResponse *)response data:data error:error]) {
        if (*error != nil) {
            NSMutableDictionary *userInfo = [(*error).userInfo mutableCopy];
            userInfo[JSONResponseSerializerWithDataKey] = data;
            NSError *newError = [NSError errorWithDomain:(*error).domain code:(*error).code userInfo:userInfo];
            (*error) = newError;
        }
        
        return (nil);
    }
    
    return ([super responseObjectForResponse:response data:data error:error]);
}
@end
