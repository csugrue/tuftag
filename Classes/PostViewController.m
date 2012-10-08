//
//  PostViewController.m
//  tnav
//
//  Created by Chris on 10/8/11.
//  Copyright 2011 csugrue. All rights reserved.
//

#import "PostViewController.h"
#import "tnavAppDelegate.h"


@implementation PostViewController

@synthesize viewUpload;
@synthesize viewLogin;
//@synthesize viewCitySelector;
@synthesize bLoggedIn;
@synthesize mydelegate;


-(void) viewDidLoad{
	
	NSLog(@"Post view did load.\n");
	
	[super viewDidLoad];
	
		
	 [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackTranslucent];
	 
	 //------ display settings
	[self setNavigationBarHidden:YES]; 
	//self.bFirstLoad = true;
	
	//--------  NEW STUFF
	viewUpload = [[ViewUploadWithData alloc] initWithNibName:@"ViewUploadWithData" bundle:nil];
	[viewUpload setDelegate:self];
	
	viewLogin	= [[ViewLogIn alloc] initWithNibName:@"ViewLogIn" bundle:nil];
	[viewLogin setDelegate:self];
	
	viewLink = [[ViewLinkem alloc] initWithNibName:@"ViewLinkem" bundle:nil];
	[viewLink setDelegate:self];

	// check user settings to see if logged-in
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	// temp  clear
	//[prefs removeObjectForKey:@"user"];
	
	NSString *myLogString = [prefs stringForKey:@"user"];
	if(!myLogString)
	{
		bLoggedIn = false;
		[self pushViewController:viewLogin animated:NO];
	}else{ 
		bLoggedIn = true;
		[self pushViewController:viewUpload animated:NO];
	}
		
}

-(void) viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
}

-(void) viewWillAppear:(BOOL)animated{
    
	NSLog(@"Post view will appear.\n");
	
	[super viewWillAppear:animated];
	
	// check if user is logged in
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *myString    = [prefs stringForKey:@"user"];
	
	if(!myString) bLoggedIn = false;
	else          bLoggedIn = true;
	
	
	//---old---
	// check user preferences
	/*bSaveACopy = true;
	UserSettingsManager * userSettings = [UserSettingsManager alloc];
	[userSettings loadUserSettings];
	bSaveACopy = [userSettings getSaveACopy];
	[userSettings release];*/
	
}

-(void) cancelLogIn{
	//[self pushViewController:viewUpload animated:YES];
}

//----------------------------------------------------------------- UPLOADING
-(void)upload{
}

//----------------------------------------------------------------- SAVING
/*-(void)save{
	
	//if(!bGrabbedImage) return;
	
	// title + location
	NSString *titleForWrite = @"Put title here";//[viewLabel getTitle];
	if(!titleForWrite || [titleForWrite isEqualToString:@""]) titleForWrite = @"NULL";
	
	NSString *locationForWrite = @"";//[viewLabel getLocation];
	if(!locationForWrite) locationForWrite = @" ";
	
	ImageDataManager * imageDataManager = [ImageDataManager alloc];
	[imageDataManager saveImageAndData:image withTitle:titleForWrite withLocation:locationForWrite withOrientation:orientation];
	[imageDataManager release];
	
}*/

//----------------------------------------------------------------- MISC
-(void)dealloc{
	
	[super dealloc];
	
}

-(void) finishedLogIn{
	
	// push link em
	//[self pushViewController:viewLink animated:YES];
	
	// go to camera / post
	[self pushViewController:viewUpload animated:YES];

}

-(void) gotoPost{
	[self pushViewController:viewUpload animated:YES];
}

@end
