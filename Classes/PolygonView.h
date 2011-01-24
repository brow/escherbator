//
//  PolygonView.h
//  Transform
//
//  Created by Thomas Brow on 1/23/11.
//  Copyright 2011 Tom Brow. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kNumVertices 4

@interface PolygonView : UIView {
	CGPoint vertices[kNumVertices];
	NSInteger selectedVertex;
}

@property (readonly) CGPoint *vertices;

@end
