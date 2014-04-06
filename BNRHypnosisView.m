//
//  BNRHypnosisView.m
//  Hypnosister
//
//  Created by Jan Grassegger on 06.04.14.
//
//

#import "BNRHypnosisView.h"

@implementation BNRHypnosisView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //All BNRHypnosisViews start with a clear background color
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGRect bounds = self.bounds;
    
    //Figure out the center of the bounds rectangle
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0;
    
    // Thelarges circle will circumscribe the view
    float maxRadius = hypot(bounds.size.width, bounds.size.height) / 2.0;
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    for (float currentRadius = maxRadius; currentRadius > 0; currentRadius -= 20) {
        [path moveToPoint:CGPointMake(center.x + currentRadius, center.y)];
        
        [path addArcWithCenter:center
                        radius:currentRadius
                    startAngle:0
                      endAngle:M_PI*2.0
                     clockwise:YES];
    }
    
    //Configure line width to 10 pixels
    path.lineWidth = 10;
    
    //Configure the drawing color to light gray
    [[UIColor lightGrayColor] setStroke];
    
    //Draw the line
    [path stroke];
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    // Add gradient triangle (gold challenge)
    CGContextSaveGState(currentContext);
    UIBezierPath *trianglePath = [[UIBezierPath alloc] init];
    
    CGPoint triangleTop;
    triangleTop.x = bounds.size.width / 2;
    triangleTop.y = bounds.size.height / 4;
    [trianglePath moveToPoint:triangleTop];
    
    CGPoint triangleBottomLeft;
    triangleBottomLeft.x = bounds.size.width / 4;
    triangleBottomLeft.y = bounds.size.height * 0.75;
    [trianglePath addLineToPoint:triangleBottomLeft];
    
    CGPoint triangleBottomRight;
    triangleBottomRight.x = bounds.size.width * 0.75;
    triangleBottomRight.y = triangleBottomLeft.y;
    [trianglePath addLineToPoint:triangleBottomRight];
    
    [trianglePath addLineToPoint:triangleTop];
    
    [trianglePath addClip];
    
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = { 0.0, 1.0, 0.0, 1.0,
        1.0, 1.0, 0.0, 1.0};
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorspace, components, locations, 2);
    
    CGPoint endPoint;
    endPoint.x = bounds.size.width / 2;
    endPoint.y = bounds.size.height * 0.75;
    
    CGContextDrawLinearGradient(currentContext, gradient, triangleTop, endPoint, 0);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    
    CGContextRestoreGState(currentContext);
    
    
    // Add image with shadow (gold challenge)
    CGContextSaveGState(currentContext);
    
    CGSize shadowSize;
    shadowSize.height = 3;
    shadowSize.width = 3;
    CGContextSetShadow(currentContext, shadowSize, 2);
    
    UIImage *logoImage = [UIImage imageNamed:@"logo.png"];
    CGRect imageRect = CGRectMake(bounds.size.width/4.0, bounds.size.height / 4.0, bounds.size.width/2.0, bounds.size.height/2.0);
    [logoImage drawInRect:imageRect];
    
    CGContextRestoreGState(currentContext);
}


@end
