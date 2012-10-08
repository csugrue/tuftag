//
//  ViewUploadWithData.m
//  tnav
//
//  Created by Chris on 5/5/12.
//  Copyright 2012 csugrue. All rights reserved.
//
BOOL gLogging = FALSE;
#define RADIANS(degrees) ((degrees * M_PI) / 180.0)

#import "ViewUploadWithData.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAsset.h>

NSString * url = @"http://tuftag.heroku.com/api/posts";

@implementation ViewUploadWithData

@synthesize delegate;
@synthesize writer, city;
@synthesize postLabel,cancelButton,postButton,cancelLabel,updateWheel,writerLine;
@synthesize picker;
@synthesize originalImage;
@synthesize overlay;
@synthesize request;
@synthesize locationManager;
@synthesize CLdelegate;
@synthesize latitude,longitude;
@synthesize player,player_post,player_startup,player_web;
@synthesize metadata;
@synthesize scrollView;
@synthesize citySelector;
@synthesize cityTable;
@synthesize listContent, filteredListContent;
@synthesize tableDataSource;

-(void) viewDidLoad{
	
	[super viewDidLoad];
	
	[self loadCityList];
	self.filteredListContent = [[NSMutableArray alloc] initWithArray:listContent];//[NSMutableArray arrayWithCapacity:[self.listContent count]];
	
	
	// init location manager
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self; // send loc updates to myself	
	latitude = @"0";
	longitude = @"0";

	if( [CLLocationManager authorizationStatus] == 3 ) bLocationServicesOn = true;
	else bLocationServicesOn = false;
	
	// geotag save data
	metadata = [[NSMutableDictionary alloc] init];
	
	// color of labels
	[self.writer setValue:[UIColor colorWithWhite:.2 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
	[self.city setValue:[UIColor colorWithWhite:.2 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
	
	// init holder image
	originalImage   = [UIImage imageNamed:@"camera.jpg"];
	bOpenCamera = false;
	bCancelCamera = false;
	bGrabbedImage = false;
	
	
	// sound files
	NSError* err;
	NSURL *url=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"shotgun.mp3" ofType:nil]];
	player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&err];
	
	url=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"audio_barreta.mp3" ofType:nil]];
	player_post = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&err];
	
	url=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"audio_shot_gun_luminalace.mp3" ofType:nil]];
	player_web = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&err];
	
	
	
	//--- create camera overlay
	overlay = [[CameraOverlay alloc] initWithFrame:CGRectMake(0, 0, 360, 480)];
	
	UIButton *bar = [UIButton buttonWithType:UIButtonTypeCustom];
	bar.frame = CGRectMake(-10, 420, 340, 70);
	[bar setBackgroundImage:[UIImage imageNamed:@"blackbar.png"] forState:UIControlStateNormal];
	[overlay addSubview:bar];
	
	// create capture button
	overlay.grabButton = [UIButton buttonWithType:UIButtonTypeCustom];
	overlay.grabButton.frame = CGRectMake(127, 395, 66, 51);
	[overlay.grabButton addTarget:self action:@selector(grabPicture:) forControlEvents:UIControlEventTouchUpInside];
	[overlay.grabButton setBackgroundImage:[UIImage imageNamed:@"cameraNewStroke.png"] forState:UIControlStateNormal];
	[overlay.grabButton setBackgroundImage:[UIImage imageNamed:@"cameraNewStrokeInvert.png"] forState:UIControlStateHighlighted];
	[overlay addSubview:overlay.grabButton];
	
	if ([UIImagePickerController isFlashAvailableForCameraDevice:UIImagePickerControllerCameraDeviceFront]) {
		overlay.flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
		overlay.flashButton.frame = CGRectMake(15, 15, 70, 37);
		[overlay.flashButton addTarget:self action:@selector(toggleFlash:) forControlEvents:UIControlEventTouchUpInside];
		[overlay.flashButton setTitle:@"Flash Off" forState:UIControlStateNormal];
		[overlay.flashButton setBackgroundImage:[UIImage imageNamed:@"button10graySmallTransparent.png"] forState:UIControlStateNormal];
		[overlay.flashButton setBackgroundImage:[UIImage imageNamed:@"button10whiteSmallTransparent.png"] forState:UIControlStateHighlighted];
		[overlay.flashButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
		overlay.flashButton.titleLabel.font = [UIFont systemFontOfSize:12];
		[overlay addSubview:overlay.flashButton];
	}
	
	// create bullseye
	overlay.bullsEye = [UIButton buttonWithType:UIButtonTypeCustom];
	overlay.bullsEye.frame = CGRectMake(22, 72, 276, 276);
	[overlay.bullsEye setBackgroundImage:[UIImage imageNamed:@"bullseye.png"] forState:UIControlStateNormal];
	
	overlay.bullsEye.alpha = 0.0;
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:2.2f];
	[UIView setAnimationDuration:0.5];
    overlay.bullsEye.alpha = 1.0f;
    [UIView commitAnimations];
	
	[overlay addSubview:overlay.bullsEye];
		
	// create goto image preview button
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory =  [paths objectAtIndex:0];
	NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:@"thumb.png"];
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *savedThumbString = [prefs stringForKey:@"thumbnail"];
	if(!savedThumbString)
	{
		previewImage  = [UIImage imageNamed:@"thumb.png"];
		NSData *pImageData = UIImagePNGRepresentation(previewImage);
		[pImageData writeToFile:imagePath atomically:YES];
		[prefs setObject:@"true" forKey:@"thumbnail"];
	}
	
	
	 
	overlay.photoLibButton = [UIButton buttonWithType:UIButtonTypeCustom];
	overlay.photoLibButton.frame = CGRectMake(11, 432, 35, 35);
	[overlay.photoLibButton addTarget:self action:@selector(switchToPhotoLibrary:) forControlEvents:UIControlEventTouchUpInside];
	[overlay.photoLibButton setBackgroundImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
	[overlay addSubview:overlay.photoLibButton];
	
	UIButton *tuftagButton = [UIButton buttonWithType:UIButtonTypeCustom];
	tuftagButton.frame = CGRectMake(235, 435, 70, 32);
	[tuftagButton addTarget:self action:@selector(launchWeb:) forControlEvents:UIControlEventTouchUpInside];
	[tuftagButton setBackgroundImage:[UIImage imageNamed:@"tuftag_logo_large2Crop.png"] forState:UIControlStateNormal];
	[overlay addSubview:tuftagButton];
	
	//---- done overlay
	[cityTable setSeparatorColor:[UIColor blackColor]];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	
	//set button press states
	//postButton = [UIButton buttonWithType:UIButtonTypeCustom];
	UIImage * btnImagePress = [UIImage imageNamed:@"button10whiteSmall.png"];
	[postButton setBackgroundImage:btnImagePress forState:UIControlStateHighlighted];
	[postButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
	//[postButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

											
	// open picker
	[self setWantsFullScreenLayout:YES];
	[self openPicker];

}

- (void)viewDidUnload
{
    [self setScrollView:nil];
	[super viewDidUnload];
	
}

-(void) viewDidAppear:(BOOL)animated{
	
	[super viewDidAppear:animated];
	
	if(!bCancelCamera) [city becomeFirstResponder];
	[cityTable setHidden:FALSE];
	
	[self resetPostView];

}

-(void) launchWeb:(id)sender{

	//[self launchSafari];

}

-(IBAction)launchSafari{
	
	//NOTE: CHANGE BACK!!!!
	NSURL *url = [NSURL URLWithString:@"http://tuftag.heroku.com/posts"];//http://www.tuftag.org"];
	
	[player_web play];
	
	if (![[UIApplication sharedApplication] openURL:url])
		
	NSLog(@"%@%@",@"Failed to open url:",[url description]);
	

}	

-(IBAction) textFieldDidUpdate:(id)sender{
	NSLog(@"textFieldDidUpdate");
	
	UITextField * textField = (UITextField *) sender;
	NSString * searchText = textField.text;
	
	[self.filteredListContent removeAllObjects]; // First clear the filtered array.
	
	for (NSString *cityname in listContent)
	{
		NSComparisonResult result = [cityname compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
		if (result == NSOrderedSame)
		{
			[self.filteredListContent addObject:cityname];
		}
	}
	
	// update with filtered list
	self.tableDataSource = self.filteredListContent;
	[cityTable reloadData];
}



- (void)keyboardWillHide:(NSNotification*)notification {
	NSLog(@"keyboardWillHide, close city list");
	// hide table
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
    [self.cityTable setFrame:CGRectMake(0,480,320,140)];
	[UIView commitAnimations];
}
 

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [scrollView adjustOffsetToIdealIfNeeded];
	
	if( textField == city)
	{
		// show city table
		[self.cityTable setFrame:CGRectMake(0,480,320,140)];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		[self.cityTable setFrame:CGRectMake(0,130,320,140)];
		[UIView commitAnimations];
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		[postButton setAlpha:0];
		[writerLine setAlpha:0];
		[UIView commitAnimations];
	}
	
	NSLog(@"textFieldDidBeginEditing");
}

-(NSString *)getWriter{
	return [writer text];
}

-(NSString *)getCity{
	return  [city text];
}

-(IBAction)closeKeyboard:(id)sender{
	[city resignFirstResponder];
	[writer resignFirstResponder];
	
	// hide city list
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
    [self.cityTable setFrame:CGRectMake(0,480,320,140)];
	[UIView commitAnimations];
	
}



//----------------------------------------------------------------- CAMERA PICKER
-(IBAction) openCamera:(id)sender{
	[player_post play];
	[self openPicker];
}

-(void)openPicker{
	
	NSLog(@"Open picker.\n");
	
	bOpenCamera = true;
	
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didOrientation:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];

	//reset lat and long to erase previous
	latitude = @"0";
	longitude = @"0";
	
	// init picker
	picker = [[UIImagePickerController alloc] init ];
	picker.delegate = self;
	
	
	
	overlay.bullsEye.alpha = 0.0;
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:1.25f];
	[UIView setAnimationDuration:0.5];
    overlay.bullsEye.alpha = 1.0f;
    [UIView commitAnimations];
	 
	 if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	 {
	 
		 // start grabbing gps data here so we get only when camera shot happens
		 if( bLocationServicesOn ) [locationManager startUpdatingLocation];
		 else NSLog(@"No location services available");
	
		 picker.sourceType = UIImagePickerControllerSourceTypeCamera;
		 [picker setShowsCameraControls:NO];
		 overlay.hidden = NO;
		 picker.cameraOverlayView = overlay;
		 picker.allowsEditing = NO;
		 
		 picker.cameraViewTransform = CGAffineTransformMakeScale(1.0, 1.03);
	 
	 }else{
		 picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	 }
	 
	

	[[UIApplication sharedApplication] setStatusBarHidden:YES];
	[self presentModalViewController:picker animated:YES];
}

