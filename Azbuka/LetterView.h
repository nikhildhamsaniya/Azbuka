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

-(void)beThumbnailed;
-(void)willFullsized;
-(void)didFullsized;

- (void)setEraser;
- (void)setPaintingBrushColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

@end
