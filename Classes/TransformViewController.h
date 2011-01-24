//
//  TransformViewController.h
//  Transform
//
//  Created by Thomas Brow on 12/10/10.
//  Copyright 2010 Tom Brow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShaderTransformer.h"

@interface TransformViewController : UIViewController {
	UIImageView *beforeImageView;
	UIImageView *afterImageView;
	UISlider *alphaSlider, *r1Slider, *r2Slider;
	
	UIImage *beforeImage;
	ShaderTransformer *shaderTransformer;
}

@property (retain, nonatomic) IBOutlet UIImageView *beforeImageView;
@property (retain, nonatomic) IBOutlet UIImageView *afterImageView;
@property (retain, nonatomic) IBOutlet UISlider *alphaSlider, *r1Slider, *r2Slider;

- (IBAction) paramaterValueChanged:(id)sender;

@end

