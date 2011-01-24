//
//  UIImage+Extras.m
//  Transform
//
//  Created by Thomas Brow on 1/23/11.
//  Copyright 2011 Tom Brow. All rights reserved.
//

#import "UIImage+Extras.h"


@implementation UIImage(Extras)

- (UIImage *)resizeTo:(CGSize)size {
	UIGraphicsBeginImageContext(size);
	[self drawInRect:CGRectMake(0, 0, size.width, size.height)];
	UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return ret;
}

- (UIImage *)subtractQuad:(CGPoint *)vertices {
	UIGraphicsBeginImageContext(self.size);
	
	[self drawAtPoint:CGPointZero];
	
	UIBezierPath *quadPath = [UIBezierPath bezierPath];
	for (int i = 0; i < 4; i++) {
		CGPoint vertexPoint = CGPointMake(vertices[i].x * self.size.width, 
										  vertices[i].y * self.size.height);
		if (i == 0)
			[quadPath moveToPoint:vertexPoint];
		else
			[quadPath addLineToPoint:vertexPoint];
	}
	[quadPath fillWithBlendMode:kCGBlendModeClear alpha:1.0];
	
	UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return ret;
}

@end
