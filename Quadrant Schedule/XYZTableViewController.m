//
//  XYZTableViewController.m
//  Quadrant Schedule
//
//  Created by Wei Jiang on 6/5/15.
//  Copyright (c) 2015 Wei. All rights reserved.
//

#import "XYZTableViewController.h"
#import "DBManager.h"


@interface XYZTableViewController ()

@property (nonatomic, strong) DBManager *dbManager;

@property (nonatomic, strong) NSArray *arrMission;
@property (nonatomic) int recordIDToEdit;


-(void)loadData;

@end

@implementation XYZTableViewController

- (IBAction)addNewRecord:(id)sender {
    // Before performing the segue, set the -1 value to the recordIDToEdit. That way we'll indicate that we want to add a new record and not to edit an existing one.
    self.recordIDToEdit = -1;
    
    // Perform the segue.
    [self performSegueWithIdentifier:@"idSegueEditInfo" sender:self];
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    // Get the record ID of the selected name and set it to the recordIDToEdit property.
    self.recordIDToEdit = [[[self.arrMission objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
    
    // Perform the segue.
    [self performSegueWithIdentifier:@"idSegueEditInfo" sender:self];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the selected record.
        // Find the record ID.
        int recordIDToDelete = [[[self.arrMission objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
        
        // Prepare the query.
        NSString *query = [NSString stringWithFormat:@"delete from mission where id=%d", recordIDToDelete];
        
        // Execute the query.
        [self.dbManager executeQuery:query];
        
        // Reload the table view.
        [self loadData];
        [self.delegate detailViewFinished];
    }
}

-(void)editingInfoWasFinished{
    // Reload the data.
    [self loadData];
    [self.delegate detailViewFinished];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    XYZEditInfoViewController *editInfoViewController = [segue destinationViewController];
    editInfoViewController.delegate = self;
    editInfoViewController.recordIDToEdit = self.recordIDToEdit;
    editInfoViewController.quaNum = self.quaNum;
}

-(void)loadData{
    // Form the query.
    NSString *query1 = @"select * from mission where importance=0 and emergency=0";
    NSString *query2 = @"select * from mission where importance=0 and emergency=1";
    NSString *query3 = @"select * from mission where importance=1 and emergency=0";
    NSString *query4 = @"select * from mission where importance=1 and emergency=1";
    
    // Get the results.
    switch (self.quaNum) {
        case 1:
            [self.navigationItem setTitle:@"Don't Worry"];
            self.arrMission = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query1]];
            break;
        case 2:
            [self.navigationItem setTitle:@"Use Spare Time"];
            self.arrMission = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query2]];
            break;
        case 3:
            [self.navigationItem setTitle:@"Ready to Go"];
            self.arrMission = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query3]];
            break;
        case 4:
            [self.navigationItem setTitle:@"Action Now!!"];
            self.arrMission = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query4]];
            break;
        default:
            break;
    }
    
    // Reload the table view.
    [self.tblMS reloadData];
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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    // Make self the delegate and datasource of the table view.
    self.tblMS.delegate = self;
    self.tblMS.dataSource = self;
    
    // Initialize the dbManager property.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"QSdb.sql"];
    [self loadData];
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
    return self.arrMission.count;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 60.0;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Dequeue the cell.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCellRecord" forIndexPath:indexPath];
    
    NSInteger indexOfTitle = [self.dbManager.arrColumnNames indexOfObject:@"title"];
    NSInteger indexOfNotes = [self.dbManager.arrColumnNames indexOfObject:@"note"];
    
    // Set the loaded data to the appropriate cell labels.
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [[self.arrMission objectAtIndex:indexPath.row] objectAtIndex:indexOfTitle]];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[self.arrMission objectAtIndex:indexPath.row] objectAtIndex:indexOfNotes]];
    
    return cell;
    
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
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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


@end
