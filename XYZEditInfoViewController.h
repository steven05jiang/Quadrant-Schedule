//
//  XYZEditInfoViewController.h
//  Quadrant Schedule
//
//  Created by Wei Jiang on 6/5/15.
//  Copyright (c) 2015 Wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditInfoViewControllerDelegate

-(void)editingInfoWasFinished;

@end

@interface XYZEditInfoViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtNotes;
@property (weak, nonatomic) IBOutlet UISwitch *Impt;
@property (weak, nonatomic) IBOutlet UISwitch *Emg;
@property (nonatomic, strong) id<EditInfoViewControllerDelegate> delegate;
@property (nonatomic) int recordIDToEdit;
@property (nonatomic) int quaNum;


- (IBAction)saveInfo:(id)sender;
@end
