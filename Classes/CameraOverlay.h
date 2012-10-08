//
//  CameraOverlay.h
//  tnav
//
//  Created by Chris on 10/30/11.
//  Copyright 2011 csugrue. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CameraOverlay : UIView{

	UIButton *grabButton;
	UIButton *bullsEye;
	UIButton *photoLibButton;
	UIButton *flashButton;
}

@property (nonatomic, retain) UIButton *grabButton;
@property (nonatomic, retain)UIButton *bullsEye;
@property (nonatomic, retain)UIButton *photoLibButton;
@property (nonatomic, retain)UIButton *flashButton;

@end