-(void)grabPicture:(id)sender{
	NSLog(@"Grab pic.\n");
	[player play];
	[picker takePicture];
}

-(void)toggleFlash:(id)sender{
	
	// on --> auto --> off --> on
	
	if( picker.cameraFlashMode == UIImagePickerControllerCameraFlashModeAuto){
		picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
		[overlay.flashButton setBackgroundImage:[UIImage imageNamed:@"button10whiteSmallTransparent.png"] forState:UIControlStateNormal];
		[overlay.flashButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
		[overlay.flashButton setTitle:@"Flash Off" forState:UIControlStateNormal];

	}else if(picker.cameraFlashMode == UIImagePickerControllerCameraFlashModeOff){
		picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
		[overlay.flashButton setBackgroundImage:[UIImage imageNamed:@"button10graySmallTransparent.png"] forState:UIControlStateNormal];
		[overlay.flashButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
		[overlay.flashButton setTitle:@"Flash On" forState:UIControlStateNormal];

	}else if(picker.cameraFlashMode == UIImagePickerControllerCameraFlashModeOn){
		picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
		[overlay.flashButton setBackgroundImage:[UIImage imageNamed:@"button10graySmallTransparent.png"] forState:UIControlStateNormal];
		[overlay.flashButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
		[overlay.flashButton setTitle:@"Flash Auto" forState:UIControlStateNormal];

	}

}

-(void) switchToPhotoLibrary:(id)sender{
	[[picker parentViewController] dismissModalViewControllerAnimated:NO];
	[picker release];
	picker = [[UIImagePickerController alloc] init ];
	picker.delegate = self;
	picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	[self presentModalViewController:picker animated:YES];
	
}

-(void) flipCamera:(id)sender{
	if( picker.cameraDevice == UIImagePickerControllerCameraDeviceFront )
	{	
		if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) 
		picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
	}else if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) 
		picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
}

-(void)doneWithPics:(id)sender{
	// remove picker
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];
	[picker release];
	[[UIApplication sharedApplication] setStatusBarHidden:NO];

}

