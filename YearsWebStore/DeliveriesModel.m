//
//  DeliveriesModel.m
//  YearsWebStore
//
//  Created by Henry Chua on 8/12/13.
//  Copyright (c) 2013 Henry Chua. All rights reserved.
//

#import "DeliveriesModel.h"
#import "TCPConnect.h"

@interface DeliveriesModel()
@property (strong, nonatomic) NSString *CurrentDeliveryID;
@property (strong, nonatomic) NSArray *DeliveryList;
@property (strong, nonatomic) NSArray *DeliverablesList;
@property (strong, nonatomic) NSMutableArray *ChangesList;
@end

@implementation DeliveriesModel

- (DeliveriesModel *)init {
    self = [super init];
    _ChangesList = [[NSMutableArray alloc] init];
    return self;
}

+ (DeliveriesModel*) sharedInstance{
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (NSDate *)mfDateFromDotNetJSONString:(NSString *)string {
    static NSRegularExpression *dateRegEx = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateRegEx = [[NSRegularExpression alloc] initWithPattern:@"^\\/date\\((-?\\d++)(?:([+-])(\\d{2})(\\d{2}))?\\)\\/$" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    NSTextCheckingResult *regexResult = [dateRegEx firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
    
    if (regexResult) {
        // milliseconds
        NSTimeInterval seconds = [[string substringWithRange:[regexResult rangeAtIndex:1]] doubleValue] / 1000.0;
        // timezone offset
        if ([regexResult rangeAtIndex:2].location != NSNotFound) {
            NSString *sign = [string substringWithRange:[regexResult rangeAtIndex:2]];
            // hours
            seconds += [[NSString stringWithFormat:@"%@%@", sign, [string substringWithRange:[regexResult rangeAtIndex:3]]] doubleValue] * 60.0 * 60.0;
            // minutes
            seconds += [[NSString stringWithFormat:@"%@%@", sign, [string substringWithRange:[regexResult rangeAtIndex:4]]] doubleValue] * 60.0;
        }
        
        return [NSDate dateWithTimeIntervalSince1970:seconds];
    }
    return nil;
}

- (NSArray *)parseJSONToDeliverables:(NSString *)jsonString {
    @try {
        jsonString = [jsonString uppercaseString];
        NSDictionary *jsonDict =
         [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                         options:NSJSONReadingMutableContainers
                                           error:Nil];
        NSLog(@"DELIVERABLES: %@", [jsonDict description]);
        NSArray *deliverablesArray = [jsonDict objectForKey:@"DELIVERY_CONTENT"];
        NSLog(@"deliverablesArray: %@", [deliverablesArray description]);
        NSMutableArray *parsedDeliverablesList = [[NSMutableArray alloc] init];
        for(int i = 0; i < deliverablesArray.count; i++) {
            NSDictionary* deliverable = deliverablesArray[i];
            NSNumber *barcode = [deliverable objectForKey:@"BARCODE"];
            NSNumber *receivedQuantity = [deliverable objectForKey:@"RECEIVED_QUANTITY"];
            NSNumber *expectedQuantity = [deliverable objectForKey:@"EXPECTED_QUANTITY"];
            NSDictionary *itemInfo = [deliverable objectForKey:@"ITEM_INFO"];
            NSString *manufacturer = [itemInfo objectForKey:@"MANUFACTURER"];
            NSString *productName = [itemInfo objectForKey:@"PRODUCT_NAME"];
            NSLog(@"%@, %@, %@, %@, %@", barcode, receivedQuantity, expectedQuantity, manufacturer, productName);
            Deliverable *newDeliverable = [[Deliverable alloc] initWithBarcode:[NSString stringWithFormat:@"%@",barcode] name:productName manufacturer:manufacturer company:manufacturer quantity:[expectedQuantity integerValue] quantityReceived:[receivedQuantity integerValue] deliveryID:[[DeliveriesModel sharedInstance] CurrentDeliveryID]];
            NSLog(@"%@", newDeliverable.description);
            [parsedDeliverablesList addObject:newDeliverable];
        }
        return parsedDeliverablesList;
    }
    @catch (NSException *ex) {
        NSLog(@"Error occured while trying to parse deliverables json string: %@", [ex description]);
    }
}

- (NSArray *)parseJSONToDeliveryList:(NSString *)jsonString {
    @try {
        jsonString = [jsonString uppercaseString];
        NSDictionary *jsonDict =
        [NSJSONSerialization JSONObjectWithData: [jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                        options: NSJSONReadingMutableContainers
                                          error: Nil];
        NSLog(@"%@", [jsonDict description]);
        NSArray *deliveriesArray = [jsonDict objectForKey:@"DELIVERIES"];
        NSMutableArray *parsedDeliveryList = [[NSMutableArray alloc] init];
        NSLog(@"%@", [deliveriesArray description]);
        for (int i=0;i<deliveriesArray.count;i++) {
            NSDictionary *delivery = deliveriesArray[i];
            //NSString *str = [delivery objectForKey:@"DATE_RECEIVED"];
            //NSDate *dateReceived = [self mfDateFromDotNetJSONString:str];
            //NSLog(@"%@", [dateReceived description]);
            //str = [delivery objectForKey:@"DELIVERY_DATE"];
            //NSDate *dateExpected = [self mfDateFromDotNetJSONString:str];
            //NSLog(@"%@", [dateExpected description]);
            NSString *ID = [NSString stringWithFormat:@"%@", [delivery objectForKey:@"DELIVERY_ID"]];
            NSLog(@"%@", ID);
            NSString *status = [NSString stringWithFormat:@"%@", [delivery objectForKey:@"STATUS"]];
            NSLog(@"%@", status);
            //NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            //[formatter setDateFormat:@"dd/mm/yyyy"];
            //Optionally for time zone converstions
            
            //NSString *stringFromDate = [formatter stringFromDate:dateExpected];
            NSString *dateExpectedStr = [delivery objectForKey:@"DELIVERY_DATE"];// stringFromDate;
            //stringFromDate = [formatter stringFromDate:dateReceived];
            NSString *dateReceivedStr = [delivery objectForKey:@"DATE_RECEIVED"]; //stringFromDate;
            Delivery *newDelivery = [[Delivery alloc] initWithID:ID deliveryDate:dateExpectedStr receivedDate:dateReceivedStr status:status];
            [parsedDeliveryList addObject:newDelivery];
        }
        return parsedDeliveryList;
    }
    @catch (NSException *ex) {
        NSLog(@"Error occured while trying to parse json string: %@", [ex description]);
    }
}

- (void)updateDeliveryList:(void (^)())success failure:(void (^)(NSException *ex))failure {
    @try {
        //TODO: TCP connection here
        TCPConnect *tcpconnect = [[TCPConnect alloc] init];
        [tcpconnect openAndSendRequest:@"d" success:^(NSString *jsonString) {
            _DeliveryList = [self parseJSONToDeliveryList:jsonString];
            NSLog(@"delivery list count %lu", (unsigned long)_DeliveryList.count);
            success();
        }];
        
    } @catch (NSException *ex) {
        NSLog(@"Error occured while updating: %@", [ex description]);
        failure(ex);
    }
}

- (void)updateCurrentDeliverableList:(void (^)())success failure:(void (^)(NSException *ex))failure {
    @try {
        //TODO: TCP connection here
        TCPConnect *tcpconnect = [[TCPConnect alloc] init];
        [tcpconnect openAndSendRequest:[NSString stringWithFormat:@"c %@", _CurrentDeliveryID] success:^(NSString *jsonString) {
            _DeliverablesList = [self parseJSONToDeliverables:jsonString];
            NSLog(@"deliverables list count %lu", (unsigned long)_DeliverablesList.count);
            success();
        }];

    } @catch (NSException *ex) {
        NSLog(@"Error occured while updating: %@", [ex description]);
        failure(ex);
    }
}

- (void)changeCurrentDeliverableList:(NSString *)currentDeliveryID {
    _CurrentDeliveryID = currentDeliveryID;
    _DeliveryList = nil;
}

- (NSArray *)deliveries {
    //temp

    return _DeliveryList;
    //@[[[Delivery alloc] initWithID:@"123456" deliveryDate:@"12/3/2013" receivedDate:@"12/4/2014" status:@"Delivered"]];
    //temp end
}


- (NSArray *)deliverables:(NSString *)deliveryID {
    return _DeliverablesList;
}
- (void)setDelivered:(NSString *)barcode quantityReceived:(int)quantityReceived success:(void (^)())success failure:(void (^)(NSException *ex))failure {
    @try {
        for (Deliverable *del in _DeliverablesList) {
            if ([del.Barcode isEqual:barcode]) {
                del.quantityReceived = quantityReceived;
                [self addChange:@{@"barcode":barcode, @"quantity":[[NSNumber alloc] initWithInt:quantityReceived]}];
                success();
                return;
            }
        }
        NSLog(@"could not find deliverable barcode");
        failure(nil);
    } @catch (NSException *ex) {
        failure(ex);
    }
}

- (void)addChange:(NSDictionary *)changeForDeliverable {
    //e.g. { "delivery_id":"12313", "barcode":"22342", "quantity":3213 }
    [_ChangesList addObject:changeForDeliverable];
}

- (void)updateChangesToServer:(void (^)())success failure:(void (^)(NSException *ex))failure {
    @try {
        TCPConnect *tcpconnect = [[TCPConnect alloc] init];
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{ @"delivery_id" : _CurrentDeliveryID , @"changes" : _ChangesList }
                                                           options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                             error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [tcpconnect openAndSendRequest:[NSString stringWithFormat:@"a%@", jsonString] success:^(NSString *jsonString) {
            if ([jsonString isEqualToString:@"r"]) {
                _ChangesList = [[NSMutableArray alloc] init];
                success();
            }
        }];
    } @catch (NSException *ex) {
        failure(ex);
    }
}

- (void)refreshDeliveriesList {
    
}

@end
