//
//  DeliverablesTableViewController.m
//  YearsWebStore
//
//  Created by Henry Chua on 8/12/13.
//  Copyright (c) 2013 Henry Chua. All rights reserved.
//

#import "DeliverablesTableViewController.h"
#import "TCPConnect.h"
#import "DeliverablesCell.h"
#import "DeliveriesModel.h"

@interface DeliverablesTableViewController ()

@property (strong, nonatomic) TCPConnect *tcpconnect;
@property (assign, nonatomic) int numberOfDeliverables;
@property (strong, nonatomic) NSArray *listOfDeliverables;
@property (strong, nonatomic) NSString *currentDelivery;
@property (strong, nonatomic) Deliverable *currentDeliveryTapped;
@property (strong, nonatomic) NSIndexPath *indexPathTapped;
@end

@implementation DeliverablesTableViewController

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
    NSLog(@"referesh deiverables");
    if (!_listOfDeliverables) {
        [[DeliveriesModel sharedInstance] updateCurrentDeliverableList:^{
            _listOfDeliverables = [[NSArray alloc] initWithArray:[[DeliveriesModel sharedInstance] deliverables:_currentDelivery]];
            _numberOfDeliverables = _listOfDeliverables.count;
        } failure:^(NSException *ex) {
            NSLog(@"Failed to refreshDeliverabLES LIST: %@", [ex description]);
        }];
    }
    [self.tableView reloadData];
    [refreshControl endRefreshing];
}

- (void)setcurrentDeliveryID:(NSString *)currentDeliveryID {
    _currentDelivery = currentDeliveryID;
    [[DeliveriesModel sharedInstance] changeCurrentDeliverableList:currentDeliveryID];
}

- (IBAction)updateShopWithNewDetails:(id)sender {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Save"
                                                      message:@"Push changes to shop?"
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Confirm", nil];
    [message setAlertViewStyle:UIAlertViewStyleDefault];
    [message setTag:2];
    [message show];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _numberOfDeliverables;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DeliverablesCellIdentifier";
    DeliverablesCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!_listOfDeliverables) {
        UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityView.center=self.view.center;
        [activityView startAnimating];
        [self.view addSubview:activityView];
        return [tableView dequeueReusableCellWithIdentifier:@"LoadingCell" forIndexPath:indexPath];
    } else if (_listOfDeliverables.count == 0) {
        return [tableView dequeueReusableCellWithIdentifier:@"ListEmptyCell" forIndexPath:indexPath];
    }
    @try {
        Deliverable *currDeliverable = _listOfDeliverables[indexPath.row];
        cell.Barcode.text = currDeliverable.Barcode;
        cell.Name.text = currDeliverable.Name;
        cell.Manufacturer.text = currDeliverable.Manufacturer;
        cell.Quantity.text = [NSString stringWithFormat:@"%i",currDeliverable.quantity];
        cell.QuantityReceived.text = [NSString stringWithFormat:@"%i",currDeliverable.quantityReceived];
        if ([cell.QuantityReceived.text isEqualToString:cell.Quantity.text]) {
            cell.Quantity.textColor = [UIColor greenColor];
            cell.QuantityReceived.textColor = [UIColor greenColor];
        } else {
            cell.QuantityReceived.textColor = [UIColor redColor];
        }
        return cell;
    } @catch (NSException *ex) {
        return [tableView dequeueReusableCellWithIdentifier:@"LoadingCell" forIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    @try {
        _indexPathTapped = indexPath;
        _currentDeliveryTapped = _listOfDeliverables[indexPath.row];
        //show alertview
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:_currentDeliveryTapped.Name
                                                          message:[NSString stringWithFormat:@"Expected Quantity: %d", _currentDeliveryTapped.quantity]
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:@"Confirm", nil];
        [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
        UITextField *textField = [message textFieldAtIndex:0];
        textField.text = [NSString stringWithFormat:@"%d", _currentDeliveryTapped.quantity];
        textField.keyboardType = UIKeyboardTypeNumberPad;
        [message setTag:1];
        [message show];
    } @catch (NSException *ex) {
        NSLog(@"Error: %@", [ex description]);
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if (alertView.tag == 1) {
        NSString *inputText = [[alertView textFieldAtIndex:0] text];
        if( [inputText intValue] >= 0 && [inputText intValue] <= _currentDeliveryTapped.quantity )
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if (alertView.tag == 1) {
        if([title isEqualToString:@"Confirm"])
        {
            UITextField *userInput = [alertView textFieldAtIndex:0];
            [[DeliveriesModel sharedInstance] setDelivered:_currentDeliveryTapped.Barcode quantityReceived:[userInput.text intValue] success:^{
                
                [self.tableView reloadData];
                [self.tableView selectRowAtIndexPath:_indexPathTapped animated:YES scrollPosition:UITableViewScrollPositionNone];
                [self.tableView deselectRowAtIndexPath:_indexPathTapped animated:YES];
            } failure:^(NSException *ex) {
                ;
            }];
            
        } else {
            [self.tableView deselectRowAtIndexPath:_indexPathTapped animated:YES];
        }
    } else if (alertView.tag == 2) {
        if([title isEqualToString:@"Confirm"]) {
            NSLog(@"confirm clicked");
            [[DeliveriesModel sharedInstance] updateChangesToServer:^{
                [[DeliveriesModel sharedInstance] updateCurrentDeliverableList:^{
                    [self.tableView reloadData];
                } failure:^(NSException *ex) {
                    NSLog(@"Error occured when updating deliverablylist");
                }];
            } failure:^(NSException *ex) {
                NSLog(@"Error occured when updating changes");
            }];
        }
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