-(void) cancelCamera:(id)sender{
	[self imagePickerControllerDidCancel:picker];
	bCancelCamera = true;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *) Picker{
	
	[[Picker parentViewController] dismissModalViewControllerAnimated:YES];
	[Picker release];
	[[UIApplication sharedApplication] setStatusBarHidden:NO];

}

-(void)imagePickerController:(UIImagePickerController *) Picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
	
	NSLog(@"Finished picking image.\n");
	
	//if ([picker sourceType] == UIImagePickerControllerSourceTypePhotoLibrary)
	//	[player play];
		
	bGrabbedImage = true;
	bOpenCamera   = false;
	bCancelCamera = false;
	
	// operator for image rotation
	ImageOperations * imageOperator = [ImageOperations alloc];
	
	// set our original image from camera, this will be used for making changes
	CGImageRef cgImage = [[info objectForKey:UIImagePickerControllerOriginalImage] CGImage];	
	originalImage = [[UIImage alloc] initWithCGImage:cgImage];
	
	// get orientation
	UIImageOrientation orientation = [[info objectForKey:UIImagePickerControllerOriginalImage] imageOrientation];
	switch(orientation) {
		case UIImageOrientationUp:	NSLog(@"UIImageOrientationUp"); break;
		case UIImageOrientationUpMirrored: NSLog(@"UIImageOrientationUpMirrored"); break;
		case UIImageOrientationDown: NSLog(@"UIImageOrientationDown"); break;
		case UIImageOrientationDownMirrored: NSLog(@"UIImageOrientationDownMirrored"); break;
		case UIImageOrientationLeftMirrored: NSLog(@"UIImageOrientationLeftMirrored"); break;
		case UIImageOrientationLeft: NSLog(@"UIImageOrientationLeft"); break;
		case UIImageOrientationRightMirrored: NSLog(@"UIImageOrientationRightMirrored"); break;
		case UIImageOrientationRight: NSLog(@"UIImageOrientationRight"); break;
		default: NSLog(@"default orient");
	}
	
	
	
	// if we are using the camera, rotate and scale
	if( orientation == UIImageOrientationRight )
		originalImage = [imageOperator scaleAndRotateImage:originalImage withOrientation:UIImageOrientationRight];
	else if( orientation == UIImageOrientationDown  )
		originalImage = [imageOperator imageRotatedByDegrees:originalImage withDegrees:180];
	//else if( orientation == UIImageOrientationUp )
	//	originalImage = [imageOperator imageRotatedByDegrees:originalImage withDegrees:-180];

	originalImage = [imageOperator scaleAndRotateImage:originalImage withMaxSize:640 withOrientation:UIImageOrientationUp];

	CGImageRef cgImage2 = [originalImage CGImage];
	image = [[UIImage alloc] initWithCGImage:cgImage2];
	
	// set and scale preview image for quick alterations
	previewImage = [imageOperator scaleAndRotateImage:originalImage withMaxSize:40 withOrientation:UIImageOrientationUp];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:@"thumb.png"];
	NSData *pImageData = UIImagePNGRepresentation(previewImage);
	[pImageData writeToFile:imagePath atomically:YES];
	[overlay.photoLibButton setBackgroundImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];

	
	[imageOperator release];
	
	
	if( bLocationServicesOn ) [locationManager stopUpdatingLocation];
	
	//----------------- if camera image
	if ([picker sourceType] == UIImagePickerControllerSourceTypeCamera )
	{	
		if( bLocationServicesOn ){
						
			// save image with geodata
			NSData *data = UIImageJPEGRepresentation(originalImage,1.0);
			ALAssetsLibrary *al = [[ALAssetsLibrary alloc] init];
			__block NSDate *date = [[NSDate date] retain];
			[al writeImageDataToSavedPhotosAlbum:data metadata:metadata completionBlock:^(NSURL *assetURL, NSError *error) {
				//NSLog(@"Saving Time: %g", [[NSDate date] timeIntervalSinceDate:date]);
				[date release];
			}];
			[al release];
			
		}else {
			UIImageWriteToSavedPhotosAlbum(originalImage, nil,nil,nil);
		}

	}
	
	//-----------------  if media is from photo album, get coords with asseel
	else if ([picker sourceType] == UIImagePickerControllerSourceTypePhotoLibrary)
	{
		// Get the asset url
		NSLog(@"Source from photo album.");
		
        ALAssetsLibrary *assetLibrary = [[[ALAssetsLibrary alloc]init]autorelease];
		ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *asset)
		{

				[asset valueForProperty:ALAssetPropertyLocation];
				CLLocation *location = [asset valueForProperty:ALAssetPropertyLocation];
				
				float latF = location.coordinate.latitude;
				if( latF != latF)
				{
					NSLog(@"Location from photo NAN");
				
				}else{
				
					latitude = [[NSString alloc] initWithFormat:@"%g", location.coordinate.latitude];
					longitude = [[NSString alloc] initWithFormat:@"%g", location.coordinate.longitude];
					NSLog(@"Album location: %@", [location description]);
				}
				
		};
		
		
		ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror)
		{
			NSLog(@"Failed: can't get image -- %@",[myerror localizedDescription]);
		};
		
		
		NSURL *imageUrl = [info  valueForKey:UIImagePickerControllerReferenceURL];
		[assetLibrary assetForURL:imageUrl
                      resultBlock:resultblock
                     failureBlock:failureblock];
		
		
	}
	
	[[Picker parentViewController] dismissModalViewControllerAnimated:YES];
	[Picker release];
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
	

	
}

