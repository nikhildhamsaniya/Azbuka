#import "LetterView.h"
#import <QuartzCore/QuartzCore.h>
#import "CGGeometry+Utils.h"

@implementation LetterView
@synthesize thumbnailSize = _thumbnailSize;

#pragma mark private

-(UIImage*)originalImage{
    return [UIImage imageNamed:[NSString stringWithFormat:@"%d.JPG", letterIndex + 1]];
}

-(UIImage*)generateThumbnail{
    UIGraphicsBeginImageContext(_thumbnailSize);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextDrawImage(ctx, (CGRect){CGPointZero, _thumbnailSize}, self.originalImage.CGImage);
    UIImage* im =  [UIGraphicsGetImageFromCurrentImageContext() retain];
    UIGraphicsEndImageContext();
    return im;
}

-(UIImage*)thumbnailImage{
    if(!thumbnailImage) thumbnailImage = [self generateThumbnail];
    return thumbnailImage;
}

#pragma mark properties

-(void)setThumbnailSize:(CGSize)thumbnailSize{
    _thumbnailSize = CGSizeFitIntoSize(self.originalImage.size, thumbnailSize);
    [thumbnailImage release];
    thumbnailImage = nil;
}

#pragma mark lifecycle

-(id)initWithLetterIndex:(int)index{
    self = [super init];
    if (self) {
        letterIndex = index;
        
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowOffset = CGSizeMake(3, 3);
        self.layer.shadowRadius = 3;        
    }
    return self;    
}

- (void)dealloc {
    [thumbnailImage release];
    [super dealloc];
}

#pragma mark actions

-(void)beThumbnail{
    self.image = self.thumbnailImage;
}

-(void)beFullsized{
    self.image = self.originalImage;
}


@end
