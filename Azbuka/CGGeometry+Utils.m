#import "CGGeometry+Utils.h"

double deg2rad(double deg){
    return  deg * M_PI / 180;
}

double rad2deg(double rad){
    return rad * 180 / M_PI;
}

CGSize CGSizeScale(CGSize original, float scale){
    return CGSizeMake(original.width * scale, original.height * scale);
}

CGSize CGSizeInset(CGSize original, float delta){
    return CGSizeMake(original.width - delta*2, original.height - delta*2);
}

CGPoint CGPointScale(CGPoint original, float scale){
    return CGPointMake(original.x * scale, original.y * scale);
}

CGRect CGRectScale(CGRect original, float scale){
    return CGRectMake(original.origin.x * scale, original.origin.y * scale, 
                      original.size.width * scale, original.size.height * scale);
}

CGRect CGRectConsume(CGRect r, CGPoint pt){	
	return CGRectUnion(r, CGRectMake(pt.x, pt.y, 0, 0));
}

CGSize CGSizeFitIntoSize(CGSize original, CGSize fitInto){
	if(fitInto.width == 0.0 || fitInto.height == 0){
		return CGSizeMake(0, 0);
	}
	
	double originalRatio = original.width / original.height;
	double destRatio = fitInto.width / fitInto.height;
	
	CGSize result;	
	if(originalRatio > destRatio){
		result.width = fitInto.width;
		result.height = result.width / originalRatio;
	}else{
		result.height = fitInto.height;
		result.width = result.height * originalRatio;
	}
	
	return result;	 
}

CGRect CGSizeFitIntoRect(CGSize original, CGRect fitInto){
    CGSize sz = CGSizeFitIntoSize(original, fitInto.size);
    CGRect r = (CGRect){CGPointZero, sz};
    r = CGRectCenterToRect(r, fitInto);
    return  r;
}

CGSize CGSizeEnvelopSize(CGSize original, CGSize envelopOf){	
	if(original.width == 0.0 || original.height == 0){
		return CGSizeMake(0, 0);
	}
	
	double originalRatio = original.width / original.height;
	double destRatio = envelopOf.width / envelopOf.height;
	
	CGSize result;	
	if(originalRatio > destRatio){
		result.height = envelopOf.height;
		result.width = result.height * originalRatio;
	}else{
		result.width = envelopOf.width;
		result.height = result.width / originalRatio;
	}
	
	return result;	 
}

CGPoint CGRectCenter(CGRect r){
	return CGPointMake(CGRectGetMidX(r), CGRectGetMidY(r));	
}

CGRect CGRectCenterToPoint(CGRect original, CGPoint newCenter){
	CGPoint oldCenter = CGRectCenter(original);	
	original.origin.x += (newCenter.x - oldCenter.x);
	original.origin.y += (newCenter.y - oldCenter.y);
	return original;
}

CGRect CGRectCenterToRect(CGRect original, CGRect otherRect){
	return CGRectCenterToPoint(original, CGRectCenter(otherRect));	 
}


CGFloat CGPointDistanceToPoint(CGPoint point1, CGPoint point2) {
    CGFloat xDiff = point1.x - point2.x;
    CGFloat yDiff = point1.y - point2.y;
    return sqrt(xDiff*xDiff + yDiff*yDiff);
}

CGSize  CGSizeVector(CGPoint from, CGPoint to){
    return CGSizeMake(to.x - from.x, to.y - from.y);
}

CGPoint CGPointVector(CGPoint from, CGPoint to){
    return CGPointMake(to.x - from.x, to.y - from.y);
}

float CGPointDotProduct(CGPoint a, CGPoint b){
    return a.x * b.x + a.y * b.y;
}

float CGSizeDotProduct(CGSize a, CGSize b){
    return a.width * b.width + a.height * b.height;
}

CGPoint  CGPointAddPoint(CGPoint a, CGPoint b){
    return CGPointMake(a.x + b.x, a.y + b.y);
}

CGPoint  CGPointAddSize(CGPoint a, CGSize v){
    return CGPointMake(a.x + v.width, a.y + v.height);
}

