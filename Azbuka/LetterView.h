#import <Foundation/Foundation.h>

@class PaintingTool;
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

- (void)setPaintingTool:(PaintingTool*)tool;

-(void)writePaintingToFile;
-(void)loadPaintingFromFile;

@end
