//
//  tnavAppDelegate.h
//  tnav
//
//  Created by Chris on 10/8/11.
//  Copyright 2011 csugrue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostViewController.h"
#import "ViewLogIn.h"
#import <AVFoundation/AVFoundation.h>

@interface tnavAppDelegate : NSObject <UIApplicationDelegate,PostViewControllerDelegate> {
    
    UIWindow *window;
    PostViewController *navigationController;
	//UITabBarController *tabBarController;

}

-(void) changeTab;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet PostViewController *navigationController;
@property (nonatomic, retain) AVAudioPlayer *player;
//@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end