float CGPointDistanceFromPointToSegment(CGPoint p, CGPoint s1, CGPoint s2){
    CGSize s = CGSizeVector(s1, s2);
    float l2 = powf(s.width, 2) + powf(s.height, 2); //avoid sqrt
    if (l2 == 0.0) return CGPointDistanceToPoint(p, s1);   // s1 == s2 case
    // Consider the line extending the segment, parameterized as s1 + t (s2 - s1).
    // We find projection of point p onto the line. 
    // It falls where t = [(p-s1) . (s2-s1)] / |s2-s1|^2
    float t = CGSizeDotProduct( CGSizeVector(s1,p), CGSizeVector(s1, s2) ) / l2;
    if (t < 0.0) return CGPointDistanceToPoint(p, s1);       // Beyond the 's1' end of the segment
    else if (t > 1.0) return CGPointDistanceToPoint(p, s2);  // Beyond the 's2' end of the segment
    CGPoint projection = CGPointAddSize(s1, CGSizeScale(CGSizeVector(s1, s2), t)); // s1 + t * (s2 - s1)
    float distance = CGPointDistanceToPoint(p, projection);
    return distance;
}

float CGSizeLength(CGSize vector){
    return sqrtf(powf(vector.width, 2) + powf(vector.height, 2));
}

CGAffineTransform CGAffineTransformMakeScaleAroundPoint(float sx, float sy, CGPoint pt){
    CGAffineTransform t = CGAffineTransformMakeTranslation(pt.x, pt.y);
    t = CGAffineTransformScale(t, sx, sy);
    t = CGAffineTransformTranslate(t, -pt.x, -pt.y);
    return t;
}

CGAffineTransform CGAffineTransformMakeRotationAroundPoint(float radians, CGPoint pt){
    CGAffineTransform t = CGAffineTransformMakeTranslation(pt.x, pt.y);
    t = CGAffineTransformRotate(t, radians);
    t = CGAffineTransformTranslate(t, -pt.x, -pt.y);
    return t;
}

CGAffineTransform CGAffineTransformAroundPoint(CGAffineTransform orig, CGPoint pt){
    CGAffineTransform t = CGAffineTransformMakeTranslation(pt.x, pt.y);
    t = CGAffineTransformConcat(orig, t);
    t = CGAffineTransformTranslate(t, -pt.x, -pt.y);
    return t;    
}

CGFloat GetConstraintValue(CGRect rect,  CGRectDimension dimension, CGRectConstraint constraint){
    switch(constraint){
        case CGRectMinConstraint: 
            return dimension == CGRectHorizontalDimension ? CGRectGetMinX(rect) : CGRectGetMinY(rect);
        case CGRectMaxConstraint: 
            return dimension == CGRectHorizontalDimension ? CGRectGetMaxX(rect) : CGRectGetMaxY(rect);
        case CGRectMidConstraint: 
            return dimension == CGRectHorizontalDimension ? CGRectGetMidX(rect) : CGRectGetMidY(rect);
    }
    return 0;
}

CGRect CGRectConstraintToRect(CGRect original, 
                              CGRectDimension dimension, 
                              CGRectConstraint originalConstraint, 
                              CGFloat shift,
                              CGRect to, 
                              CGRectConstraint toConstraint){
    CGFloat newValue = GetConstraintValue(to, dimension, toConstraint) + shift;
    switch(originalConstraint){
        case CGRectMinConstraint: 
            if(dimension == CGRectHorizontalDimension) original.origin.x = newValue;
            else original.origin.y = newValue;
            break;
        case CGRectMaxConstraint: 
            if(dimension == CGRectHorizontalDimension) original.origin.x = newValue - original.size.width;
            else original.origin.y = newValue - original.size.height;
            break;
        case CGRectMidConstraint: 
            if(dimension == CGRectHorizontalDimension) original.origin.x = newValue - original.size.width/2;
            else original.origin.y = newValue - original.size.height/2;
            break;
    }
    
    return original;
}