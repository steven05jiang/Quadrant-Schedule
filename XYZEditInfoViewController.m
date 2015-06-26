//
//  XYZEditInfoViewController.m
//  Quadrant Schedule
//
//  Created by Wei Jiang on 6/5/15.
//  Copyright (c) 2015 Wei. All rights reserved.
//

#import "XYZEditInfoViewController.h"
#import "DBManager.h"

@interface XYZEditInfoViewController ()
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic) int importance;
@property (nonatomic) int emergency;


-(void)loadInfoToEdit;
@end

@implementation XYZEditInfoViewController

-(void)loadInfoToEdit{
    // Create the query.
    NSString *query = [NSString stringWithFormat:@"select * from mission where id=%d", self.recordIDToEdit];
    
    // Load the relevant data.
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    self.importance = 0;
    self.emergency = 0;
    // Set the loaded data to the textfields.
    self.txtTitle.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"title"]];
    self.txtNotes.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"note"]];
    self.importance = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"importance"]] intValue];
    self.emergency = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"emergency"]] intValue];
    if (self.importance == 1) {
        [self.Impt setOn:YES];
    }
    else
        [self.Impt setOn:NO];
    if (self.emergency == 1) {
        [self.Emg setOn:YES];
    }
    else
        [self.Emg setOn:NO];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)switchFieldShouldReturn:(UISwitch *)switchField{
    [switchField resignFirstResponder];
    return YES;
}

-  (IBAction)saveInfo:(id)sender {
    // Prepare the query string.
    // If the recordIDToEdit property has value other than -1, then create an update query. Otherwise create an insert query.
    NSString *query;
    
    if ([self.Impt isOn]){
        self.importance = 1;
    }
    else{
        self.importance = 0;
    }
    if ([self.Emg isOn]){
        self.emergency = 1;
    }
    else{
        self.emergency = 0;
    }
    
    if (self.recordIDToEdit == -1) {
        query = [NSString stringWithFormat:@"insert into mission values(null, '%@', '%@', %d, %d)", self.txtTitle.text, self.txtNotes.text, self.importance, self.emergency];
    }
    else{
        query = [NSString stringWithFormat:@"update mission set title='%@', note='%@', importance=%d, emergency=%d where id=%d", self.txtTitle.text, self.txtNotes.text, self.importance, self.emergency, self.recordIDToEdit];
    }
    
    // Execute the query.
    [self.dbManager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        
        // Inform the delegate that the editing was finished.
        [self.delegate editingInfoWasFinished];
        
        // Pop the view controller.
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSLog(@"Could not execute the query.");
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.txtTitle.delegate = self;
    self.txtNotes.delegate = self;
//    // Initialize the dbManager object.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"QSdb.sql"];
    
    // Check if should load specific record for editing.
    if (self.recordIDToEdit != -1) {
        // Load the record with the specific ID from the database.
        [self.navigationItem setTitle:@"Edit Schedule"];
        [self loadInfoToEdit];
    }
    else{
        [self.navigationItem setTitle:@"New Schedule"];
        switch (self.quaNum) {
            case 1:
                [self.Emg setOn:NO];
                [self.Impt setOn:NO];
                break;
            case 2:
                [self.Emg setOn:YES];
                [self.Impt setOn:NO];
                break;
            case 3:
                [self.Emg setOn:NO];
                [self.Impt setOn:YES];
                break;
            case 4:
                [self.Emg setOn:YES];
                [self.Impt setOn:YES];
                break;
            default:
                break;
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
