#import <Foundation/Foundation.h>


@interface LetterView : UIImageView {
    int letterIndex;
    UIImage *thumbnailImage;
}
@property(nonatomic, assign) CGSize thumbnailSize;
-(id)initWithLetterIndex:(int)index;

-(void)beThumbnailed;
-(void)beFullsized;

@end
