#import "PaletteView.h"
#import "CGGeometry+Utils.h"
#import <QuartzCore/QuartzCore.h>
#import "SoundEffect.h"

static const float GAP = 5.0;

@implementation PaletteView
@synthesize delegate;

#pragma mark private

-(UIView*)newColorButtonForColor:(UIColor*)color handler:(SEL)handler{
    UIView *button = [UIView new];
    button.backgroundColor = color;
    button.layer.cornerRadius = 10;
    UITapGestureRecognizer *gr = [[[UITapGestureRecognizer alloc] initWithTarget:self action:handler] autorelease];
    [button addGestureRecognizer:gr];
    return button; 
}

-(void)privateInit{
    self.layer.cornerRadius = 10;
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(3, 3);
    self.layer.shadowRadius = 3;   
    self.layer.shouldRasterize = YES;
    
    red = [self newColorButtonForColor:[UIColor redColor] handler:@selector(onRed)];
    [self addSubview:red];
    blue = [self newColorButtonForColor:[UIColor blueColor] handler:@selector(onBlue)];
    [self addSubview:blue];
    yellow = [self newColorButtonForColor:[UIColor yellowColor] handler:@selector(onYellow)];
    [self addSubview:yellow];
    green = [self newColorButtonForColor:[UIColor greenColor] handler:@selector(onGreen)];
    [self addSubview:green];
    
    eraser = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [eraser setImage:[UIImage imageNamed:@"eraser.png"] forState:UIControlStateNormal];
    [eraser addTarget:self action:@selector(onErase) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:eraser];
}

-(void)layoutColorsInRect:(CGRect)rect{
    CGSize colorSize = CGSizeMake(90, 50);
    
    CGPoint center = CGPointMake(CGRectGetMinX(rect) + CGRectGetWidth(rect) / 4, 
                                 CGRectGetMinY(rect) + CGRectGetHeight(rect) / 4);    
    red.frame = CGRectCenterToPoint((CGRect){CGPointZero, colorSize}, center);
    
    center = CGPointMake(CGRectGetMaxX(rect) - CGRectGetWidth(rect) / 4, 
                         CGRectGetMinY(rect) + CGRectGetHeight(rect) / 4);    
    blue.frame = CGRectCenterToPoint((CGRect){CGPointZero, colorSize}, center);
    
    center = CGPointMake(CGRectGetMinX(rect) + CGRectGetWidth(rect) / 4, 
                         CGRectGetMaxY(rect) - CGRectGetHeight(rect) / 4);    
    yellow.frame = CGRectCenterToPoint((CGRect){CGPointZero, colorSize}, center);
    
    center = CGPointMake(CGRectGetMaxX(rect) - CGRectGetWidth(rect) / 4, 
                         CGRectGetMaxY(rect) - CGRectGetHeight(rect) / 4);    
    green.frame = CGRectCenterToPoint((CGRect){CGPointZero, colorSize}, center);    
}

-(void)layoutPortrait{
    CGRect eraserFrame = (CGRect){CGPointZero, CGSizeFitIntoSize([UIImage imageNamed:@"eraser.png"].size, self.bounds.size)};
    eraserFrame = CGRectInset(eraserFrame, GAP, GAP);
    eraser.frame = eraserFrame;
    eraser.frame = CGRectConstraintToRect(eraser.frame, CGRectHorizontalDimension, CGRectMaxConstraint, -GAP, 
                                          self.bounds, CGRectMaxConstraint);
    eraser.frame = CGRectConstraintToRect(eraser.frame, CGRectVerticalDimension, CGRectMidConstraint, 0, 
                                          self.bounds, CGRectMidConstraint);
    
    
    CGRect colorsRect = CGRectMake(0, 0, CGRectGetMinX(eraser.frame), CGRectGetHeight(self.bounds));
    colorsRect = CGRectInset(colorsRect, GAP, GAP);
    [self layoutColorsInRect:colorsRect];
}

-(void)layoutLandscape{
    CGRect eraserFrame = (CGRect){CGPointZero, CGSizeFitIntoSize([UIImage imageNamed:@"eraser.png"].size, self.bounds.size)};
    eraserFrame = CGRectInset(eraserFrame, GAP, GAP);
    eraser.frame = eraserFrame;
    eraser.frame = CGRectConstraintToRect(eraser.frame, CGRectVerticalDimension, CGRectMaxConstraint, -GAP, 
                                          self.bounds, CGRectMaxConstraint);
    eraser.frame = CGRectConstraintToRect(eraser.frame, CGRectHorizontalDimension, CGRectMidConstraint, 0, 
                                          self.bounds, CGRectMidConstraint);
    
    
    CGRect colorsRect = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetMinY(eraser.frame));
    colorsRect = CGRectInset(colorsRect, GAP, GAP); 
    [self layoutColorsInRect:colorsRect];
}

#pragma mark lifecycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self privateInit];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self privateInit];
}

- (void)dealloc
{
    [red release];
    [blue release];
    [yellow release];
    [green release];
    [eraser release];
    
    [super dealloc];
}

#pragma mark UIView

-(void)layoutSubviews{
    BOOL isPortrait = UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
    
    if(isPortrait)[self layoutPortrait];
    else [self layoutLandscape];
}

#pragma mark actions

-(void)onRed{
    [[SoundEffect selectBrushEffect] play];
    selectedColorIndex = 0;
    [self updateSelectedColor];
}

-(void)onBlue{
    [[SoundEffect selectBrushEffect] play];
    selectedColorIndex = 1;
    [self updateSelectedColor];
}

-(void)onYellow{
    [[SoundEffect selectBrushEffect] play];
    selectedColorIndex = 2;
    [self updateSelectedColor];
}

-(void)onGreen{
    [[SoundEffect selectBrushEffect] play];
    selectedColorIndex = 3;
    [self updateSelectedColor];
}

-(void)onErase{
    [[SoundEffect eraseEffect] play];
    [delegate paletteDidErase];
}

-(void)updateSelectedColor{
    switch (selectedColorIndex) {
        case 0:
            [delegate paletteDidChooseColorWithRed:1 green:0 blue:0];
            break;
        case 1:
            [delegate paletteDidChooseColorWithRed:0 green:0 blue:1];
            break;            
        case 2:
            [delegate paletteDidChooseColorWithRed:1 green:1 blue:0];
            break;
        case 3:
            [delegate paletteDidChooseColorWithRed:0 green:1 blue:0];
            break;
        default:
            break;
    }
}

@end
