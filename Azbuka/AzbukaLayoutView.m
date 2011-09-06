#import "AzbukaLayoutView.h"
#import "CGGeometry+Utils.h"
#import "UIImage+Azbuka.h"

static const float GAP = 5;

@implementation AzbukaLayoutView

-(void)privateInit{
    for(int i = 0; i < 33; i++){
        UIImage *image = [UIImage letterWithIndex:i + 1];
        UIImageView *v = [[UIImageView alloc] initWithImage:image];
        [self addSubview:v];
        [v release];
    }    
}

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

-(void)layoutSubviews{
    [super layoutSubviews];
    int cols, rows;
    if(UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)){
        cols = 3;
        rows = 11;
    }else{
        cols = 11;
        rows = 3;    
    }
    
    CGSize availSize;
    availSize.width = (self.bounds.size.width - (cols + 1) * GAP) / cols;
    availSize.height = (self.bounds.size.height - (rows + 1) * GAP) / rows;
    for(int row = 0; row < rows; row++){
        for(int col = 0; col < cols; col++){
            int index = row * cols + col;
            CGPoint availRectOrigin = CGPointMake(GAP + (availSize.width + GAP)*col, (availSize.height + GAP)*row);
            CGRect availRect = (CGRect){availRectOrigin, availSize};
            UIImageView *letter = [self.subviews objectAtIndex:index];
            CGSize letterSize = CGSizeFitIntoSize(letter.image.size, availSize);
            CGRect letterRect = CGSizeFitIntoRect(letterSize, availRect);
            letter.frame = letterRect;
        }
    }
}


- (void)dealloc
{
    [super dealloc];
}

@end
