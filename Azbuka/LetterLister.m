#import "LetterLister.h"
#import "UIImage+Azbuka.h"
#import "CGGeometry+Utils.h"

@implementation LetterLister

#pragma mark private

-(void)privateInit{
    self.delegate = self;
    self.dataSource = self;    
}

#pragma mark LeavesViewDataSource, LeavesViewDelegate

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:(CGRect)frame];
    if (self) {
        [self privateInit];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self privateInit];
}

- (NSUInteger) numberOfPagesInLeavesView:(LeavesView*)leavesView{
    return 33;
}

- (void) renderPageAtIndex:(NSUInteger)index inContext:(CGContextRef)ctx{
//    CGAffineTransform t = CGContextGetCTM(ctx);
//    NSLog(@"%@",  NSStringFromCGAffineTransform(t));
    UIImage *image = [UIImage letterWithIndex:index];
    CGRect rect =  CGContextGetClipBoundingBox(ctx);    
    CGContextDrawImage(ctx, rect, image.CGImage);
}


@end
