//
//  SearchModalView.h
//  Std-Guide
//
//
//  Copyright 2011  U.S. Centers for Disease Control and Prevention
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software 
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <UIKit/UIKit.h>
#import "ModalViewDelegate.h"
#import "SearchContext.h"


@interface SearchModalView : UIViewController 
							<UISearchDisplayDelegate, UISearchBarDelegate,
                            UITableViewDelegate, UITableViewDataSource>
{
	id<ModalViewDelegate> delegate;
	NSArray			*listContent;			// The master content.
	
	// The saved state of the search UI if a memory warning removed the view.
    NSString		*savedSearchTerm;
    NSInteger		savedScopeButtonIndex;
    BOOL			searchWasActive;
    UITableView     *tv;
    UIToolbar       *tb;
	UISearchBar		*sb;
    SearchContext   *context;
}

@property (nonatomic, retain) NSArray *listContent;
@property (nonatomic, retain) IBOutlet UITableView *tv;
@property (nonatomic, retain) IBOutlet UIToolbar *tb;
@property (nonatomic, retain) IBOutlet UISearchBar *sb;

@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;
@property (nonatomic, assign) id<ModalViewDelegate> delegate;
@property (nonatomic, retain) SearchContext *context;

- (IBAction)btnDoneClicked: (id)sender;

@end
