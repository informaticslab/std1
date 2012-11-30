//
//  RootViewController.m
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

#import "RootViewController.h"
#import "AppManager.h"
#import "DocumentNode.h"
#import "DocumentContentViewController.h"
#import "DocumentNodeViewController.h"
#import "SearchModalView.h"
#import "EulaViewController.h"

@implementation RootViewController

AppManager *appMgr;
DocumentNode *rootNode;
SearchModalView *searchVC;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad 
{

    [super viewDidLoad];

    appMgr = [AppManager singletonAppManager];

    // Uncomment the following line to display an edit button in the navigation bar for this view controller.
	UIBarButtonItem *btnFlexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	UIBarButtonItem *btnSearch = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showSearch:)];
    UIButton *iButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [iButton addTarget:self action:@selector(showInfo:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *iButtonItem = [[UIBarButtonItem alloc] initWithCustomView: iButton];
    self.toolbarItems = [[NSArray alloc] initWithObjects:btnSearch, btnFlexSpace, iButtonItem, nil];
	[btnSearch release];
	[btnFlexSpace release];
    [iButtonItem release];
    
    rootNode = appMgr.doc.rootNode;
    self.navigationItem.title = rootNode.text;
	appMgr.rootVC = self;

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
	
	// show the Search view modally
	if (searchVC != nil)
		[searchVC release];	
	searchVC = [[SearchModalView alloc] initWithNibName:@"SearchModalView" bundle:nil];
	
	// we are the delegate that is responsible for dismissing the help view
	searchVC.delegate = self;
	searchVC.modalPresentationStyle = UIModalPresentationPageSheet;
	[self presentModalViewController:searchVC animated:YES];
	
	// Clean up resources
	
	
}

- (void)didDismissModalView {
	//LineLog();
    
    // Dismiss the modal view controller
    [self dismissModalViewControllerAnimated:YES];

}

- (void) viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    [self presentEulaModalView];
    
    
}

- (void)presentEulaModalView
{
    
    if (appMgr.agreedWithEula == TRUE)
        return;
    
    // store the data
    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *currVersion = [NSString stringWithFormat:@"%@.%@", 
                             [appInfo objectForKey:@"CFBundleShortVersionString"], 
                             [appInfo objectForKey:@"CFBundleVersion"]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersionEulaAgreed = (NSString *)[defaults objectForKey:@"agreedToEulaForVersion"];
    
    
    // was the version number the last time EULA was seen and agreed to the 
    // same as the current version, if not show EULA and store the version number
    if (![currVersion isEqualToString:lastVersionEulaAgreed]) {
        [defaults setObject:currVersion forKey:@"agreedToEulaForVersion"];
        [defaults synchronize];
        NSLog(@"Data saved");
        NSLog(@"%@", currVersion);
        
        // Create the modal view controller
        EulaViewController *eulaVC = [[EulaViewController alloc] initWithNibName:@"EulaViewController" bundle:nil];
        
        // we are the delegate that is responsible for dismissing the help view
        eulaVC.delegate = self;
        eulaVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentModalViewController:eulaVC animated:YES];
        
    }
    
}




#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [rootNode getChildNodeCount];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"RootCellIdentifier";
	
	// Dequeue or create a cell of the appropriate type.
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Get the object to display and set the value in the cell.
    DocumentNode *docNode = [rootNode childNodeAtIndex:indexPath.row];
    cell.textLabel.text = docNode.text;
    return cell;
    
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DocumentNode *curDocNode = [rootNode childNodeAtIndex:indexPath.row];
	
	// check for content node which takes a different view controller
    if (curDocNode.type == CONTENT)
	{
		DocumentContentViewController *docContentVC = [[DocumentContentViewController alloc] init];
        
		// Pass the selected object to the new view controller.
		docContentVC.docNode = curDocNode;
		[self.navigationController pushViewController:docContentVC animated:YES];
		[docContentVC release];
        
    } else if (curDocNode.type == HEADER) {

        DocumentNodeViewController *docNodeViewController = [[DocumentNodeViewController alloc] init];
        docNodeViewController.docNode = curDocNode;

        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:docNodeViewController animated:YES];
        [docNodeViewController release];
        
    }    
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[self.toolbarItems release];
    [super dealloc];
}


@end

