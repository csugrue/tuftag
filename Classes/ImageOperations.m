//
//  imageOperations.m
//  tnav
//
//  Created by Chris on 10/29/11.
//  Copyright 2011 csugrue. All rights reserved.
//

#import "imageOperations.h"


@implementation ImageOperations

-(CGFloat) DegreesToRadians:(CGFloat) degrees{return degrees * M_PI / 180;};

-(UIImage *)imageRotatedByDegrees:(UIImage *) myImage withDegrees:(CGFloat)degrees{
	
	// calculate the size of the rotated view's containing box for our drawing space
	UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,myImage.size.width, myImage.size.height)];
	CGAffineTransform t = CGAffineTransformMakeRotation([self DegreesToRadians:degrees]);
	rotatedViewBox.transform = t;
	CGSize rotatedSize = rotatedViewBox.frame.size;
	[rotatedViewBox release];
	
	// Create the bitmap context
	UIGraphicsBeginImageContext(rotatedSize);
	CGContextRef bitmap = UIGraphicsGetCurrentContext();
	// Move the origin to the middle of the image so we will rotate and scale around the center.
	CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
	//   // Rotate the image context
	CGContextRotateCTM(bitmap, [self DegreesToRadians:degrees]);
	// Now, draw the rotated/scaled image into the context
	CGContextScaleCTM(bitmap, 1.0, -1.0);
	CGContextDrawImage(bitmap, CGRectMake(-myImage.size.width / 2, -myImage.size.height / 2, myImage.size.width, myImage.size.height), [myImage CGImage]);
	
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
	
}

