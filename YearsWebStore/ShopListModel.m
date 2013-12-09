//
//  ShopListModel.m
//  YearsWebStore
//
//  Created by Henry Chua on 9/12/13.
//  Copyright (c) 2013 Henry Chua. All rights reserved.
//

#import "ShopListModel.h"
#import "AFHTTPRequestOperationManager.h"
#import "customAFJSONResponseSerializerWithDataKey.h"


@interface ShopListModel ()
@property (strong, nonatomic) Shop *CurrentSelectedShop;
@property (strong, nonatomic) NSArray *ListOfShops;
@end

@implementation ShopListModel

- (ShopListModel *)init {
    self = [super init];
    
    return self;
}

+ (ShopListModel*) sharedInstance {
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}
- (NSArray *)shops {
    return _ListOfShops;
}
- (Shop *)currentSelectedShop {
    return _CurrentSelectedShop;
}
- (void)updateShopsList:(void (^)())success failure:(void (^)(NSException *ex))failure {
    
    //simulate success
    _ListOfShops = @[[[Shop alloc] initWithID:@"4321" address:@"John's Shop" IPAddress:@"172.28.177.33" port:@"13000"]];
    
    for (Shop *shops in _ListOfShops) {
        if ([shops.ID isEqualToString:_CurrentSelectedShop.ID]) {
            shops.Status = @"Connected";
            _CurrentSelectedShop = shops;
            [self saveConnectedShop];
        } else {
            shops.Status = @"Not Connected";
        }
    }
    success();
    return;
    @try {
        //TODO: HTTP connection here
        
        NSDictionary *parameters = [[NSDictionary alloc] init];
        NSLog(@"Parameters: %@", [parameters description]);
        NSString *fullURL = [NSString stringWithFormat:@"%@%@",@"InstanceURL",@"/whatever"];
        if(!parameters) parameters = @{};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [CustomAFJSONResponseSerializerWithDataKey serializer];
        [manager GET:fullURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            // convert to dict
            NSDictionary *responseDict = responseObject;
            //TODO: update to shop list
            //if currentconnected shop not in shop list, append to list
            success();
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSData *responseData = [error.userInfo objectForKey:@"JSONResponseSerializerWithDataKey"];
            NSDictionary *responseDict;
            @try {
                responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves  error:nil];
                NSString *errorMessage = [[responseDict objectForKey:@"errors"] componentsJoinedByString:@","];
                NSLog(@"GET Error for %@: %@",[error description]);
            }
            @catch (NSException * e) {
                failure([NSString stringWithFormat:@"GET Exception: %@", [e description]]);
            }
        }];

    } @catch (NSException *ex) {
        NSLog(@"Error occured while updating: %@", [ex description]);
        failure(ex);
    }
}

- (void)saveConnectedShop {
    [[NSUserDefaults standardUserDefaults] setValue:_CurrentSelectedShop.ID forKey:@"shop-id"];
    [[NSUserDefaults standardUserDefaults] setValue:_CurrentSelectedShop.IPAddress forKey:@"shop-ip"];
    [[NSUserDefaults standardUserDefaults] setValue:_CurrentSelectedShop.Address forKey:@"shop-address"];
    [[NSUserDefaults standardUserDefaults] setValue:_CurrentSelectedShop.Port forKey:@"shop-port"];
}
- (void)loadConnectedShop {
    Shop *loadedShop = [[Shop alloc] init];
    loadedShop.ID = [[NSUserDefaults standardUserDefaults] objectForKey:@"shop-id"];
    loadedShop.Address = [[NSUserDefaults standardUserDefaults] objectForKey:@"shop-address"];
    loadedShop.IPAddress = [[NSUserDefaults standardUserDefaults] objectForKey:@"shop-ip"];
    loadedShop.Port = [[NSUserDefaults standardUserDefaults] objectForKey:@"shop-port"];
    loadedShop.Status = @"Connected";
    _CurrentSelectedShop = loadedShop;
}

- (void)connectToShop:(Shop *)shop {
    if (![shop isEqual:_CurrentSelectedShop]) {
        [self changeCurrentSelectedShop:shop.ID success:^(Shop *newShop) {
            [self saveConnectedShop];
        } failure:^(NSException *ex) {
            NSLog(@"Failed to connect to shop");
        }];
    }
}

- (void)changeCurrentSelectedShop:(NSString *)shopID success:(void (^)(Shop *newShop))success failure:(void (^)(NSException *ex))failure {
    bool shopChanged = NO;
    @try {
        for (Shop *shop in _ListOfShops) {
            if ([shopID isEqualToString:shop.ID]) {
                _CurrentSelectedShop.Status = @"Not Connected";
                shop.Status = @"Connected";
                _CurrentSelectedShop = shop;
                success(shop);
                shopChanged = YES;
                break;
            }
        }
        if (shopChanged == NO) {
            failure(nil);
        }
    } @catch (NSException *ex) {
        NSLog(@"shopchangefail: %@", [ex description]);
    }
}

@end
