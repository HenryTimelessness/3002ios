//
//  DeliverablesCell.h
//  YearsWebStore
//
//  Created by Henry Chua on 8/12/13.
//  Copyright (c) 2013 Henry Chua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeliverablesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *Name;
@property (weak, nonatomic) IBOutlet UILabel *Barcode;
@property (weak, nonatomic) IBOutlet UILabel *Manufacturer;
@property (weak, nonatomic) IBOutlet UILabel *Quantity;
@property (weak, nonatomic) IBOutlet UILabel *QuantityReceived;

@end
