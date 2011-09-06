#import <Foundation/Foundation.h>


@interface LetterView : UIImageView {
    int letterIndex;
    UIImage *thumbnailImage;
}
@property(nonatomic, assign) CGSize thumbnailSize;

-(void)beThumbnail;
-(void)beFullsized;

@end
