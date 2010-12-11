//
//  TransformAppDelegate.h
//  Transform
//
//  Created by Thomas Brow on 12/10/10.
//  Copyright 2010 Tom Brow. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TransformViewController;

@interface TransformAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TransformViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TransformViewController *viewController;

@end