-(BOOL) didGrabImage{
	return bGrabbedImage;
}

//----------------------------------------------------------------- UPLOADING
-(void)upload{
	
	NSLog(@"Start uploading image.\n");
	
	
	
	// check if we have an image
	if(!bGrabbedImage){
		//[self openPicker];
		//return;
	}
	
	// check if logged in
	/*if(!bLoggedIn)
	 {
	 ViewLogIn * viewLogIn	= [[ViewLogIn alloc] initWithNibName:@"ViewLogIn" bundle:nil];
	 //[viewLabel presentModalViewController:viewLogIn animated:YES];
	 [viewLogIn release];	
	 }else{*/
	
	NSLog(@"Uploading image.\n");
	
	// get current image that has been edited/filtered
	CGImageRef imgRef = [image CGImage];//image.CGImage;
	UIImage * tImage =[[UIImage alloc] initWithCGImage:imgRef];

	// convert to png
	NSData  * imageData = UIImagePNGRepresentation(tImage);	
	
	// get metadate
	NSString *imageCity   = [self getCity];//[viewLabel getTitle];
	NSString *imageWriter = [self getWriter];//[viewLabel getLocation];
	NSString *iphoneID    = [[UIDevice currentDevice] uniqueIdentifier];
	
	NSLog(@"Create request.\n");
	request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
	
	// NOTE: how to send wirter / title?
	[request setPostValue:imageWriter forKey:@"title"];
	[request setPostValue:imageCity forKey:@"city"];
	[request setPostValue:iphoneID forKey:@"device_id" ];
	[request setPostValue:latitude forKey:@"gps_lat" ];
	[request setPostValue:longitude forKey:@"gps_long" ];

	[request addData:imageData withFileName:@"photo.jpeg" andContentType:@"image/jpeg" forKey:@"photo"];
	
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(uploadRequestFinished:)];
	[request setDidFailSelector:@selector(uploadRequestFailed:)];
	//[request setUploadProgressDelegate:uploadStats.statusBar];
	[request setTimeOutSeconds:999]; 
	
	NSLog(@"startAsynchronous.\n");
	[request startAsynchronous];
	
	[tImage release];
	
	[self openPicker];
	// hide post button and show cancel / update
	/*[postLabel setHidden:TRUE];
	[postButton setHidden:TRUE];
	[cancelLabel setHidden:FALSE];
	[cancelButton setHidden:FALSE];
	[updateWheel setHidden: FALSE];	*/
	
	[player_post play];
	
}

