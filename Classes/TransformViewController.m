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

- (void) awakeFromNib {
	[super awakeFromNib];
	shaderTransformer = [[ShaderTransformer alloc] initWithResolution:CGSizeMake(475, 360) 
													 vertexShaderFile:[[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"]
												   fragmentShaderFile:[[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"]];
}

- (void)dealloc {
	[beforeImageView release];
	[afterImageView release];
	[shaderTransformer release];
    [super dealloc];
}

- (UIImage *) transformImage:(UIImage *)image byShader:(id)shader {
	return [shaderTransformer transformImage:image];
}

#pragma mark UIViewController methods

- (void) viewDidLoad {
	[super viewDidLoad];
	beforeImageView.image = [UIImage imageNamed:@"test.jpg"];
	afterImageView.image = [self transformImage:beforeImageView.image 
									   byShader:nil];
}

@end
