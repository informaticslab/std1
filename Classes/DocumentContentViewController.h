//
//  DocumentContentViewController.h
//  Std-Guide
//
//  Created by Greg Ledbetter on 10/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
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
#import "DocumentNode.h"
#import "FlipsideViewController.h"

@interface DocumentContentViewController : UIViewController <FlipsideViewControllerDelegate, ModalViewDelegate> 
{
	UIWebView *webView;
	DocumentNode *docNode;
}

@property(nonatomic, retain) DocumentNode *docNode;
@property(nonatomic, retain) IBOutlet UIWebView *webView; 

@end
