//
//  ViewLogIn.h
//  tufttag
//
//  Created by Chris on 10/7/11.
//  Copyright 2011 csugrue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import <AVFoundation/AVFoundation.h>
#import "TPKeyboardAvoidingScrollView.h"

@protocol ViewLogInDelegate;

@interface ViewLogIn : UIViewController<UITextFieldDelegate> {
	
	//IBOutlet  UITextField *userTextField;
	//IBOutlet  UITextField *pwdTextField;
	//IBOutlet  UITextField *emailTextField;

	IBOutlet  UIButton * logInButton;
	//IBOutlet  UIButton * logOutButton;

	IBOutlet  UILabel * userLabel;
	IBOutlet  UILabel * pwdLabel;
	
	IBOutlet  UILabel * loggedInAs;

	NSString * username;
	NSString * pwd;
	
	
	id<ViewLogInDelegate> delegate;

}

@property (nonatomic, retain) IBOutlet UITextField * userTextField;
@property (nonatomic, retain) IBOutlet UITextField * pwdTextField;
@property (nonatomic, retain) IBOutlet UITextField * emailTextField;
@property (nonatomic, retain) IBOutlet UIButton * logInButton;
@property (nonatomic, retain) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UILabel * userLabel;
@property (nonatomic, retain) IBOutlet UILabel * pwdLabel;
@property (nonatomic, retain) IBOutlet UILabel * loggedInAs;
@property (nonatomic, retain) AVAudioPlayer *player_gotime;
@property (assign)	id<ViewLogInDelegate>delegate;

-(IBAction)setPwdSecure:(id)sender;

-(IBAction)userCloseKeyboard:(id)sender;
-(IBAction)pwdCloseKeyboard:(id)sender;

-(IBAction)buttonClick:(id)sender;

-(void)logInRequestFinished:(ASIHTTPRequest *)request;
-(void)logInRequestFailed:(ASIHTTPRequest *)request;

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex ;

@end


@protocol ViewLogInDelegate <NSObject>
@optional
-(void) cancelLogIn;
-(void) gotoLinkem;
-(void) finishedLogIn;
@end