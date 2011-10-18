#import "PaletteToolButton.h"
#import "Painting.h"
#import "SoundEffect.h"

@implementation PaletteToolButton
@synthesize tool;

- (void) awakeFromNib{
	[super awakeFromNib];
    normalImage = [[self imageForState:UIControlStateNormal] retain];
    selectedImage = [[self imageForState:UIControlStateSelected] retain];
    [self setImage:selectedImage forState:UIControlStateHighlighted];
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    [self setImage:selected ? selectedImage : normalImage forState:UIControlStateNormal];
    [self setImage:selected ? selectedImage : normalImage forState:UIControlStateSelected];
    if(selected){
        [tool.soundEffect play];
    }
}

- (void)dealloc {
    [normalImage release];
    [selectedImage release];
    
    [tool release];
    [super dealloc];
}

@end
