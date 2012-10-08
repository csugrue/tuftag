//
//  CitiesSelectView.m
//  tnav
//
//  Created by Chris on 7/26/12.
//  Copyright 2012 csugrue. All rights reserved.
//

#import "CitiesSelectView.h"


@implementation CitiesSelectView

@synthesize listContent, filteredListContent;

- (void)viewDidLoad
{
	//self.title = @"Products";
	NSLog(@"load cities");
	
	[self loadCityList];
	
	// create a filtered list that will contain products for the search results table.
	self.filteredListContent = [NSMutableArray arrayWithCapacity:[self.listContent count]];
	//[self filterContentForSearchText:@"Madrid" scope:@"none" ];
	[self.filteredListContent removeAllObjects]; // First clear the filtered array.
	
	/*
	 Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */
	 NSString * searchText = @"Ba";
	 
	for (NSString *city in listContent)
	{
		//if ([scope isEqualToString:@"All"] )
		//{
			NSComparisonResult result = [city compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            if (result == NSOrderedSame)
			{
				//[self.filteredListContent addObject:city];
				NSLog(@"%@",city);
            }
		//}
	}
	
	[self.tableView reloadData];
	self.tableView.scrollEnabled = YES;
}

- (void)viewDidUnload
{
	self.filteredListContent = nil;
}

- (void)dealloc
{
	[listContent release];
	[filteredListContent release];
	
	[super dealloc];
}


- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	/*
	 Update the filtered array based on the search text and scope.
	 */
	
	[self.filteredListContent removeAllObjects]; // First clear the filtered array.
	
	/*
	 Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */
	for (NSString *city in listContent)
	{
		if ([scope isEqualToString:@"All"] )
		{
			NSComparisonResult result = [city compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            if (result == NSOrderedSame)
			{
				[self.filteredListContent addObject:city];
				NSLog(@"%@",city);
            }
		}
	}
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
	[dictionary release];
	
}


@end
