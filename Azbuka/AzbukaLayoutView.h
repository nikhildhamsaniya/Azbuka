#import <UIKit/UIKit.h>

@protocol AzbukaLayoutViewProto
-(void)tappedLetter:(int)index view:(UIView*)view;
@end

@interface AzbukaLayoutView : UIView {
    id<AzbukaLayoutViewProto> delegate;
    
    UIButton *prevButton;
    UIButton *nextButton;
    
    NSArray *letters;
    UIImageView *exposedLetter;
}
@property(nonatomic, assign) id<AzbukaLayoutViewProto> delegate;
@property(nonatomic, readonly) UIImageView *exposedLetter;

-(void)exposeLetter:(int)index uponCompletionDo:(void (^)())aBlock;
-(void)unexpose;

@end
