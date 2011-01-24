//
//  ImportViewController.h
//  Transform
//
//  Created by Thomas Brow on 1/23/11.
//  Copyright 2011 Tom Brow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PolygonView.h"

@interface ImportViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
	UIImageView *imageView;
	PolygonView *polygonView;
	
	UIImage *image;
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet PolygonView *polygonView;

- (IBAction)importFromLibrary:(id)sender;
- (IBAction)proceed:(id)sender;

@end
