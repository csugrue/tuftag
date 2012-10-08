//
//  CitiesSelectView.h
//  tnav
//
//  Created by Chris on 7/26/12.
//  Copyright 2012 csugrue. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CitiesSelectView : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate> {
	NSArray			*listContent;			// The master content.
	NSMutableArray	*filteredListContent;	// The content filtered as a result of a search.
	
}

@property (nonatomic, retain) NSArray *listContent;
@property (nonatomic, retain) NSMutableArray *filteredListContent;

-(void)loadCityList;

@end
