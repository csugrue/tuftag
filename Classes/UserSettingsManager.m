//
//  UserSettingsManager.m
//  tnav
//
//  Created by Chris on 11/5/11.
//  Copyright 2011 csugrue. All rights reserved.
//

#import "UserSettingsManager.h"


@implementation UserSettingsManager


-(void) loadUserSettings{
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	bSaveACopy       = true;
	bLoggedIn        = true;
	bInQuickSaveMode = true;
	bDeleteOnUpload  = true;
	
	NSString *saveACopy = [prefs stringForKey:@"saveCopy"];
	if(!saveACopy)	[prefs setObject:@"ON" forKey:@"saveCopy"];
	else if( [saveACopy isEqualToString:@"OFF"]) bSaveACopy = false;
	
	NSString *stayLoggedIn = [prefs stringForKey:@"stayLoggedIn"];
	if(!stayLoggedIn)	[prefs setObject:@"ON" forKey:@"stayLoggedIn"];
	else if( [stayLoggedIn isEqualToString:@"OFF"]) bLoggedIn = false;
	
	NSString *qSave = [prefs stringForKey:@"quickSave"];
	if(!qSave)	[prefs setObject:@"ON" forKey:@"quickSave"];
	else if( [qSave isEqualToString:@"OFF"]) bInQuickSaveMode = false;
	
	NSString *deleteOnUpload = [prefs stringForKey:@"deleteOnUpload"];
	if(!deleteOnUpload)	[prefs setObject:@"ON" forKey:@"deleteOnUpload"];
	else if( [deleteOnUpload isEqualToString:@"OFF"]) bDeleteOnUpload = false;
	
	username = [prefs stringForKey:@"user"];

}


-(NSString *) getUserName{
	return username;
}

-(BOOL) getStayLoggedIn{
	return bLoggedIn;
}

-(BOOL) getSaveACopy{
	return bSaveACopy;
}

-(BOOL) getQuickSaveMode{
	return (BOOL)bInQuickSaveMode;
}

-(BOOL) getDeleteOnUpload{
	return bDeleteOnUpload;
}


-(void) setUserName:(NSString *) user{
	username = user;
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs removeObjectForKey:@"user"];
	[prefs setObject:username forKey:@"user"];
	
}

-(void) setStayLoggedIn:(BOOL) loggedIn{
	bLoggedIn = loggedIn;
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs removeObjectForKey:@"stayLoggedIn"];
	
	if(loggedIn) [prefs setObject:@"ON" forKey:@"stayLoggedIn"];
	else [prefs setObject:@"OFF" forKey:@"stayLoggedIn"];
}

-(void) setSaveACopy:(BOOL) saveCopy{
	bSaveACopy = saveCopy;
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	if(bSaveACopy) [prefs setObject:@"ON" forKey:@"saveCopy"];
	else [prefs setObject:@"OFF" forKey:@"saveCopy"];
}

-(void) setUseQuickSaveMode:(BOOL)qSaveOn{

	bInQuickSaveMode = qSaveOn;
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	if(bInQuickSaveMode) [prefs setObject:@"ON" forKey:@"quickSave"];
	else [prefs setObject:@"OFF" forKey:@"quickSave"];
}

-(void) setDeleteOnUpload:(BOOL)deleteMe{
	
	bDeleteOnUpload = deleteMe;
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	if(bDeleteOnUpload) [prefs setObject:@"ON" forKey:@"deleteOnUpload"];
	else [prefs setObject:@"OFF" forKey:@"deleteOnUpload"];
}

-(void) setToDefaults{
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	bSaveACopy       = true;
	bLoggedIn        = true;
	bInQuickSaveMode = true;
	bDeleteOnUpload  = true;
	
	[prefs setObject:@"ON" forKey:@"saveCopy"];
	[prefs setObject:@"ON" forKey:@"stayLoggedIn"];
	[prefs setObject:@"ON" forKey:@"quickSave"];
	[prefs setObject:@"ON" forKey:@"deleteOnUpload"];
	
	[prefs removeObjectForKey:@"user"];
}

@end
