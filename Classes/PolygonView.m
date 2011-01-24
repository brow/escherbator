//
//  PolygonView.m
//  Transform
//
//  Created by Thomas Brow on 1/23/11.
//  Copyright 2011 Tom Brow. All rights reserved.
//

#import "PolygonView.h"


@implementation PolygonView

- (void)awakeFromNib {
	[super awakeFromNib];
	vertices[0] = CGPointMake(0.25, 0.25);
	vertices[1] = CGPointMake(0.25, 0.75);
	vertices[2] = CGPointMake(0.75, 0.75);
	vertices[3] = CGPointMake(0.75, 0.25);
	selectedVertex = -1;
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark properties

- (CGPoint *)vertices {	
	return vertices;
}

#pragma mark UIResponder methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	CGPoint touchPoint = [[touches anyObject] locationInView:self];
	for (int i = 0; i < kNumVertices; i++) {
		CGPoint vertexPoint = CGPointMake(vertices[i].x * self.bounds.size.width, 
										  vertices[i].y * self.bounds.size.height);
		CGFloat distance = sqrt(pow(touchPoint.x - vertexPoint.x,2) + pow(touchPoint.y - vertexPoint.y,2));
		if (distance < 25)
			selectedVertex = i;
	}
	[self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if (selectedVertex > -1) {
		CGPoint oldTouchPoint = [[touches anyObject] previousLocationInView:self];
		CGPoint touchPoint = [[touches anyObject] locationInView:self];
		CGPoint delta = CGPointMake(touchPoint.x - oldTouchPoint.x, 
									touchPoint.y - oldTouchPoint.y);
		CGPoint deltaNormalized = CGPointMake(delta.x / self.bounds.size.width,
											  delta.y / self.bounds.size.height);
		vertices[selectedVertex] = CGPointMake(vertices[selectedVertex].x + deltaNormalized.x, 
											   vertices[selectedVertex].y + deltaNormalized.y);
	}
	[self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	selectedVertex = -1;
	[self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	selectedVertex = -1;
	[self setNeedsDisplay];
}

#pragma mark UIView methods

- (void)drawRect:(CGRect)rect {
	[[UIColor whiteColor] setStroke];
	[[[UIColor cyanColor] colorWithAlphaComponent:0.3] setFill];
	
	UIBezierPath *polygonPath = [UIBezierPath bezierPath];
	
	for (int i = 0; i < kNumVertices; i++) {
		CGPoint vertexPoint = CGPointMake(vertices[i].x * self.bounds.size.width, 
										  vertices[i].y * self.bounds.size.height);
		
		if (i == 0)
			[polygonPath moveToPoint:vertexPoint];
		else
			[polygonPath addLineToPoint:vertexPoint];
		
		CGRect circleRect = CGRectMake(vertexPoint.x - 15, 
									   vertexPoint.y - 15,
									   30, 
									   30);
		UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:circleRect];
		circlePath.lineWidth = 4;
		[circlePath stroke];
	}
	
	[polygonPath fill];
}

@end
