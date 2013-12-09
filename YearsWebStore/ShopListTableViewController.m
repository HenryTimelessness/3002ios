//
//  ShopListTableViewController.m
//  YearsWebStore
//
//  Created by Henry Chua on 8/12/13.
//  Copyright (c) 2013 Henry Chua. All rights reserved.
//

#import "ShopListTableViewController.h"
#import "ShopCell.h"
#import "ShopListModel.h"

@interface ShopListTableViewController ()
@property (assign, nonatomic) int numberOfShops;
@property (strong, nonatomic) NSString *currentShopIDSelected;
@property (strong, nonatomic) NSArray *ShopsList;
@property (strong, nonatomic) Shop *currentShopTapped;
@end

@implementation ShopListTableViewController

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

    _ShopsList = [[NSArray alloc] initWithArray:[[ShopListModel sharedInstance] shops]];
    _numberOfShops = _ShopsList.count;
    
    [self refresh];
}

- (void)refresh {
    [[ShopListModel sharedInstance] updateShopsList:^{
        _ShopsList = [[NSArray alloc] initWithArray:[[ShopListModel sharedInstance] shops]];
        _numberOfShops = _ShopsList.count;
    } failure:^(NSException *ex) {
        NSLog(@"Failed to refresh shops list: %@", [ex description]);
    }];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if (!_ShopsList || _ShopsList.count == 0) {
        return 1;
    }
    return _numberOfShops;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    static NSString *CellIdentifier = @"ShopCellIdentifier";
    ShopCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!_ShopsList) {
        UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityView.center=self.view.center;
        [activityView startAnimating];
        [self.view addSubview:activityView];
        return [tableView dequeueReusableCellWithIdentifier:@"LoadingCell" forIndexPath:indexPath];
    } else if (_ShopsList.count == 0) {
        return [tableView dequeueReusableCellWithIdentifier:@"ListEmptyCell" forIndexPath:indexPath];
    }
    Shop *currShop = _ShopsList[indexPath.row];
    cell.ID.text = currShop.ID;
    cell.Address.text = currShop.Address;
    cell.IPAddress.text = [NSString stringWithFormat:@"%@//%@",currShop.IPAddress, currShop.Port];
    cell.Status.text = currShop.Status;
    if ([currShop.Status isEqualToString:@"Not Connected"]) {
        cell.Status.textColor = [UIColor redColor];
    } else {
        cell.Status.textColor = [UIColor greenColor];
    }
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    @try {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        _currentShopTapped = _ShopsList[indexPath.row];
        //show alertview
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:_currentShopTapped.ID
                                                          message:[NSString stringWithFormat:@"IP/port: %@/%@\nConnect?", _currentShopTapped.IPAddress, _currentShopTapped.Port]
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:@"Yes", nil];
        [message setAlertViewStyle:UIAlertViewStyleDefault];
        [message show];
    } @catch (NSException *ex) {
        NSLog(@"Error: %@", [ex description]);
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Yes"])
    {
        //UITextField *userInput = [alertView textFieldAtIndex:0];
        [[ShopListModel sharedInstance] connectToShop:_currentShopTapped];
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:_currentShopTapped.ID
                                                          message:[NSString stringWithFormat:@"Connected"]
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:@"Ok", nil];
        [message show];
        
        [self refresh];
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
