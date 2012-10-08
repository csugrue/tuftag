//
//  UserSettingsManager.h
//  tnav
//
//  Created by Chris on 11/5/11.
//  Copyright 2011 csugrue. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UserSettingsManager : NSObject {
	
	NSString * username;
	BOOL bLoggedIn;
	BOOL bSaveACopy;
	BOOL bInQuickSaveMode;
	BOOL bDeleteOnUpload;

}

-(void) loadUserSettings;

-(BOOL) getQuickSaveMode;
-(NSString *) getUserName;
-(BOOL) getStayLoggedIn;
-(BOOL) getSaveACopy;
-(BOOL) getDeleteOnUpload;

-(void) setUserName:(NSString *) user;
-(void) setStayLoggedIn:(BOOL) loggedIn;
-(void) setSaveACopy:(BOOL) saveCopy;
-(void) setUseQuickSaveMode:(BOOL) qSaveOn;
-(void) setDeleteOnUpload:(BOOL) deleteMe;

-(void) setToDefaults;

@end
