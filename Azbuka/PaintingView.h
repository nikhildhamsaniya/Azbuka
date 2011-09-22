#import <UIKit/UIKit.h>
#import "Painting.h"

#define kBrushOpacity		(5.0 / 6.0)
#define kBrushSize          32

@class Painting;
@class PaintingTool;

@interface PaintingView : UIView<PaintingDrawer>
{
    Painting *painting;
    UIImage *renderedPainting;
}
@property(nonatomic, retain) UIImage *renderedPainting;

-(void)setPaintingTool:(PaintingTool*)tool;

@end
