//
//  ViewUploadWithData.h
//  tnav
//
//  Created by Chris on 5/5/12.
//  Copyright 2012 csugrue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ImageOperations.h"
#import "CameraOverlay.h"
#import "ASIFormDataRequest.h"
#import "NSMutableDictionary+ImageMetadata.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "CitiesSelectView.h"


@protocol ViewUploadWithDataDelegate;

@interface ViewUploadWithData : UIViewController<
	UINavigationControllerDelegate,UIImagePickerControllerDelegate,CLLocationManagerDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource> {
	
	IBOutlet UITextField *writer;
	IBOutlet UITextField *city;
	IBOutlet UILabel *cancelLabel;
	IBOutlet UILabel *postLabel;
	IBOutlet UIButton *cancelButton;
	IBOutlet UIButton *postButton;
	IBOutlet UIActivityIndicatorView *updateWheel;
	IBOutlet UITableView * cityTable;
	IBOutlet UIImageView *writerLine;

	NSArray *tableDataSource;
	
	UIImage * image;
	UIImage * previewImage;
		
	BOOL bOpenCamera;					// true when picker is opened
	BOOL bCancelCamera;					
	BOOL bGrabbedImage;
	BOOL bLocationServicesOn;
	
	
	NSArray			*listContent;			// The master content.
	NSMutableArray	*filteredListContent;	// The content filtered as a result of a search.

}

//--- interface elements
@property (nonatomic, retain) UITextField *writer;
@property (nonatomic, retain) UITextField *city;
@property (nonatomic, retain) UILabel *cancelLabel;
@property (nonatomic, retain) UILabel *postLabel;
@property (nonatomic, retain) UIImageView *writerLine;

@property (nonatomic, retain) UIButton *cancelButton;
@property (nonatomic, retain) UIButton *postButton;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *updateWheel;
@property (nonatomic, retain) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UITableView * cityTable;

@property (assign) id <ViewUploadWithDataDelegate> delegate;

@property (nonatomic, retain) NSArray *listContent;
@property (nonatomic, retain) NSMutableArray *filteredListContent;
@property (nonatomic, retain) NSArray *tableDataSource;

//--- picker
@property (nonatomic, retain)IBOutlet  UIImagePickerController *picker;
@property (nonatomic, retain) UIImage * originalImage;
@property (nonatomic, retain) CameraOverlay *overlay;

//--- uploading
@property (nonatomic, retain) ASIFormDataRequest *request;

//--- geotagging
@property (nonatomic, retain) CLLocationManager *locationManager;  
@property (assign) id <CLLocationManagerDelegate> CLdelegate;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;
@property (nonatomic, retain) NSMutableDictionary *metadata;
//@property (nonatomic, retain) MKReverseGeocoder *reverseGeocoder;

//--- audio effects
@property (nonatomic, retain) AVAudioPlayer *player;
@property (nonatomic, retain) AVAudioPlayer *player_post;
@property (nonatomic, retain) AVAudioPlayer *player_startup;
@property (nonatomic, retain) AVAudioPlayer *player_web;


//----
@property (nonatomic, retain) CitiesSelectView * citySelector;


// interface etc
-(IBAction) launchSafari;
-(IBAction)closeKeyboard:(id)sender;
-(NSString *)getWriter;
-(NSString *)getCity;
-(void)resetPostView;
-(void) launchWeb:(id)sender;
-(void) loadCityList;
-(IBAction) textFieldDidUpdate:(id)sender;

// camera
-(IBAction) openCamera:(id)sender;
-(void) openPicker;
-(void) grabPicture:(id)sender;
-(void) flipCamera:(id)sender;
-(void) cancelCamera:(id)sender;
-(void) doneWithPics:(id)sender;
-(void) switchToPhotoLibrary:(id)sender;
-(BOOL) didGrabImage;
-(void) didOrientation:(id)object;
-(void) toggleFlash:(id)sender;

// upload
-(IBAction) upload;
-(void) upload;
-(void) uploadRequestFinished:(ASIHTTPRequest *)request;
-(void) uploadRequestFailed:(ASIHTTPRequest *)request;
-(IBAction) cancelUpload;


// geolocation
- (void)locationManager:(CLLocationManager *)manager 
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;


@end


@protocol ViewUploadWithDataDelegate <NSObject>
@optional
-(IBAction) upload;
-(void) pushFromParent;
@end


@protocol MyCLControllerDelegate 
@required
- (void)locationUpdate:(CLLocation *)location; 
- (void)locationError:(NSError *)error;
@end