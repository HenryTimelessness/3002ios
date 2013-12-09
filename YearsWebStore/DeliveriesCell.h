//
//  DeliveriesCell.h
//  YearsWebStore
//
//  Created by Henry Chua on 8/12/13.
//  Copyright (c) 2013 Henry Chua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeliveriesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *ID;
@property (weak, nonatomic) IBOutlet UILabel *Date;
@property (weak, nonatomic) IBOutlet UILabel *Status;
@property (weak, nonatomic) IBOutlet UILabel *DateReceived;

@end
