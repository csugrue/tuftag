//
//  ViewImage.h
//  tnav
//
//  Created by Chris on 10/27/11.
//  Copyright 2011 csugrue. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewImage : UIViewController {

	IBOutlet UIImageView * selectedImage;
}

@property (nonatomic, retain) IBOutlet UIImageView * selectedImage;

-(IBAction)closeMe:(id)sender;

@end
