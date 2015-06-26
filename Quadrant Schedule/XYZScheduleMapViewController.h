//
//  XYZScheduleMapViewController.h
//  Quadrant Schedule
//
//  Created by Wei Jiang on 6/9/15.
//  Copyright (c) 2015 Wei. All rights reserved.
//https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/TableView_iPhone/CreateConfigureTableView/CreateConfigureTableView.html

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIViewController.h>
#import <UIKit/UITableView.h>
#import <UIKit/UIKitDefines.h>
#import "XYZEditInfoViewController.h"
#import "XYZTableViewController.h"

@interface XYZScheduleMapViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,EditInfoViewControllerDelegate,DetailInfoDelegate>

@property (weak, nonatomic) IBOutlet UITableView *firstQua;
@property (weak, nonatomic) IBOutlet UITableView *secondQua;
@property (weak, nonatomic) IBOutlet UITableView *thirdQua;
@property (weak, nonatomic) IBOutlet UITableView *fourthQua;
@property (nonatomic, strong) NSArray *arrFir;
@property (nonatomic, strong) NSArray *arrSec;
@property (nonatomic, strong) NSArray *arrThir;
@property (nonatomic, strong) NSArray *arrFour;

- (IBAction)addNewRecord:(id)sender;
- (IBAction)detail:(id)sender;
- (id)initWithStyle:(UITableViewStyle)style;


@end
