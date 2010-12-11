//
//  TransformViewController.m
//  Transform
//
//  Created by Thomas Brow on 12/10/10.
//  Copyright 2010 Tom Brow. All rights reserved.
//

#import "TransformViewController.h"

CGPoint identity(CGPoint p) { return p; }

@implementation TransformViewController

@synthesize beforeImageView, afterImageView;
/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

- (void)dealloc {
	[beforeImageView release];
	[afterImageView release];
    [super dealloc];
}

- (UIImage *)transformImage:(UIImage *)image byFunction:(CGPoint(*)(CGPoint))fn {
	uint width = image.size.width;
	uint height = image.size.height;
	size_t bufferSize = width * height * 4;
	char *inputBuffer = malloc(bufferSize);
	char *outputBuffer = malloc(bufferSize);
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef input = CGBitmapContextCreate(inputBuffer, 
											   width,
											   height, 
											   8, 
											   4 * width, 
											   colorSpace, 
											   kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
	CGContextRef output = CGBitmapContextCreate(outputBuffer, 
											   width,
											   height, 
											   8, 
											   4 * width, 
											   colorSpace, 
											   kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
	
	CGContextDrawImage(input, CGRectMake(0, 0, width, height), [image CGImage]);

	for (uint x = 0; x < width; x++) {
		for (uint y = 0; y < height; y++) {
			uint index = (y * width + x) * 4;
			outputBuffer[index] = inputBuffer[index];
			outputBuffer[index+1] = inputBuffer[index+1];
			outputBuffer[index+2] = inputBuffer[index+2];
			outputBuffer[index+3] = inputBuffer[index+3];
		}
	}
	
	CGImageRef outputImage = CGBitmapContextCreateImage(output);
	UIImage *ret = [UIImage imageWithCGImage:outputImage];
	
	CGColorSpaceRelease(colorSpace);
	CGContextRelease(input);
	CGContextRelease(output);
	CGImageRelease(outputImage);
	
	return ret;
}

#pragma mark UIViewController methods

- (void) viewDidLoad {
	[super viewDidLoad];
	beforeImageView.image = [UIImage imageNamed:@"test.jpg"];
	afterImageView.image = [self transformImage:beforeImageView.image 
									 byFunction:identity];
}

@end
