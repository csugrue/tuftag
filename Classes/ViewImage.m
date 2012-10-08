//
//  ViewImage.m
//  tnav
//
//  Created by Chris on 10/27/11.
//  Copyright 2011 csugrue. All rights reserved.
//

#import "ViewImage.h"


@implementation ViewImage

@synthesize selectedImage;

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.selectedImage setFrame:CGRectMake(0, 0, 360, 480)]; //notice this is OFF screen!

}

-(IBAction)closeMe:(id)sender{
	[self dismissModalViewControllerAnimated:YES];
}

@end
