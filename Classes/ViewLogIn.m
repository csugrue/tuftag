//
//  ViewLogIn.m
//  tufttag
//
//  Created by Chris on 10/7/11.
//  Copyright 2011 csugrue. All rights reserved.
//

#import "ViewLogIn.h"

NSString * urlLogIn = @"http://tuftag.heroku.com/api/sessions";
NSString * logInResponse = @"Session found.";
NSString * newUserResponse = @"User successfully registered";




@implementation ViewLogIn

@synthesize userTextField;
@synthesize pwdTextField;
@synthesize emailTextField;
@synthesize userLabel,pwdLabel,loggedInAs,logInButton;
@synthesize delegate;
@synthesize player_gotime;
@synthesize scrollView;

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	[self.userTextField setValue:[UIColor colorWithWhite:.2 alpha:1] 
						   forKeyPath:@"_placeholderLabel.textColor"];
	[self.pwdTextField setValue:[UIColor colorWithWhite:.2 alpha:1] 
						   forKeyPath:@"_placeholderLabel.textColor"];
	[self.emailTextField setValue:[UIColor colorWithWhite:.2 alpha:1] 
						   forKeyPath:@"_placeholderLabel.textColor"];
						   
	NSError* err;
	NSURL *url=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"audio_GUN_FIRE.mp3" ofType:nil]];
	player_gotime = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&err];
	
	
	UIImage * btnImagePress = [UIImage imageNamed:@"button20white.png"];
	[logInButton setBackgroundImage:btnImagePress forState:UIControlStateHighlighted];
	[logInButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
	
	
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
	[super viewDidUnload];

}

-(void) viewWillAppear:(BOOL)animated
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *myString = [prefs stringForKey:@"user"];
	if(!myString){
		NSLog(@"username is null\n");
		username = @" ";
	}else{
		username = myString;
	}
	
	[super viewWillAppear:animated];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [scrollView adjustOffsetToIdealIfNeeded];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
	NSLog(@"textFieldShouldReturn");
	
	/*if (textField == emailTextField) {
        [userTextField becomeFirstResponder];
    }
    
    else if (textField == userTextField) {
        [pwdTextField becomeFirstResponder];
    }
    
    else if (textField == pwdTextField) {
        [textField resignFirstResponder];
    }*/
    
    [textField resignFirstResponder];
    
	return YES;
}

-(IBAction)userCloseKeyboard:(id)sender{
	//[userTextField resignFirstResponder];
	//username = userTextField.text;
}

-(IBAction)pwdCloseKeyboard:(id)sender{
	//[pwdTextField resignFirstResponder];
}

-(IBAction)buttonClick:(id)sender{
	
		
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlLogIn]];
	
	NSString *iphoneID = [[UIDevice currentDevice] uniqueIdentifier];

	[request setPostValue:userTextField.text forKey:@"username"];
	[request setPostValue:pwdTextField.text forKey:@"password"];
	[request setPostValue:emailTextField.text forKey:@"email"];
	[request setPostValue:iphoneID forKey:@"device_id" ];
	
	NSLog(@"username - %@",userTextField.text);
	
	
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(logInRequestFinished:)];
	[request setDidFailSelector:@selector(logInRequestFailed:)];
	
	[request startAsynchronous];
	
	[player_gotime play];
	

}


-(void)logInRequestFinished:(ASIHTTPRequest *)request
{
	NSLog(@"finished\n");
	NSLog(@"response - %@",[request responseString]);
	
	if([[request responseString] isEqualToString:logInResponse]
	|| [[request responseString] isEqualToString:newUserResponse])
	{
		//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"LogIn Successful!" 
		//											   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		//[alert setTag:0];
		//[alert show];
		//[alert release]; 
		
		// store user data
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		[prefs removeObjectForKey:@"user"];
		[prefs setObject:userTextField.text forKey:@"user"];
		
		//NSLog(@"login");
		
		[delegate finishedLogIn];

	}else{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"LogIn Failed!" 
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert setTag:1];
		[alert show];
		[alert release]; 

	}

	//[self.parentViewController dismissModalViewControllerAnimated:YES];
	
	// NOTE: go to view picker
	
}

-(void)logInRequestFailed:(ASIHTTPRequest *)request
{
	NSLog(@"failed\n");
	NSLog(@"response - %@",[request responseString]);

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Request Failed!" 
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert setTag:1];
	[alert show];
	[alert release]; 
	
	//[self.parentViewController dismissModalViewControllerAnimated:YES];
	//[delegate gotoLinkem];
	[delegate finishedLogIn];

	
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([alertView tag] == 0) {    // 
        if (buttonIndex == 0) {    // 
            // tell delegate to push post and camera overlay
			[delegate cancelLogIn];
        }
    }else {
		[delegate cancelLogIn];
	}
	
}

-(IBAction)setPwdSecure:(id)sender
{
	//[pwdTextField setSecureTextEntry:YES];
	pwdTextField.enabled = NO;
	pwdTextField.secureTextEntry = YES;
	pwdTextField.enabled = YES;
	[pwdTextField becomeFirstResponder];
	NSLog(@"set secure");
}

- (void)dealloc
{
    [scrollView release];
    [userTextField release];
    [pwdTextField release];
    [emailTextField release];
    [logInButton release];
    [userLabel release];
	[pwdLabel release];
	[loggedInAs release];
	[player_gotime release];
    [super dealloc];
}

@end
