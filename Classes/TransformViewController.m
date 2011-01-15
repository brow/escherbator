//
//  TransformViewController.m
//  Transform
//
//  Created by Thomas Brow on 12/10/10.
//  Copyright 2010 Tom Brow. All rights reserved.
//

#import "TransformViewController.h"

@implementation TransformViewController

@synthesize beforeImageView, afterImageView, alphaSlider, r1Slider, r2Slider;

- (void) awakeFromNib {
	[super awakeFromNib];
	shaderTransformer = [[ShaderTransformer alloc] initWithResolution:CGSizeMake(360, 360) 
													 vertexShaderFile:[[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"]
												   fragmentShaderFile:[[NSBundle mainBundle] pathForResource:@"Identity" ofType:@"fsh"]];
}

- (void)dealloc {
	[beforeImageView release];
	[afterImageView release];
	[alphaSlider release];
	[r1Slider release];
	[r2Slider release];
	[shaderTransformer release];
    [super dealloc];
}

- (UIImage *) transformImage:(UIImage *)image byShader:(id)shader {
	
	return [shaderTransformer transformImage:image];
}

#pragma mark actions

- (IBAction) paramaterValueChanged:(id)sender {
	
	if (sender == r1Slider || sender == r2Slider || sender == self) {
		alphaSlider.value = M_PI / 2.0 - atan((2 * M_PI) / log(r2Slider.value / r1Slider.value));
	}
	
	[shaderTransformer setUniforms:[NSDictionary dictionaryWithObjectsAndKeys:
									[NSNumber numberWithFloat:	alphaSlider.value],	@"alpha",
									[NSNumber numberWithFloat:	r1Slider.value],	@"r1",
									[NSNumber numberWithFloat:	r2Slider.value],	@"r2",
									nil ]];
	afterImageView.image = [self transformImage:beforeImageView.image 
									   byShader:nil];
}

#pragma mark UIViewController methods

- (void) viewDidLoad {
	[super viewDidLoad];
	beforeImageView.image = [UIImage imageNamed:@"test.jpg"];
	[self paramaterValueChanged:self];
}

@end
