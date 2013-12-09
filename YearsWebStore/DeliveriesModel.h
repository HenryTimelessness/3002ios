//
//  DeliveriesModel.h
//  YearsWebStore
//
//  Created by Henry Chua on 8/12/13.
//  Copyright (c) 2013 Henry Chua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Delivery.h"

@interface DeliveriesModel : NSObject
+ (DeliveriesModel*) sharedInstance;
- (NSArray *)deliveries;
- (NSArray *)deliverables:(NSString *)deliveryID;
- (void)setDelivered:(NSString *)barcode quantityReceived:(int)quantityReceived success:(void (^)())success failure:(void (^)(NSException *ex))failure;
- (void)updateDeliveryList:(void (^)())success failure:(void (^)(NSException *ex))failure;
- (void)updateCurrentDeliverableList:(void (^)())success failure:(void (^)(NSException *ex))failure;
- (void)changeCurrentDeliverableList:(NSString *)currentDeliveryID;
- (void)updateChangesToServer:(void (^)())success failure:(void (^)(NSException *ex))failure;
@end
