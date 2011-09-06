#import "UIImage+Azbuka.h"


@implementation UIImage(Azbuka)
+(UIImage*)letterWithIndex:(int)index{
    return [UIImage imageNamed:[NSString stringWithFormat:@"%d.JPG", index]];
}
@end
