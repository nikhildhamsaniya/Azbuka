#import <UIKit/UIKit.h>

@class LetterView;

@protocol AzbukaDeskViewProto
-(void)tappedLetter:(int)index view:(UIView*)view;
@end

@interface AzbukaDeskView : UIView {
    id<AzbukaDeskViewProto> delegate;
    
    UIButton *prevButton;
    UIButton *nextButton;
    
    NSArray *letters;
    LetterView *exposedLetter;
}
@property(nonatomic, assign) id<AzbukaDeskViewProto> delegate;
@property(nonatomic, readonly) UIImageView *exposedLetter;
@property(nonatomic, readonly) BOOL hasExposedLetter;

-(void)exposeLetter:(int)index uponCompletionDo:(void (^)())aBlock;
-(void)unexpose;

@end
