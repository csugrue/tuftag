//
//  ViewLinkem.h
//  tnav
//
//  Created by Chris on 5/17/12.
//  Copyright 2012 csugrue. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol ViewLinkemDelegate;


@interface ViewLinkem : UIViewController {
	
	id<ViewLinkemDelegate> delegate;
	IBOutlet  UITextField *flickrTextField;
	IBOutlet  UITextField *instagramTextField;
}

@property (assign)	id<ViewLinkemDelegate>delegate;
@property (nonatomic, retain) IBOutlet UITextField * flickrTextField;
@property (nonatomic, retain) IBOutlet UITextField * instagramTextField;

-(IBAction)linkemClick:(id)sender;
-(IBAction)launchSafari;
-(IBAction)closeKeyboard:(id)sender;

@end

@protocol ViewLinkemDelegate <NSObject>
@optional
-(void) gotoPost;
@end