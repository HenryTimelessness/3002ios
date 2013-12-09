//
//  TCPConnect.m
//  YearsWebStore
//
//  Created by Henry Chua on 8/12/13.
//  Copyright (c) 2013 Henry Chua. All rights reserved.
//

#import "TCPConnect.h"
#import "SKTCPSocket.h"
#import "ShopListModel.h"

@interface TCPConnect ()
    
@end
@implementation TCPConnect

- (void)simulateOpenAndSendRequest:(NSString *)request success:(void (^)(NSString *jsonString))success {
    if ([request isEqualToString:@"d"]) {
        NSString *str = @"{\"deliveries\":[{\"delivery_id\":100001,\"delivery_date\":\"\/Date(1382803200000)\/\",\"status\":\"Pending\",\"date_received\":\"\/Date(1386509716000)\/\"},{\"delivery_id\":100002,\"delivery_date\":\"\/Date(1382889600000)\/\",\"status\":\"Received\",\"date_received\":\"\/Date(1386509716000)\/\"},{\"delivery_id\":100003,\"delivery_date\":\"\/Date(1417190400000)\/\",\"status\":\"Pending\",\"date_received\":\"\/Date(1386509716000)\/\"}]}";
            //@"{\"deliveries\":[{\"delivery_id\":100001,\"delivery_date\":\"Date(1382803200000)\",\"status\":\"Pending\",\"date_received\":\"Date(1386509716000)\"},{\"delivery_id\":100002,\"delivery_date\":\"Date(1382889600000)\",\"status\":\"Received\",\"date_received\":\"Date(1386509716000)\"},{\"delivery_id\":100003,\"delivery_date\":\"Date(1417190400000)\",\"status\":\"Pending\",\"date_received\":\"Date(1386509716000)\"}]}";
        success(str);
    } else if ([request isEqualToString:@"c"]) {
        NSString *str = @"{\"delivery_content\":[{\"barcode\":59030623,\"expected_quantity\":3,\"received_quantity\":0,\"item_info\":{\"product_name\":\"BHC Golf Visor With Magnetic Marker\",\"manufacturer\":\"Kit E Kat\"}},{\"barcode\":38545539,\"expected_quantity\":5,\"received_quantity\":0,\"item_info\":{\"product_name\":\"Brushed Heavy Cotton Visor With Sandwich\",\"manufacturer\":\"Burgen\"}},{\"barcode\":58816051,\"expected_quantity\":20,\"received_quantity\":0,\"item_info\":{\"product_name\":\"Metal travel alarm clock\",\"manufacturer\":\"Cadbury\"}},{\"barcode\":32100416,\"expected_quantity\":70,\"received_quantity\":0,\"item_info\":{\"product_name\":\"Memo Minders\",\"manufacturer\":\"Omo\"}}]}";
        success(str);
    }
}


- (void)openAndSendRequest:(NSString *)request success:(void (^)(NSString *jsonString))success {
    // open a connection
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        @try {
            SKTCPSocket * socket = [[SKTCPSocket alloc] initWithRemoteHost:@"172.28.177.33" port:13000];
            //SKTCPSocket * socket = [[SKTCPSocket alloc] initWithRemoteHost:[[[ShopListModel sharedInstance] currentSelectedShop] IPAddress] port:[[[[ShopListModel sharedInstance] currentSelectedShop] Port] intValue]];
            // write data
            NSString* str = request;
            NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
            [socket writeData:data];
            // read data
            NSMutableString * message = [NSMutableString string];
            
            while (true) {
                @try {
                    NSData * aByte = [socket readData:1];
                    NSString * pStr = [[NSString alloc] initWithData:aByte encoding:NSUTF8StringEncoding];
                    if ([pStr isEqual:@"\n"]) {
                        break;
                    }
                    [message appendFormat:@"%@", pStr];
                } @catch (NSException * readError) {
                    break;
                }
            }
            //NSData * someData = [socket readData:4];
            //str = [[NSString alloc] initWithData:someData encoding:NSUTF8StringEncoding];
            NSLog(@"here %@", message);
            // close the socket
            [socket close];
            success(message);
        }
        @catch (NSException *ex) {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:[ex description]
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            NSLog(@"Back on main thread");
        });
    });
    
}

-(void)open {
    // open a connection
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        @try {
            SKTCPSocket * socket = [[SKTCPSocket alloc] initWithRemoteHost:@"172.28.177.53" port:13000];
            // write data
            NSString* str = @"lolololol";
            NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
            [socket writeData:data];
            // read data
            NSMutableString * message = [NSMutableString string];
        
            while (true) {
                @try {
                    NSData * aByte = [socket readData:1];
                    NSString * pStr = [[NSString alloc] initWithData:aByte encoding:NSUTF8StringEncoding];
                    if ([pStr isEqual:@"\n"]) {
                        break;
                    }
                    [message appendFormat:@"%@", pStr];
                } @catch (NSException * readError) {
                    break;
                }
            }
            //NSData * someData = [socket readData:4];
            //str = [[NSString alloc] initWithData:someData encoding:NSUTF8StringEncoding];
            NSLog(@"here %@", message);
            // close the socket
            [socket close];
        }
        @catch (NSException *ex) {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:[ex description]
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            NSLog(@"Back on main thread");
        });
    });
}

@end
