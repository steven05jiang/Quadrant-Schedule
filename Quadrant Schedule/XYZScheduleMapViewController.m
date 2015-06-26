//
//  XYZScheduleMapViewController.m
//  Quadrant Schedule
//
//  Created by Wei Jiang on 6/9/15.
//  Copyright (c) 2015 Wei. All rights reserved.
//

#import "XYZScheduleMapViewController.h"
#import "DBManager.h"

@interface XYZScheduleMapViewController ()

@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *arrMission;
@property (nonatomic) int recordIDToEdit;
@property (nonatomic) int quaNum;


-(void)loadData;
@end

@implementation XYZScheduleMapViewController

- (IBAction)detail:(id)sender{
    self.quaNum = [sender tag];
    [self performSegueWithIdentifier:@"detail" sender:self];
}

- (IBAction)addNewRecord:(id)sender {
    // Before performing the segue, set the -1 value to the recordIDToEdit. That way we'll indicate that we want to add a new record and not to edit an existing one.
    self.recordIDToEdit = -1;
    
    // Perform the segue.
    [self performSegueWithIdentifier:@"idSegueAddInfo" sender:self];
}


-(void)editingInfoWasFinished{
    // Reload the data.
    [self loadData];
}

-(void)detailViewFinished{
    [self loadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier  isEqual: @"idSegueAddInfo"]) {
        XYZEditInfoViewController *editInfoViewController = [segue destinationViewController];
        editInfoViewController.delegate = self;
        editInfoViewController.recordIDToEdit = self.recordIDToEdit;
        editInfoViewController.quaNum = 1;
    }
    else if ([segue.identifier isEqual:@"detail"]){
        XYZTableViewController *tableViewController = [segue destinationViewController];
        tableViewController.delegate = self;
        tableViewController.quaNum = self.quaNum;
    }
}

-(void)loadData{
    // Form the query.
    NSString *query = @"select * from mission";
    NSString *query1 = @"select * from mission where importance=0 and emergency=0";
    NSString *query2 = @"select * from mission where importance=0 and emergency=1";
    NSString *query3 = @"select * from mission where importance=1 and emergency=0";
    NSString *query4 = @"select * from mission where importance=1 and emergency=1";
    
    // Get the results.
//    if (self.arrMission != nil) {
//        self.arrMission = nil;
//    }
    self.arrMission = nil;
    self.arrFir = nil;
    self.arrSec = nil;
    self.arrThir = nil;
    self.arrFour = nil;
    self.arrMission = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    self.arrFir = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query1]];
    self.arrSec = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query2]];
    self.arrThir = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query3]];
    self.arrFour = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query4]];
    
    // Reload the table view.
    [self.firstQua reloadData];
    [self.secondQua reloadData];
    [self.thirdQua reloadData];
    [self.fourthQua reloadData];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [self initWithStyle:style];
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
    
    self.firstQua.delegate = self;
    self.firstQua.dataSource = self;
    self.secondQua.delegate = self;
    self.secondQua.dataSource = self;
    self.thirdQua.delegate = self;
    self.thirdQua.dataSource = self;
    self.fourthQua.delegate = self;
    self.fourthQua.dataSource = self;
    
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
    NSInteger rowNumber = 5;
    if (tableView == self.firstQua && self.arrFir.count < 5) {
        rowNumber = self.arrFir.count;
    }
    if (tableView == self.secondQua && self.arrSec.count < 5) {
        rowNumber = self.arrSec.count;
    }
    if (tableView == self.thirdQua && self.arrThir.count < 5) {
        rowNumber = self.arrThir.count;
    }
    if (tableView == self.fourthQua && self.arrFour.count < 5) {
        rowNumber = self.arrFour.count;
    }
    return rowNumber;

}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 60.0;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    // Dequeue the cell.
    if (tableView == self.firstQua) {
        [self.firstQua setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        cell = [tableView dequeueReusableCellWithIdentifier:@"idCellMap1" forIndexPath:indexPath];
        NSInteger indexOfTitle = [self.dbManager.arrColumnNames indexOfObject:@"title"];
        
        // Set the loaded data to the appropriate cell labels.
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [[self.arrFir objectAtIndex:indexPath.row]objectAtIndex:indexOfTitle]];
    }
    
    else if(tableView == self.secondQua){
        [self.secondQua setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        cell = [tableView dequeueReusableCellWithIdentifier:@"idCellMap2" forIndexPath:indexPath];
        NSInteger indexOfTitle = [self.dbManager.arrColumnNames indexOfObject:@"title"];
        
        // Set the loaded data to the appropriate cell labels.
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [[self.arrSec objectAtIndex:indexPath.row]objectAtIndex:indexOfTitle]];
    }
    
    else if (tableView == self.thirdQua){
        [self.thirdQua setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        cell = [tableView dequeueReusableCellWithIdentifier:@"idCellMap3" forIndexPath:indexPath];
        NSInteger indexOfTitle = [self.dbManager.arrColumnNames indexOfObject:@"title"];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [[self.arrThir objectAtIndex:indexPath.row] objectAtIndex:indexOfTitle]];
    }
    
    else if (tableView == self.fourthQua){
        [self.fourthQua setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        cell = [tableView dequeueReusableCellWithIdentifier:@"idCellMap4" forIndexPath:indexPath];
        NSInteger indexOfTitle = [self.dbManager.arrColumnNames indexOfObject:@"title"];
        
        // Set the loaded data to the appropriate cell labels.
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [[self.arrFour objectAtIndex:indexPath.row]objectAtIndex:indexOfTitle]];
    }
        return cell;
}


@end
