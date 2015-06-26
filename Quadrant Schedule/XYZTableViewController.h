//
//  XYZTableViewController.h
//  Quadrant Schedule
//
//  Created by Wei Jiang on 6/5/15.
//  Copyright (c) 2015 Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYZEditInfoViewController.h"

@protocol DetailInfoDelegate

- (void) detailViewFinished;

@end


@interface XYZTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, EditInfoViewControllerDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tblMS;

- (IBAction)addNewRecord:(id)sender;
@property (nonatomic, strong) id<DetailInfoDelegate> delegate;
@property (nonatomic) int quaNum;

@end
