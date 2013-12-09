//
//  DeliveryTableViewController.m
//  YearsWebStore
//
//  Created by Henry Chua on 8/12/13.
//  Copyright (c) 2013 Henry Chua. All rights reserved.
//

#import "DeliveryTableViewController.h"
#import "TCPConnect.h"
#import "DeliveriesModel.h"
#import "DeliverablesTableViewController.h"
#import "DeliveriesCell.h"

@interface DeliveryTableViewController ()
@property (strong, nonatomic) TCPConnect *tcpconnect;
@property (assign, nonatomic) int numberOfDeliveries;
@property (strong, nonatomic) NSString *currentDeliveryIDSelected;
@property (strong, nonatomic) NSArray *DeliveryList;
@end

@implementation DeliveryTableViewController

- (IBAction)testing:(id)sender {
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    [self refresh:refreshControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    
    [[DeliveriesModel sharedInstance] updateDeliveryList:^{
        _DeliveryList = [[NSArray alloc] initWithArray:[[DeliveriesModel sharedInstance] deliveries]];
        _numberOfDeliveries = _DeliveryList.count;
        NSLog(@"number of deliveries %d", _numberOfDeliveries);
        [self.tableView reloadData];
    } failure:^(NSException *ex) {
        NSLog(@"Failed to refreshDeliveryLIST: %@", [ex description]);
    }];
    [refreshControl endRefreshing];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"DeliverablesSegue"]) {
        DeliverablesTableViewController *destination = segue.destinationViewController;
        [destination setcurrentDeliveryID:_currentDeliveryIDSelected];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (!_DeliveryList || _DeliveryList.count == 0) {
        return 1;
    }
    return _numberOfDeliveries;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (!_DeliveryList) {
        return [tableView dequeueReusableCellWithIdentifier:@"LoadingCell" forIndexPath:indexPath];
    } else if (_DeliveryList.count == 0) {
        return [tableView dequeueReusableCellWithIdentifier:@"ListEmptyCell" forIndexPath:indexPath];
    }
    NSString *CellIdentifier = @"DeliveryCellIdentifier";
    DeliveriesCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Delivery *currDelivery = _DeliveryList[indexPath.row];
   
    if(currDelivery == NULL) {
        NSLog(@"curr delivery null");
        
    } else {
        NSLog(@"curr delivery %@", currDelivery.ID);
        
    }
    cell.ID.text = currDelivery.ID;
    cell.Date.text = currDelivery.DeliveryDate;
    cell.Status.text = currDelivery.Status;
    if ([cell.Status.text isEqualToString:@"RECEIVED"]) {
        cell.Status.textColor = [UIColor colorWithRed:63.0f/255.0f green:110.0f/255.0f blue:117.0f/255.0f alpha:1.0f];
        cell.backgroundColor = [UIColor colorWithRed:101.0f/255.0f green:168.0f/255.0f blue:81.0f/255.0f alpha:1.0f];
    } else {
        cell.Status.textColor = [UIColor redColor];
    }
    cell.DateReceived.text = currDelivery.ReceivedDate;
    
    NSLog(@"%@%@%@%@", cell.ID.text, cell.Date.text, cell.Status.text, cell.DateReceived.text);
    NSLog(@"%@%@%@%@", currDelivery.ID, currDelivery.DeliveryDate, currDelivery.Status, currDelivery.ReceivedDate);
    // Configure the cell...
    NSLog(@"cell: %@", [cell description]);
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    @try {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        Delivery *currentDeliverySelected = _DeliveryList[indexPath.row];
        _currentDeliveryIDSelected = currentDeliverySelected.ID;
        [self performSegueWithIdentifier:@"DeliverablesSegue" sender: self];
    } @catch (NSException *ex) {
        NSLog(@"Error: %@", [ex description]);
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
