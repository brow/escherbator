//
//  UIImage+Extras.h
//  Transform
//
//  Created by Thomas Brow on 1/23/11.
//  Copyright 2011 Tom Brow. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage(Extras)

- (UIImage *)resizeTo:(CGSize)size;
- (UIImage *)subtractQuad:(CGPoint *)vertices;

@end
