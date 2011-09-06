#import "UIImage+Azbuka.h"


@implementation UIImage(Azbuka)

+(UIImage*)letterWithIndex:(int)index{
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.JPG", index + 1]];
    return image;
}

+(void)withEachLetterDo: (void (^)(UIImage*))aBlock{
    for(int i = 0; i < 33; i++){
        aBlock([self letterWithIndex:i]);
    }
}

@end
