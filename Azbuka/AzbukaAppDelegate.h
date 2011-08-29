//
//  AzbukaAppDelegate.h
//  Azbuka
//
//  Created by loki on 30.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AzbukaViewController;

@interface AzbukaAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet AzbukaViewController *viewController;

@end
