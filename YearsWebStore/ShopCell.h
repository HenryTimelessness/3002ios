//
//  ShopCell.h
//  YearsWebStore
//
//  Created by Henry Chua on 8/12/13.
//  Copyright (c) 2013 Henry Chua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *ID;
@property (weak, nonatomic) IBOutlet UILabel *Address;
@property (weak, nonatomic) IBOutlet UILabel *IPAddress;
@property (weak, nonatomic) IBOutlet UILabel *Status;

@end
