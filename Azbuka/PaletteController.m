#import "PaletteController.h"
#import "Painting.h"
#import "SoundEffect.h"
#import "CGGeometry+Utils.h"
#import <QuartzCore/QuartzCore.h>
#import "PaletteToolButton.h"

@interface PaletteButtonModel : NSObject {
    UIImage *horNormal, *horSelected, *vertNormal, *vertSelected;
}
@property(nonatomic, assign) UIButton *hor;
@property(nonatomic, assign) UIButton *vert;
@property(nonatomic, retain) PaintingTool *tool;
@property(nonatomic, assign) BOOL selected;

@end

@implementation PaletteButtonModel
@synthesize hor, vert, tool;

-(void)setHor:(UIButton *)_hor{
    hor = _hor;
    horNormal = [[hor imageForState:UIControlStateNormal] retain];
    horSelected = [[hor imageForState:UIControlStateSelected] retain];
    [hor setImage:horSelected forState:UIControlStateHighlighted];
}

-(void)setVert:(UIButton *)_vert{
    vert = _vert;
    vertNormal = [[vert imageForState:UIControlStateNormal] retain];
    vertSelected = [[vert imageForState:UIControlStateSelected] retain];
    [vert setImage:vertSelected forState:UIControlStateHighlighted];
}

-(BOOL)selected{
    return  hor.selected;
}

-(void)setSelected:(BOOL)selected{
    [hor setImage:selected ? horSelected : horNormal forState:UIControlStateNormal];
    [hor setImage:selected ? horSelected : horNormal forState:UIControlStateSelected];
    [vert setImage:selected ? vertSelected : vertNormal forState:UIControlStateNormal];
    [vert setImage:selected ? vertSelected : vertNormal forState:UIControlStateSelected];
}

-(BOOL)isMyButton:(UIButton*)btn{
    return hor == btn || vert == btn;
}


- (void)dealloc {
    [horNormal release];
    [horSelected release];
    [vertNormal release];
    [vertSelected release];
    
    [tool release];
    [super dealloc];
}

@end


////////////////////////////////////////////////////////////

@interface PaletteController()
@property(nonatomic, assign) PaletteButtonModel *selectedButton;
@end

@implementation PaletteController
@synthesize selectedButton;
@synthesize delegate;

#pragma mark private


-(PaintingTool*)selectedTool{
    return selectedButton.tool;
}

-(void)setViewShadow{
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOpacity = 1.0;
    self.view.layer.shadowOffset = CGSizeMake(3, 3);
    self.view.layer.shadowRadius = 3;
}

-(void)initButtons{
    buttonModels = [NSMutableArray new];
    
    PaletteButtonModel *model = nil;
    
    model = [[PaletteButtonModel new] autorelease];
    model.hor = lightblueBtnHor;
    model.vert = lightblueBtnVert;
    model.tool = [Brush brushWithRed:0.5 green:0.5 blue:1];
    [buttonModels addObject:model];
    
    model = [[PaletteButtonModel new] autorelease];
    model.hor = blueBtnHor;
    model.vert = blueBtnVert;
    model.tool = [Brush brushWithRed:0 green:0 blue:1];
    [buttonModels addObject:model];
    
    model = [[PaletteButtonModel new] autorelease];
    model.hor = violetBtnHor;
    model.vert = violetBtnVert;
    model.tool = [Brush brushWithRed:1 green:0 blue:1];
    [buttonModels addObject:model];
    
    model = [[PaletteButtonModel new] autorelease];
    model.hor = greenBtnHor;
    model.vert = greenBtnVert;
    model.tool = [Brush brushWithRed:0 green:1 blue:0];
    [buttonModels addObject:model];
    
    model = [[PaletteButtonModel new] autorelease];
    model.hor = redBtnHor;
    model.vert = redBtnVert;
    model.tool = [Brush brushWithRed:1 green:0 blue:0];
    [buttonModels addObject:model];
    
    model = [[PaletteButtonModel new] autorelease];
    model.hor = orangeBtnHor;
    model.vert = orangeBtnVert;
    model.tool = [Brush brushWithRed:1 green:0.5 blue:0];
    [buttonModels addObject:model];
    
    model = [[PaletteButtonModel new] autorelease];
    model.hor = yellowBtnHor;
    model.vert = yellowBtnVert;
    model.tool = [Brush brushWithRed:1 green:1 blue:0];
    [buttonModels addObject:model];
    
    model = [[PaletteButtonModel new] autorelease];
    model.hor = brownBtnHor;
    model.vert = brownBtnVert;
    model.tool = [Brush brushWithRed:100.0/255 green:45.0/255 blue:27.0/255];
    [buttonModels addObject:model];
    
    model = [[PaletteButtonModel new] autorelease];
    model.hor = blackBtnHor;
    model.vert = blackBtnVert;
    model.tool = [Brush brushWithRed:0 green:0 blue:0];
    [buttonModels addObject:model];
    
    model = [[PaletteButtonModel new] autorelease];
    model.hor = eraseBtnHor;
    model.vert = eraseBtnVert;
    model.tool = [Eraser eraser];
    [buttonModels addObject:model];
}

-(void)setSelectedButton:(PaletteButtonModel *)_selectedButton{
    selectedButton = _selectedButton;
        
    for (PaletteButtonModel* curBtn in buttonModels) {
        curBtn.selected = curBtn == _selectedButton;
    }
    [delegate paletteDidSelectTool:self.selectedTool];
}

-(void)selectByButton:(UIButton*)btn{
    for (PaletteButtonModel* mdl in buttonModels) {
        if([mdl isMyButton:btn]){
            self.selectedButton = mdl;
            [mdl.tool.soundEffect play];
            break;
        }
    }
}
           
#pragma mark lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initButtons];
    
    self.selectedButton = [buttonModels objectAtIndex:0];
}

- (void)dealloc
{    
    [lightblueBtnHor release];
    [lightblueBtnVert release];
    [blueBtnHor release];
    [blueBtnVert release];
    [violetBtnHor release];
    [violetBtnVert release];
    [greenBtnHor release];
    [greenBtnVert release];
    [redBtnHor release];
    [redBtnVert release];
    [orangeBtnHor release];
    [orangeBtnVert release];
    [yellowBtnHor release];
    [yellowBtnVert release];
    [brownBtnHor release];
    [brownBtnVert release];
    [blackBtnHor release];
    [blackBtnVert release];
    [eraseBtnHor release];
    [eraseBtnVert release];
    
    [buttonModels release];
    
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

-(IBAction)onToolSelected:(id)toolButton{
    [self selectByButton:toolButton];
}

@end