-(void)uploadRequestFinished:(ASIHTTPRequest *)myrequest{
	
	NSLog(@"response - %@",[myrequest responseString]);
	NSLog(@"finished\n");
	
	NSString * finString = @"Upload successful.";//[[NSString alloc] initWithFormat:@"Upload finished: %@",[myrequest responseString] ];

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:finString 
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
	
	//[self resetPostView];
	[cancelLabel setHidden:TRUE];
	[cancelButton setHidden:TRUE];
	[updateWheel setHidden: TRUE];
		
}

-(void)uploadRequestFailed:(ASIHTTPRequest *)myrequest{
	
	NSLog(@"response - %@",[myrequest responseString]);
	NSLog(@"failed\n");
	
	NSString * failString = [[NSString alloc] initWithFormat:@"Upload failed: %@",[myrequest responseString] ];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:failString 
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release]; 
	[self resetPostView];

}

-(IBAction)cancelUpload{
	[self.request cancel];
	[self.request clearDelegatesAndCancel];
	
	[self resetPostView];
}

-(void)resetPostView{
	/*
	[postLabel setHidden:FALSE];
	[postButton setHidden:FALSE];
	[cancelLabel setHidden:TRUE];
	[cancelButton setHidden:TRUE];
	[updateWheel setHidden: TRUE];	*/
}

