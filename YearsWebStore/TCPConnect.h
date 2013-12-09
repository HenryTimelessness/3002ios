//
//  TCPConnect.h
//  YearsWebStore
//
//  Created by Henry Chua on 8/12/13.
//  Copyright (c) 2013 Henry Chua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCPConnect : NSObject
- (void)openAndSendRequest:(NSString *)request success:(void (^)(NSString *jsonString))success;
- (void)simulateOpenAndSendRequest:(NSString *)request success:(void (^)(NSString *jsonString))success;
@end
