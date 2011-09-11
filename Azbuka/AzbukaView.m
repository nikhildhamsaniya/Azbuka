#import "AzbukaView.h"
#import "PaletteView.h"

static const float PALETTE_MARGIN = 10;

@implementation AzbukaView

-(void)layoutSubviews{
    [super layoutSubviews];
    if(UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)){
        CGSize paletteSize = CGSizeMake(430, 150);
        paletteView.frame = CGRectMake(CGRectGetWidth(self.bounds) - paletteSize.width - PALETTE_MARGIN, 
                                       CGRectGetHeight(self.bounds) - paletteSize.height - PALETTE_MARGIN, 
                                       paletteSize.width, paletteSize.height);
    }else{
        CGSize paletteSize = CGSizeMake(200, 280);
        paletteView.frame = CGRectMake(CGRectGetWidth(self.bounds) - paletteSize.width - PALETTE_MARGIN, 
                                       PALETTE_MARGIN, paletteSize.width, paletteSize.height);
    }
}

- (void)dealloc
{
    [paletteView release];
    [super dealloc];
}

@end