// Helper methods for location conversion
/*
-(NSMutableArray*) createLocArray:(double) val{
	val = fabs(val);
	NSMutableArray* array = [[NSMutableArray alloc] init];
	double deg = (int)val;
	[array addObject:[NSNumber numberWithDouble:deg]];
	val = val - deg;
	val = val*60;
	double minutes = (int) val;
	[array addObject:[NSNumber numberWithDouble:minutes]];
	val = val - minutes;
	val = val *60;
	double seconds = val;
	[array addObject:[NSNumber numberWithDouble:seconds]];
	return array;
} 

-(void) populateGPS: (EXFGPSLoc*)gpsLoc :(NSArray*) locArray{
	long numDenumArray[2];
	long* arrPtr = numDenumArray;
	
	
	[EXFUtils convertRationalToFraction:&arrPtr :[locArray objectAtIndex:0]];
	EXFraction* fract = [[EXFraction alloc] initWith:numDenumArray[0] :numDenumArray[1]];
	gpsLoc.degrees = fract;
	[fract release];
	[EXFUtils convertRationalToFraction:&arrPtr :[locArray objectAtIndex:1]];
	fract = [[EXFraction alloc] initWith:numDenumArray[0] :numDenumArray[1]];
	gpsLoc.minutes = fract;
	[fract release];
	[EXFUtils convertRationalToFraction:&arrPtr :[locArray objectAtIndex:2]];
	fract = [[EXFraction alloc] initWith:numDenumArray[0] :numDenumArray[1]];
	gpsLoc.seconds = fract;
	[fract release];   
}
// end of helper methods
*/

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"Location: %@", [newLocation description]);
	
	latitude = [[NSString alloc] initWithFormat:@"%g", newLocation.coordinate.latitude];
	longitude = [[NSString alloc] initWithFormat:@"%g", newLocation.coordinate.longitude];
	
	[metadata setLocation:newLocation];

}


- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error
{
	NSLog(@"Error: %@", [error description]);
}


