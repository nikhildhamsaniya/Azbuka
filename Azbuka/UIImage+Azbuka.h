@interface UIImage(Azbuka)
+(UIImage*)letterWithIndex:(int)index;
+(void)withEachLetterDo: (void (^)(UIImage*))aBlock;
@end
