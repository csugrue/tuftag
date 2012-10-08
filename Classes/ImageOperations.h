//
//  imageOperations.h
//  tnav
//
//  Created by Chris on 10/29/11.
//  Copyright 2011 csugrue. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ImageOperations : NSObject {

}

-(UIImage *)scaleAndRotateImage:(UIImage *)image withMaxSize:(int)maxDimension withOrientation:(UIImageOrientation) orient;
-(UIImage *)scaleAndRotateImage:(UIImage *)myImage withOrientation:(UIImageOrientation) orient;
-(UIImage *)imageRotatedByDegrees:(UIImage *) myImage withDegrees:(CGFloat)degrees;
-(CGFloat) DegreesToRadians:(CGFloat) degrees;

@end
