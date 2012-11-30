//
//  DocumentContentViewController.m
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

#import "DocumentContentViewController.h"
#import "AppManager.h"
#import "SearchModalView.h"


@implementation DocumentContentViewController

@synthesize docNode;
@synthesize webView;

AppManager *appMgr;
SearchModalView *searchVC;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	NSString *theBundlePath = [[NSBundle mainBundle] bundlePath];
	theBundlePath = [theBundlePath stringByAppendingPathComponent:@"Text"];
    DebugLog(@"Using bundle path %@", theBundlePath);  

	NSString *thePath = [[NSBundle mainBundle] pathForResource:docNode.contentFilePath ofType:@"xhtml"];
    DebugLog(@"Content file path = %@", thePath);  
	NSURL *baseURL = [NSURL fileURLWithPath:theBundlePath];
	if (thePath) {
		NSData *htmlData = [NSData dataWithContentsOfFile:thePath];
		[webView loadData:htmlData MIMEType:@"text/html"
		 textEncodingName:@"UTF-8" baseURL:baseURL];
	}
	
	// Uncomment the following line to display an edit button in the navigation bar for this view controller.
	UIBarButtonItem *btnFlexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	UIBarButtonItem *btnSearch = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showSearch:)];
    UIButton *iButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [iButton addTarget:self action:@selector(showInfo:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *iButtonItem = [[UIBarButtonItem alloc] initWithCustomView:iButton];
    self.toolbarItems = [[NSArray alloc] initWithObjects:btnSearch, btnFlexSpace, iButtonItem, nil];
    [iButtonItem release];
	[btnSearch release];
	[btnFlexSpace release];
    
    self.webView.scalesPageToFit = YES;
	
}


#pragma mark -
#pragma mark Flip delegate source

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    
	[self dismissModalViewControllerAnimated:YES];
}


- (IBAction)showInfo:(id)sender {    
	
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}

- (IBAction)showSearch:(id)sender {   
	
	DebugLog(@"The Search button has been hit.");  
	
	[appMgr.rootVC showSearch:sender];
		
}

- (void)didDismissModalView {
	LineLog();
    
    // Dismiss the modal view controller
    [self dismissModalViewControllerAnimated:YES];
    
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
	[self.toolbarItems release];
    [super dealloc];
}


@end
