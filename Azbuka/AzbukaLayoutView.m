#import "AzbukaLayoutView.h"
#import "CGGeometry+Utils.h"
#import "UIImage+Azbuka.h"

static const float GAP = 5;
static const int colsInPortrait = 6;
static const int colsInLandscape = 7;

@implementation AzbukaLayoutView

-(void)privateInit{
    [UIImage withEachLetterDo:^(UIImage* image){
        UIImageView *v = [[UIImageView alloc] initWithImage:image];
        [self addSubview:v];
        [v release];        
    }];
}

-(void)calcRows:(int*)pRows colsInLastRow:(int*)pColsInLastRow givenCols:(int)cols{
    *pRows = 33 / cols;
    *pColsInLastRow = (33 - (*pRows) * cols);
    if(*pColsInLastRow != 0) (*pRows)++;
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
    int cols, rows, colsInLastRow;
    if(UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)){
        cols = colsInPortrait;
    }else{
        cols = colsInLandscape;
    }
    [self calcRows:&rows colsInLastRow:&colsInLastRow givenCols:cols];
    
    CGSize availSize;
    availSize.width = (self.bounds.size.width - (cols + 1) * GAP) / cols;
    availSize.height = (self.bounds.size.height - (rows + 1) * GAP) / rows;
    for(int row = 0; row < rows; row++){
        for(int col = 0; col < cols; col++){
            if(row == rows-1 && col >= colsInLastRow)
                break;
            
            int index = row * cols + col;
            CGPoint availRectOrigin = CGPointMake(GAP + (availSize.width + GAP)*col, GAP + (availSize.height + GAP)*row);
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
