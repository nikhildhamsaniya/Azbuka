#import "AzbukaView.h"
#import "CGGeometry+Utils.h"

@implementation AzbukaView

-(void)layoutSubviews{
    CGRect freeSpace;
    if(self.bounds.size.width < self.bounds.size.height){ // portrait
        float navigatorSide = 278;
        navigatorView.frame = CGRectMake(0, 0, 768, navigatorSide);        
        freeSpace = CGRectMake(0, navigatorSide, 768, 1004 - navigatorSide);
    }else{ // landscape
        float navigatorSide = 161;
        navigatorView.frame = CGRectMake(0, 0, navigatorSide, 748);
        freeSpace = CGRectMake(navigatorSide, 0, 1004 - navigatorSide, 748);
    }
    
    CGSize sz = CGSizeMake(CGRectGetHeight(freeSpace) / 4 * 3, CGRectGetHeight(freeSpace));
    CGRect frame = (CGRect){CGPointZero, sz};
    frame = CGRectCenterToRect(frame, freeSpace);
    letterView.frame = frame;
}


- (void)dealloc
{
    [navigatorView release];
    [letterView release];
    [super dealloc];
}

@end
