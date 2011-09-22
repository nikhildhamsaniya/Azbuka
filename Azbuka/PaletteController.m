#import "PaletteController.h"
#import "Painting.h"
#import "SoundEffect.h"
#import "CGGeometry+Utils.h"
#import <QuartzCore/QuartzCore.h>

@interface PaletteController()
@property(nonatomic, retain, readwrite) PaintingTool* selectedTool;
@end

@implementation PaletteController
@synthesize delegate;
@synthesize selectedTool;

#pragma mark private

-(void)setViewShadow{
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOpacity = 1.0;
    self.view.layer.shadowOffset = CGSizeMake(3, 3);
    self.view.layer.shadowRadius = 3;
}

#pragma mark lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selectedTool = [Brush brushWithRed:0.5 green:0.5 blue:1];
}

- (void)dealloc
{
    [selectedTool release];
    [horPalette release];
    [vertPalette release];
    [super dealloc];
}


#pragma mark UIViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark accessing

-(void)loadHorizontalView{
    self.view = horPalette; 
    self.view.bounds = (CGRect){CGPointZero, CGSizeScale(CGSizeMake(488, 254), 0.8)};
    [self setViewShadow];
}

-(void)loadVerticalView{
    self.view = vertPalette;
    self.view.bounds = (CGRect){CGPointZero, CGSizeScale(CGSizeMake(254, 488), 0.65)};
    [self setViewShadow];
}

#pragma mark events

-(IBAction)onLightBlue{
    [[SoundEffect selectBrushEffect] play];
    self.selectedTool = [Brush brushWithRed:0.5 green:0.5 blue:1];
    [delegate paletteDidSelectTool:selectedTool];
}

-(IBAction)onBlue{
    [[SoundEffect selectBrushEffect] play];
    self.selectedTool = [Brush brushWithRed:0 green:0 blue:1];
    [delegate paletteDidSelectTool:selectedTool];    
}


-(IBAction)onViolet{
    [[SoundEffect selectBrushEffect] play];
    self.selectedTool = [Brush brushWithRed:1 green:0 blue:1];
    [delegate paletteDidSelectTool:selectedTool];    
}

-(IBAction)onGreen{
    [[SoundEffect selectBrushEffect] play];
    self.selectedTool = [Brush brushWithRed:0 green:1 blue:0];
    [delegate paletteDidSelectTool:selectedTool];    
}

-(IBAction)onRed{
    [[SoundEffect selectBrushEffect] play];
    self.selectedTool = [Brush brushWithRed:1 green:0 blue:0];
    [delegate paletteDidSelectTool:selectedTool];    
}

-(IBAction)onOrange{
    [[SoundEffect selectBrushEffect] play];
    self.selectedTool = [Brush brushWithRed:1 green:0.5 blue:0];
    [delegate paletteDidSelectTool:selectedTool];
}

-(IBAction)onYellow{
    [[SoundEffect selectBrushEffect] play];
    self.selectedTool = [Brush brushWithRed:1 green:1 blue:0];
    [delegate paletteDidSelectTool:selectedTool];    
}

-(IBAction)onBrown{
    [[SoundEffect selectBrushEffect] play];
    self.selectedTool = [Brush brushWithRed:100.0/255 green:45.0/255 blue:27.0/255];
    [delegate paletteDidSelectTool:selectedTool];
}

-(IBAction)onBlack{
    [[SoundEffect selectBrushEffect] play];
    self.selectedTool = [Brush brushWithRed:0 green:0 blue:0];
    [delegate paletteDidSelectTool:selectedTool];
}

-(IBAction)onErase{
    [[SoundEffect selectBrushEffect] play];
    self.selectedTool = [Eraser eraser];
    [delegate paletteDidSelectTool:selectedTool];
}

@end