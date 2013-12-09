//
//  ShopListModel.h
//  YearsWebStore
//
//  Created by Henry Chua on 9/12/13.
//  Copyright (c) 2013 Henry Chua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Shop.h"

@interface ShopListModel : NSObject
+ (ShopListModel*) sharedInstance;
- (NSArray *)shops;
- (Shop *)currentSelectedShop;
- (void)updateShopsList:(void (^)())success failure:(void (^)(NSException *ex))failure;
- (void)changeCurrentSelectedShop:(NSString *)shopID success:(void (^)(Shop *newShop))success failure:(void (^)(NSException *ex))failure;
- (void)saveConnectedShop;
- (void)loadConnectedShop;
- (void)connectToShop:(Shop *)shop;
@property (strong, nonatomic) NSString *shopConnectionStatus;
@end
