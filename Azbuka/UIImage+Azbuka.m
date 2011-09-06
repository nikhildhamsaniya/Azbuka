#import "UIImage+Azbuka.h"


@implementation UIImage(Azbuka)

+(void)withEachLetterDo: (void (^)(UIImage*))aBlock{
    for(int i = 1; i <= 33; i++){
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.JPG", i]];
        aBlock(image);
    }
}

@end
