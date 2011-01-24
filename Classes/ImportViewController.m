//
//  ImportViewController.m
//  Transform
//
//  Created by Thomas Brow on 1/23/11.
//  Copyright 2011 Tom Brow. All rights reserved.
//

#import "ImportViewController.h"
#import "TransformViewController.h"
#import "UIImage+Extras.h"

@implementation ImportViewController

@synthesize imageView, polygonView;

- (id)init {
    self = [super initWithNibName:@"ImportViewController" bundle:nil];
    if (self) {
		image = nil;
    }
    return self;
}

- (void)dealloc {
	[image release];
	[imageView release];
	[polygonView release];
    [super dealloc];
}

#pragma mark actions

- (IBAction)importFromLibrary:(id)sender {
	UIImagePickerController *imagePicker = [[[UIImagePickerController alloc] init] autorelease];
	imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	imagePicker.allowsEditing = YES;
	imagePicker.delegate = self;
	[self.navigationController presentModalViewController:imagePicker animated:YES];
}

- (IBAction)proceed:(id)sender {
	UIImage *slicedImage = [[image resizeTo:CGSizeMake(360, 360)] subtractQuad:polygonView.vertices];
	UIViewController *vc = [[[TransformViewController alloc] initWithImage:slicedImage] autorelease];
	[self.navigationController pushViewController:vc animated:YES];
}

#pragma mark UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	image = [[info objectForKey:UIImagePickerControllerEditedImage] retain];
	imageView.image = image;
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

#pragma mark UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
	self.imageView.image = image;
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.imageView = nil;
	self.polygonView = nil;
}


@end
