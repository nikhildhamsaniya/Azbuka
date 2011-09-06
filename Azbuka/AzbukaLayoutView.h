#import <UIKit/UIKit.h>

@class LetterView;

@protocol AzbukaLayoutViewProto
-(void)tappedLetter:(int)index view:(UIView*)view;
@end

@interface AzbukaLayoutView : UIView {
    id<AzbukaLayoutViewProto> delegate;
    
    UIButton *prevButton;
    UIButton *nextButton;
    
    NSArray *letters;
    LetterView *exposedLetter;
}
@property(nonatomic, assign) id<AzbukaLayoutViewProto> delegate;
@property(nonatomic, readonly) UIImageView *exposedLetter;

-(void)exposeLetter:(int)index uponCompletionDo:(void (^)())aBlock;
-(void)unexpose;

@end
