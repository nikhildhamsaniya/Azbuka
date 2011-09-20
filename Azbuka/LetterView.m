#import "LetterView.h"
#import <QuartzCore/QuartzCore.h>
#import "CGGeometry+Utils.h"
#import "PaintingView.h"

@implementation LetterView
@synthesize thumbnailSize = _thumbnailSize;

#pragma mark private

-(UIImage*)originalImage{
    return [UIImage imageNamed:[NSString stringWithFormat:@"%d.JPG", letterIndex + 1]];
}

-(UIImage*)generateThumbnail{
    UIGraphicsBeginImageContext(_thumbnailSize);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect r = (CGRect){CGPointZero, _thumbnailSize};
    CGContextConcatCTM(ctx, CGAffineTransformMakeScaleAroundPoint(1, -1, CGRectCenter(r)));
    CGContextDrawImage(ctx, r, self.originalImage.CGImage);
    UIImage* im =  [UIGraphicsGetImageFromCurrentImageContext() retain];
    UIGraphicsEndImageContext();
    return im;
}

-(UIImage*)thumbnailImage{
    if(!thumbnailImage) thumbnailImage = [self generateThumbnail];
    return thumbnailImage;
}

-(void)showPainting{
    if(painting) [painting release];
    painting = [[PaintingView alloc] initWithFrame:self.bounds];
    [painting setBrushColorWithRed:0 green:0 blue:1];
    [self addSubview:painting];
}

-(void)pickupPainting{
    [painting removeFromSuperview];
    [painting release];
    painting = nil;
}

#pragma mark properties

-(void)setThumbnailSize:(CGSize)thumbnailSize{
    _thumbnailSize = CGSizeScale( CGSizeFitIntoSize(self.originalImage.size, thumbnailSize), 2);
    [thumbnailImage release];
    thumbnailImage = nil;
}

#pragma mark lifecycle

-(id)initWithLetterIndex:(int)index{
    self = [super init];
    if (self) {
        letterIndex = index;
       
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.userInteractionEnabled = YES;

        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowOffset = CGSizeMake(3, 3);
        self.layer.shadowRadius = 3;   
        self.layer.shouldRasterize = YES;
    }
    return self;    
}

- (void)dealloc {
    [painting release];
    [thumbnailImage release];
    [super dealloc];
}

#pragma mark UIView

-(void)layoutSubviews{
    [super layoutSubviews];
//    painting.frame = self.bounds;
}

#pragma mark actions

-(void)beThumbnailed{
    self.image = self.thumbnailImage;
    [self pickupPainting];
    
}

-(void)willFullsized{
    self.image = self.originalImage;
}

-(void)didFullsized{
    [self showPainting];
}

- (void)setEraser{
    [painting setEraser];
}

- (void)setPaintingBrushColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue{
    [painting setBrushColorWithRed:red green:green blue:blue];
}

@end
