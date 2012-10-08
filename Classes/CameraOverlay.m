//
//  CameraOverlay.m
//  tnav
//
//  Created by Chris on 10/30/11.
//  Copyright 2011 csugrue. All rights reserved.
//

#import "CameraOverlay.h"


@implementation CameraOverlay

@synthesize grabButton, bullsEye,photoLibButton,flashButton;

-(id)initWithFrame:(CGRect)frame {
    
	if (self = [super initWithFrame:frame]) {
        
		// Clear the background of the overlay:
		//self.opaque = NO;
		//self.backgroundColor = [UIColor clearColor];
		
				
		
    }
    return self;
}



@end
