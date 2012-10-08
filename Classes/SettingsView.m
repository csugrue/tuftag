//
//  SettingsView.m
//  tnav
//
//  Created by Chris on 10/29/11.
//  Copyright 2011 csugrue. All rights reserved.
//

#import "SettingsView.h"


@implementation SettingsView

@synthesize mySettings;

- (void)viewDidLoad {
	
	mySettings.backgroundColor = [UIColor blackColor];
	
	
	settingsGroupA = [[NSArray alloc] initWithObjects:@"Change user",@"Edit locations",@"Save copy to photos",@"Quick save",@"Delete on upload",nil];
	settingsGroupB = [[NSArray alloc] initWithObjects:@"Reset",nil];
	
	
	//get login prefs	
	UserSettingsManager * userSettings = [UserSettingsManager alloc];
	[userSettings loadUserSettings];
	
	bSaveACopy = [userSettings getSaveACopy];
	bLoggedIn  = [userSettings getStayLoggedIn];
	username   = [userSettings getUserName];
	bInQuickSaveMode = [userSettings getQuickSaveMode];
	bDeleteOnUpload  = [userSettings getDeleteOnUpload];
	
	[userSettings release];
	
	for( int i = 0; i < 4; i++)
	{
		switches[i] = [[UISwitch alloc] initWithFrame:CGRectZero];
	}
	
	[super viewDidLoad];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(section==0) 
		return settingsGroupA.count;
	else return settingsGroupB.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// this creates the cells depending on the type
	
	static NSString *CellIdentifier = @"Cell";

	// 0 is cell with arrow, 1 is cell with on/off switch, 2 is default
	int type = 0;
	
	NSString * cellText;
	if(indexPath.section == 0 ) cellText = [settingsGroupA objectAtIndex:indexPath.row];
	else                        cellText = [settingsGroupB objectAtIndex:indexPath.row];
	
	if([cellText isEqualToString:@"Change user"])          type = 0;
	else if([cellText isEqualToString:@"Stay Logged-in"])  type = 1;
	else if([cellText isEqualToString:@"Edit locations"])  type = 0;
	else if([cellText isEqualToString:@"Save copy to photos"])  type = 1;
	else if([cellText isEqualToString:@"Delete on upload"])     type = 1;
	else if([cellText isEqualToString:@"Quick save"])           type = 1;
	else type = 2;
	
	if(type == 0)
	{
		
		CellDisclosure * cell = (CellDisclosure*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			NSArray * topLevelObjects = [ [NSBundle mainBundle] loadNibNamed:@"cellDisclosure" owner:nil options:nil];
			for(id currentObject in topLevelObjects){
				cell = (CellDisclosure*) currentObject;
				break;
			}
		}
		
		if(indexPath.section == 0 ) cell.textLabel.text = [settingsGroupA objectAtIndex:indexPath.row];
		else cell.textLabel.text = [settingsGroupB objectAtIndex:indexPath.row];
		
		return cell;
	
	}else if(type == 1)
	{
		CellOnOff * cell = (CellOnOff*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			
			NSArray * topLevelObjects = [ [NSBundle mainBundle] loadNibNamed:@"cellOnOff" owner:nil options:nil];
			for(id currentObject in topLevelObjects){
				
				cell = (CellOnOff*) currentObject;
				
				//UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
				 //[cell addSubview:switchview];
				
				if([cellText isEqualToString:@"Save copy to photos"]){
					[cell addSubview:switches[0]];
					[switches[0] setOn:bSaveACopy animated:NO];
					[switches[0] addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
					[switches[0] setTag:0];
					cell.accessoryView = switches[0];
				 }else if([cellText isEqualToString:@"Stay Logged-in"]){
					[cell addSubview:switches[1]];
					[switches[1] setOn:bLoggedIn animated:NO];
					[switches[1] addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
					[switches[1] setTag:1];
					cell.accessoryView = switches[1];
				}else if([cellText isEqualToString:@"Quick save"]){
					[cell addSubview:switches[2]];
					[switches[2] setOn:bInQuickSaveMode animated:NO];
					[switches[2] addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
					[switches[2] setTag:2];
					cell.accessoryView = switches[2];
				}else if([cellText isEqualToString:@"Delete on upload"]){
					[cell addSubview:switches[3]];
					[switches[3] setOn:bDeleteOnUpload animated:NO];
					[switches[3] addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
					[switches[3] setTag:3];
					cell.accessoryView = switches[3];
				}	
				//else [switchview setOn:YES animated:NO];
				
				
				

				//[switchview release];
				break;
			}
		}
		
		if(indexPath.section == 0 ) cell.textLabel.text = [settingsGroupA objectAtIndex:indexPath.row];
		else cell.textLabel.text = [settingsGroupB objectAtIndex:indexPath.row];
				
		return cell;
	
	}else{
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) 
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		
		if(indexPath.section == 0 ) cell.textLabel.text = [settingsGroupA objectAtIndex:indexPath.row];
		else cell.textLabel.text = [settingsGroupB objectAtIndex:indexPath.row];
		
		return cell;
	}
	
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// triggers events when a cell is selected
	
	// deselect
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	if(indexPath.section == 0 )
	{
		NSString * rowText = [settingsGroupA objectAtIndex:indexPath.row];
		NSLog(@"current row text: %@\n",rowText);
		if([rowText isEqualToString:@"Edit locations"] )
		{
			NSLog(@"Open edit locations\n");
			ViewEditLocations * viewEditLoc = [[ViewEditLocations alloc] initWithNibName:@"ViewEditLocations" bundle:nil];
			[[self navigationController] pushViewController:viewEditLoc animated:YES];
			[viewEditLoc release];
		}else if([rowText isEqualToString:@"Change user"] )
		{
			NSLog(@"Logout\n");
			ViewLogIn * viewLogIn	= [[ViewLogIn alloc] initWithNibName:@"ViewLogIn" bundle:nil];
			[[self navigationController] pushViewController:viewLogIn animated:YES];
			[viewLogIn release];
		}
	}else if(indexPath.section == 1 )
	{
		NSString * rowText = [settingsGroupB objectAtIndex:indexPath.row];
		if([rowText isEqualToString:@"Reset"])
		{
			NSLog(@"Reset all\n");
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Warning:all settings will be changed and cities deleted." 
														   delegate:self cancelButtonTitle:@"Reset" otherButtonTitles:@"Cancel",nil];
			[alert setTag:0];
			[alert show];
			[alert release];
		}
	}
	
	

}

-(void) switchChanged:(id)sender{
	
	// actions when a switch changes state
	// tags are set when the cell is created
	
	UISwitch * mySwitch = sender;
	if( [mySwitch tag] == 0)
	{
		bLoggedIn = mySwitch.on;
		UserSettingsManager * userSettings = [UserSettingsManager alloc];
		[userSettings setStayLoggedIn:bLoggedIn];	
		[userSettings release];
	}else if( [mySwitch tag] == 1){			
		bSaveACopy = mySwitch.on;
		UserSettingsManager * userSettings = [UserSettingsManager alloc];
		[userSettings setSaveACopy:bSaveACopy];	
		[userSettings release];
	}else if( [mySwitch tag] == 2){		
		bInQuickSaveMode = mySwitch.on;
		UserSettingsManager * userSettings = [UserSettingsManager alloc];
		[userSettings setUseQuickSaveMode:bInQuickSaveMode];	
		[userSettings release];
	}else if( [mySwitch tag] == 3){		
		bDeleteOnUpload = mySwitch.on;
		UserSettingsManager * userSettings = [UserSettingsManager alloc];
		[userSettings setDeleteOnUpload:bDeleteOnUpload];	
		[userSettings release];
	}
}

-(void) resetAll{
	
	// re-copy city list
	ViewEditLocations * viewEditLoc = [ViewEditLocations alloc];
	[viewEditLoc reallyResetCityList];
	[viewEditLoc release];
	
	// set default values
	UserSettingsManager * userSettings = [UserSettingsManager alloc];
	[userSettings setToDefaults];	
	[userSettings release];
	
	bSaveACopy = TRUE;
	bLoggedIn = FALSE;
	bDeleteOnUpload = TRUE;
	bInQuickSaveMode = TRUE;
	
	for( int i = 0; i < 4; i++)
		[switches[i] setOn:YES animated:YES];
}


-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
	if ([alertView tag] == 0) {    // it's the Delete all alert
        if (buttonIndex == 0) {     // and they clicked OK.
            // really delete 
			[self resetAll];
        }
    }
}


-(void) dealloc
{
	[settingsGroupA release];
	[settingsGroupB release];
	
	
	for( int i = 0; i < 4; i++)
		[switches[i] release];
	
	[super dealloc];
}
@end
