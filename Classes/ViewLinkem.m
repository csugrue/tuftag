//
//  ViewLinkem.m
//  tnav
//
//  Created by Chris on 5/17/12.
//  Copyright 2012 csugrue. All rights reserved.
//

#import "ViewLinkem.h"

@implementation ViewLinkem

@synthesize delegate;
@synthesize flickrTextField;
@synthesize instagramTextField;

-(void) viewDidLoad{
	[super viewDidLoad];
	[self.flickrTextField setValue:[UIColor darkGrayColor] 
					forKeyPath:@"_placeholderLabel.textColor"];
	[self.instagramTextField setValue:[UIColor darkGrayColor] 
						forKeyPath:@"_placeholderLabel.textColor"];
}

-(IBAction)linkemClick:(id)sender{
	[delegate gotoPost];
}

-(IBAction)launchSafari{
	
	NSURL *url = [NSURL URLWithString:@"http://www.tuftag.com"];
	
	if (![[UIApplication sharedApplication] openURL:url])
		
		NSLog(@"%@%@",@"Failed to open url:",[url description]);
	
}

-(IBAction)closeKeyboard:(id)sender{

	[flickrTextField resignFirstResponder];
	[instagramTextField resignFirstResponder];
}

@end
