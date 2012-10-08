//
//  SettingsView.h
//  tnav
//
//  Created by Chris on 10/29/11.
//  Copyright 2011 csugrue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewEditLocations.h"
#import "CustomCells.h"
#import "UserSettingsManager.h"
#import "ViewLogIn.h"

@interface SettingsView : UIViewController <UITableViewDataSource, UITableViewDelegate>{
	
	IBOutlet UITableView *mySettings;
	NSArray *settingsGroupA;
	NSArray *settingsGroupB;
	
	BOOL bSaveACopy;
	BOOL bLoggedIn;
	BOOL bDeleteOnUpload;
	BOOL bInQuickSaveMode;
	
	NSString * username;
	
	UISwitch * switches[4];
	
}

@property (nonatomic, retain) IBOutlet UITableView *mySettings;

// actions after a switch is changed value
-(void) switchChanged:(id)sender;

// alert actions for reset all
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex ;

// reset all setting values
-(void) resetAll;

@end