- (void) didOrientation: (id)object {
    
	UIInterfaceOrientation interfaceOrientation = [[object object] orientation];
	[UIView beginAnimations:@"rotate barbuttonitems" context:NULL];
	[UIView setAnimationDuration:.1];
	
	switch(interfaceOrientation){
		
		case UIInterfaceOrientationPortrait:
			overlay.grabButton.transform = CGAffineTransformMakeRotation( RADIANS(0.0) );
			break;
		case UIInterfaceOrientationPortraitUpsideDown:
			overlay.grabButton.transform = CGAffineTransformMakeRotation( RADIANS(180.0) );
			break;
		case UIInterfaceOrientationLandscapeLeft:
			overlay.grabButton.transform = CGAffineTransformMakeRotation( RADIANS(-90.0) );
			break;
		case UIInterfaceOrientationLandscapeRight:
			overlay.grabButton.transform = CGAffineTransformMakeRotation( RADIANS(90.0) );
			break;

	}
	
	[UIView commitAnimations];

  
	
}


- (void)dealloc	
{	
	[locationManager release];
	[metadata release];
	[player release];
	[overlay release];
	[originalImage release];
	[previewImage release];
	[scrollView release];
    [super dealloc];

}


-(void)loadCityList
{
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSArray *mypaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *directory = [mypaths objectAtIndex:0];
	NSString *path = [directory stringByAppendingPathComponent:@"cities.plist"];
	
	// check if file exists and if not, create it
	BOOL fileExists = [fileManager fileExistsAtPath:path];
	
	if(!fileExists)
	{
		NSError *error;
		NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
		
		NSString *bundlepath = [bundleRoot stringByAppendingPathComponent:@"cities.plist"];
		NSLog(@"%@",bundlepath);
		
		[fileManager copyItemAtPath:bundlepath toPath:path error:&error];
	}
	
	NSMutableDictionary * dictionary = [ [NSMutableDictionary alloc] initWithContentsOfFile:path];
	listContent = [[NSArray alloc] initWithArray:[dictionary objectForKey:@"All Cities"]];
	NSMutableArray * fileArray = [[NSMutableArray alloc] initWithArray:listContent];
	NSLog(@"filearray count: %d",fileArray.count);
	self.tableDataSource = fileArray;
	[cityTable reloadData];

	[fileArray release];
	[dictionary release];
	
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"didSelectRowAtIndexPath");
	
	// switch keyboard
	//[self.city resignFirstResponder];
	[self.writer becomeFirstResponder];

	// hide table
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
    [self.cityTable setFrame:CGRectMake(0,480,320,140)];
	[UIView commitAnimations];
	
	// show hidden interface
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
    [postButton setAlpha:1];
	[writerLine setAlpha:1];
	[UIView commitAnimations];
	
	// put selection in text field
	[city setText:[self.filteredListContent objectAtIndex:indexPath.row]];
	
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
	return [self.tableDataSource count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView
		cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"SimpleTableIdentifier";
	
	UITableViewCell * cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		/*NSArray * topLevelObjects = [ [NSBundle mainBundle] loadNibNamed:@"cellThumbnail" owner:nil options:nil];
		for(id currentObject in topLevelObjects){
			cell = (CellThumbnail*) currentObject;
			break;
		}*/
	}
	
	[cell.textLabel setTextColor:[UIColor darkGrayColor]];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	

	/*
	
	UILabel * cellTitle = [[[UILabel alloc] initWithFrame:CGRectMake(50, 10, 320, 20)] autorelease];
	if(tableDataSource.count > row) [cellTitle setText:[tableDataSource objectAtIndex:row]];
	[cellTitle setTextColor:[UIColor darkGrayColor]];
	[cell.contentView addSubview:cellTitle];
	
	UILabel * cellLocTitle = [[[UILabel alloc] initWithFrame:CGRectMake(50, 30, 320, 20)] autorelease];
	if(tableDataLocation.count > row) [cellLocTitle setText:[tableDataLocation objectAtIndex:row]];
	[cellLocTitle setTextColor:[UIColor darkGrayColor]];
	[cellLocTitle setFont:[UIFont systemFontOfSize:12.0]];
	[cell.contentView addSubview:cellLocTitle];
	
	[cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"thumb_%@", [tableDataImageName objectAtIndex:indexPath.row] ]];
	UIImage * thumbImage = [ [UIImage alloc] initWithContentsOfFile:fullPath ];
	
	[cell.thumbnail setImage:thumbImage];
	*/
	NSUInteger row = [indexPath row];
	if(tableDataSource.count > row) [cell.textLabel setText:[tableDataSource objectAtIndex:row]];
	return cell;
}

@end
