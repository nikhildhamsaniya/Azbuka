#import <UIKit/UIKit.h>

@class Azbuka;

@interface LettersNavigatorView : UIView {
    IBOutlet Azbuka* azbuka;
    
    // because I'm too lazy to make hilited versions of letters
    UIView *hiliter;
}

@end
