//
//  customAFJSONResponseSerializerWithDataKey.h
//  Squigur
//
//  Created by Henry Chua on 27/10/13.
//  Copyright (c) 2013 Squigur. All rights reserved.
//

#import "AFURLResponseSerialization.h"

/// NSError userInfo key that will contain response data
static NSString * const JSONResponseSerializerWithDataKey = @"JSONResponseSerializerWithDataKey";

@interface CustomAFJSONResponseSerializerWithDataKey : AFJSONResponseSerializer

@end
