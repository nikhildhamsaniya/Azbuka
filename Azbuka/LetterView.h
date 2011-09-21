#import <Foundation/Foundation.h>

@class PaintingView;

@interface LetterView : UIImageView {
    int letterIndex;
    UIImage *thumbnailImage;
    
    PaintingView *painting;
    UIImage *renderedPainting;
}
@property(nonatomic, assign) CGSize thumbnailSize;
-(id)initWithLetterIndex:(int)index;

-(void)beContracted;
-(void)didContract;
-(void)willExpand;
-(void)animateContracting;
-(void)animateExpanding;

- (void)setEraser;
- (void)setPaintingBrushColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

-(void)writePaintingToFile;
-(void)loadPaintingFromFile;

@end
