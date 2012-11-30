//
//  FlipsideViewController.m
//  StdGuide
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

#import "FlipsideViewController.h"
#import "AppManager.h"
#import "AboutModalView.h"
#import "HelpModalView.h"

@implementation FlipsideViewController

@synthesize delegate;

AboutModalView *aboutVC;
HelpModalView *helpVC;

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];      
}


- (IBAction)done:(id)sender 
{
	[self.delegate flipsideViewControllerDidFinish:self];	
}

- (IBAction)about:(id)sender {
   
	DebugLog(@"The About button has been hit.");  
	
	// show the About view modally
	if (aboutVC != nil)
		[aboutVC release];	
		
	// show the About view modally
	aboutVC = [[AboutModalView alloc] init];
	
	// we are the delegate that is responsible for dismissing the About view
	aboutVC.delegate = self;
	aboutVC.modalPresentationStyle = UIModalPresentationPageSheet;
	[self presentModalViewController:aboutVC animated:YES];
	
}

- (IBAction)help:(id)sender {
	DebugLog(@"The Help button has been hit.");  
	
	// show the Help view modally
	if (helpVC != nil)
		[helpVC release];	
	helpVC = [[HelpModalView alloc] init];
	
	// we are the delegate that is responsible for dismissing the help view
	helpVC.delegate = self;
	helpVC.modalPresentationStyle = UIModalPresentationPageSheet;
	[self presentModalViewController:helpVC animated:YES];
	
	// Clean up resources
	//[helpVC release];	
}

- (void)didDismissModalView {
	LineLog();
    
    // Dismiss the modal view controller
    [self dismissModalViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/



- (void)dealloc {
    [super dealloc];
}


@end
