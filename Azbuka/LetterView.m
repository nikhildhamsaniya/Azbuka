#import "LetterView.h"
#import <QuartzCore/QuartzCore.h>
#import "CGGeometry+Utils.h"
#import "PaintingView.h"

@interface LetterView()
@property(nonatomic, retain) UIImage *renderedPainting;
@end

@implementation LetterView
@synthesize thumbnailSize = _thumbnailSize;
@synthesize  renderedPainting;

#pragma mark private

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

-(NSString*)savedPaintingPath{
    NSString *filename = [NSString stringWithFormat:@"%d-saved-painting.png", letterIndex + 1];
    return [[self applicationDocumentsDirectory] stringByAppendingPathComponent:filename];
}

-(void)writePaintingToFile{
    if(painting)self.renderedPainting = painting.renderedPainting;
    NSData* paintingData = UIImagePNGRepresentation(self.renderedPainting);
    [paintingData writeToFile:[self savedPaintingPath] atomically:YES];    
}

-(void)loadPaintingFromFile{
    self.renderedPainting = [[[UIImage alloc] initWithContentsOfFile:[self savedPaintingPath]] autorelease];
}


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
    painting.autoresizingMask =     UIViewAutoresizingFlexibleLeftMargin |
                                    UIViewAutoresizingFlexibleWidth |
                                    UIViewAutoresizingFlexibleRightMargin |
                                    UIViewAutoresizingFlexibleTopMargin |
                                    UIViewAutoresizingFlexibleHeight | 
                                    UIViewAutoresizingFlexibleBottomMargin;

    [self addSubview:painting];
    painting.renderedPainting = self.renderedPainting;
}

-(void)pickupPainting{
    self.renderedPainting = painting.renderedPainting;
    [painting removeFromSuperview];
    [painting release];
    painting = nil;
    [self writePaintingToFile];
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
    [renderedPainting release];
    [painting release];
    [thumbnailImage release];
    [super dealloc];
}

#pragma mark actions

-(void)beContracted{
    self.image = self.thumbnailImage;
}

-(void)didContract{
    [self beContracted];
    [self pickupPainting];
}

-(void)willExpand{
    self.image = self.originalImage;
    [self showPainting];
    painting.alpha = 0;
}

-(void)animateContracting{
    painting.alpha = 0; 
}

-(void)animateExpanding{
    painting.alpha = 1;
}


- (void)setEraser{
    [painting setEraser];
}

- (void)setPaintingBrushColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue{
    [painting setBrushColorWithRed:red green:green blue:blue];
}

@end
