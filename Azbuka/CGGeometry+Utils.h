#import <UIKit/UIKit.h>

double deg2rad(double deg);
double rad2deg(double rad);

CGSize CGSizeScale(CGSize original, float scale);
CGSize CGSizeInset(CGSize original, float delta);

CGPoint CGPointScale(CGPoint original, float scale);

CGRect CGRectScale(CGRect original, float scale);

CGRect CGRectConsume(CGRect r, CGPoint pt);
CGSize CGSizeFitIntoSize(CGSize original, CGSize fitInto);
CGSize CGSizeEnvelopSize(CGSize original, CGSize envelopOf);

CGPoint CGRectCenter(CGRect r);
CGRect CGRectCenterToPoint(CGRect original, CGPoint newCenter);
CGRect CGRectCenterToRect(CGRect original, CGRect otherRect);

CGFloat CGPointDistanceToPoint(CGPoint point1, CGPoint point2);
CGSize  CGSizeVector(CGPoint from, CGPoint to);
CGPoint  CGPointVector(CGPoint from, CGPoint to);
float CGPointDotProduct(CGPoint a, CGPoint b);
float CGSizeDotProduct(CGSize a, CGSize b);
CGPoint  CGPointAddPoint(CGPoint a, CGPoint b);
CGPoint  CGPointAddSize(CGPoint a, CGSize v);
float CGPointDistanceFromPointToSegment(CGPoint p, CGPoint s1, CGPoint s2);
float CGSizeLength(CGSize vector);

CGAffineTransform CGAffineTransformMakeScaleAroundPoint(float sx, float sy, CGPoint pt);
CGAffineTransform CGAffineTransformMakeRotationAroundPoint(float radians, CGPoint pt);
CGAffineTransform CGAffineTransformAroundPoint(CGAffineTransform orig, CGPoint pt);