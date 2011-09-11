#import <UIKit/UIKit.h>

@class LetterView;

@protocol AzbukaDeskViewProto
-(void)willExposeLetter:(int)index view:(UIView*)view;
-(void)didExposeLetter:(int)index view:(UIView*)view;
-(void)allLettersWillUnexposed;
-(void)allLettersDidUnexposed;
@end

@interface AzbukaDeskView : UIView {
    id<AzbukaDeskViewProto> delegate;
    
    UIButton *prevButton;
    UIButton *nextButton;
    
    NSArray *letters;
    LetterView *exposedLetter;
}
@property(nonatomic, assign) id<AzbukaDeskViewProto> delegate;
@property(nonatomic, readonly) LetterView *exposedLetter;
@property(nonatomic, readonly) BOOL hasExposedLetter;

-(void)exposeLetter:(int)index;
-(void)unexpose;

@end
