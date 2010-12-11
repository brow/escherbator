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
	ShaderTransformer *shaderTransformer;
}

@property (retain, nonatomic) IBOutlet UIImageView *beforeImageView;
@property (retain, nonatomic) IBOutlet UIImageView *afterImageView;

@end

