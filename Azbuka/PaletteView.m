#import "PaletteView.h"
#import "CGGeometry+Utils.h"

static const float GAP = 5.0;

@implementation PaletteView

#pragma mark private

-(void)privateInit{
    red = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [red setImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
    [red addTarget:self action:@selector(onRed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:red];

    blue = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [blue setImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateNormal];
    [blue addTarget:self action:@selector(onBlue) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:blue];

    yellow = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [yellow setImage:[UIImage imageNamed:@"yellow.png"] forState:UIControlStateNormal];
    [yellow addTarget:self action:@selector(onYellow) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:yellow];

    green = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [green setImage:[UIImage imageNamed:@"green.png"] forState:UIControlStateNormal];
    [green addTarget:self action:@selector(onGreen) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:green];

    eraser = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [eraser setImage:[UIImage imageNamed:@"eraser.png"] forState:UIControlStateNormal];
    [eraser addTarget:self action:@selector(onEraser) forControlEvents:UIControlEventTouchUpInside];
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
    eraser.frame = (CGRect){CGPointZero, eraser.imageView.image.size};
    eraser.frame = CGRectConstraintToRect(eraser.frame, CGRectVerticalDimension, CGRectMaxConstraint, -GAP, 
                                          self.bounds, CGRectMaxConstraint);
    eraser.frame = CGRectConstraintToRect(eraser.frame, CGRectHorizontalDimension, CGRectMidConstraint, 0, 
                                          self.bounds, CGRectMidConstraint);
    
    
    CGRect colorsRect = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetMinY(eraser.frame));
    colorsRect = CGRectInset(colorsRect, GAP, GAP); 
    [self layoutColorsInRect:colorsRect];
}

-(void)layoutLandscape{
    eraser.frame = (CGRect){CGPointZero, eraser.imageView.image.size};
    eraser.frame = CGRectConstraintToRect(eraser.frame, CGRectHorizontalDimension, CGRectMaxConstraint, -GAP, 
                                          self.bounds, CGRectMaxConstraint);
    eraser.frame = CGRectConstraintToRect(eraser.frame, CGRectVerticalDimension, CGRectMidConstraint, 0, 
                                          self.bounds, CGRectMidConstraint);
    
    
    CGRect colorsRect = CGRectMake(0, 0, CGRectGetMinX(eraser.frame), CGRectGetHeight(self.bounds));
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
    
}

-(void)onBlue{

}

-(void)onYellow{
    
}

-(void)onGreen{
    
}

-(void)onErase{
    
}


@end
