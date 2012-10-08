//
//  PostViewController.h
//  tnav
//
//  Created by Chris on 10/8/11.
//  Copyright 2011 csugrue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewUploadWithData.h"
#import "ViewLogIn.h"
#import "ViewLinkem.h"
#import "CameraOverlay.h"
#import "UserSettingsManager.h"

@protocol PostViewControllerDelegate;

@interface PostViewController : UINavigationController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,ViewUploadWithDataDelegate,ViewLogInDelegate,ViewLinkemDelegate>{

	id<PostViewControllerDelegate>delegate;
	
	//------ NEW STUFF
	ViewUploadWithData * viewUpload;
	ViewLogIn * viewLogin;
	ViewLinkem * viewLink;
	
	//----- app settings
	BOOL bFirstLoad;
	BOOL bLoggedIn;
	BOOL bSaveACopy;
	NSString * defaultCity;
	
	
	
}

@property (assign)	id<PostViewControllerDelegate>mydelegate;
@property (nonatomic, retain) ViewUploadWithData * viewUpload;
@property (nonatomic, retain)  ViewLogIn * viewLogin;
@property BOOL bLoggedIn;


-(void) cancelLogIn;
-(void) finishedLogIn;
-(void) gotoPost;


@end

@protocol PostViewControllerDelegate <UINavigationControllerDelegate> 
@end