- (UIImage *)scaleAndRotateImage:(UIImage *)myImage withMaxSize:(int)maxDimension withOrientation:(UIImageOrientation) orient
{
	CGImageRef imgRef = myImage.CGImage;
	CGFloat width = CGImageGetWidth(imgRef);
	CGFloat height = CGImageGetHeight(imgRef);
	
	CGAffineTransform transform = CGAffineTransformIdentity;
	CGRect bounds = CGRectMake(0, 0, width, height);
	if (width > maxDimension || height > maxDimension) {
		CGFloat ratio = width/height;
		if (ratio > 1) {
			bounds.size.width = maxDimension;
			bounds.size.height = bounds.size.width / ratio;
		} else {
			bounds.size.height = maxDimension;
			bounds.size.width = bounds.size.height * ratio;
		}
	}
	
	CGFloat scaleRatio = bounds.size.width / width;
	CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
	CGFloat boundHeight;
	
	//UIImageOrientation orient = UIImageOrientationRight;//myImage.imageOrientation;
	switch(orient) {
	 case UIImageOrientationUp:
	 NSLog(@"up");
	 transform = CGAffineTransformIdentity;
	 break;
	 case UIImageOrientationUpMirrored:
	 NSLog(@"UIImageOrientationUpMirrored");
	 transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
	 transform = CGAffineTransformScale(transform, -1.0, 1.0);
	 break;
	 case UIImageOrientationDown:
	 NSLog(@"UIImageOrientationDown");
	 transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
	 transform = CGAffineTransformRotate(transform, M_PI);
	 break;
	 case UIImageOrientationDownMirrored:
	 NSLog(@"UIImageOrientationDownMirrored");
	 transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
	 transform = CGAffineTransformScale(transform, 1.0, -1.0);
	 break;
	 case UIImageOrientationLeftMirrored:
	 NSLog(@"UIImageOrientationLeftMirrored");
	 boundHeight = bounds.size.height;
	 bounds.size.height = bounds.size.width;
	 bounds.size.width = boundHeight;
	 transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
	 transform = CGAffineTransformScale(transform, -1.0, 1.0);
	 transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
	 break;
	 case UIImageOrientationLeft:
	 NSLog(@"UIImageOrientationLeft");
	 boundHeight = bounds.size.height;
	 bounds.size.height = bounds.size.width;
	 bounds.size.width = boundHeight;
	 transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
	 transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
	 break;
	 case UIImageOrientationRightMirrored:
	 NSLog(@"UIImageOrientationRightMirrored");
	 boundHeight = bounds.size.height;
	 bounds.size.height = bounds.size.width;
	 bounds.size.width = boundHeight;
	 transform = CGAffineTransformMakeScale(-1.0, 1.0);
	 transform = CGAffineTransformRotate(transform, M_PI / 2.0);
	 break;
	 case UIImageOrientationRight:
	 NSLog(@"UIImageOrientationRight");
	 boundHeight = bounds.size.height;
	 bounds.size.height = bounds.size.width;
	 bounds.size.width = boundHeight;
	 transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
	 transform = CGAffineTransformRotate(transform, M_PI / 2.0);
	 break;
	 default:
	 NSLog(@"default orient");
	 [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
	 }
	 
	UIGraphicsBeginImageContext(bounds.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
		CGContextScaleCTM(context, -scaleRatio, scaleRatio);
		CGContextTranslateCTM(context, -height, 0);
	} else {
		CGContextScaleCTM(context, scaleRatio, -scaleRatio);
		CGContextTranslateCTM(context, 0, -height);
	}
	CGContextConcatCTM(context, transform);
	CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
	UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return imageCopy;
}

-(UIImage *)scaleAndRotateImage:(UIImage *)myImage withOrientation:(UIImageOrientation) orient{	
	//scaleAndRotateImage code from Yoshimasa Niwa :: http://niw.at/en
	
	//int 	maxDimension = 480;
	CGImageRef imgRef = myImage.CGImage;
	CGFloat width = CGImageGetWidth(imgRef);
	CGFloat height = CGImageGetHeight(imgRef);
	
	CGAffineTransform transform = CGAffineTransformIdentity;
	CGRect bounds = CGRectMake(0, 0, width, height);
	bounds.size.width = 480;
	bounds.size.height = 360;//bounds.size.width / ratio;
	/*//if (width > maxDimension || height > maxDimension) {
	CGFloat ratio = width/height;
	if (ratio > 1) {
		bounds.size.width = maxDimension;
		bounds.size.height = bounds.size.width / ratio;
	} else {
		bounds.size.height = maxDimension;
		bounds.size.width = bounds.size.height * ratio;
	}
	//}*/
	
	CGFloat scaleRatio = bounds.size.width / width;
	CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
	CGFloat boundHeight;
	
	//UIImageOrientation orient = UIImageOrientationRight;//myImage.imageOrientation;
	switch(orient) {
		case UIImageOrientationUp:
			NSLog(@"up");
			transform = CGAffineTransformIdentity;
			break;
		case UIImageOrientationUpMirrored:
			NSLog(@"UIImageOrientationUpMirrored");
			transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			break;
		case UIImageOrientationDown:
			NSLog(@"UIImageOrientationDown");
			transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
			transform = CGAffineTransformRotate(transform, M_PI);
			break;
		case UIImageOrientationDownMirrored:
			NSLog(@"UIImageOrientationDownMirrored");
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
			transform = CGAffineTransformScale(transform, 1.0, -1.0);
			break;
		case UIImageOrientationLeftMirrored:
			NSLog(@"UIImageOrientationLeftMirrored");
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
		case UIImageOrientationLeft:
			NSLog(@"UIImageOrientationLeft");
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
		case UIImageOrientationRightMirrored:
			NSLog(@"UIImageOrientationRightMirrored");
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeScale(-1.0, 1.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
		case UIImageOrientationRight:
			NSLog(@"UIImageOrientationRight");
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
		default:
			NSLog(@"default orient");
			[NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
	}
	
	UIGraphicsBeginImageContext(bounds.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
		CGContextScaleCTM(context, -scaleRatio, scaleRatio);
		CGContextTranslateCTM(context, -height, 0);
	} else {
		CGContextScaleCTM(context, scaleRatio, -scaleRatio);
		CGContextTranslateCTM(context, 0, -height);
	}
	CGContextConcatCTM(context, transform);
	CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
	UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return imageCopy;
}

@end
