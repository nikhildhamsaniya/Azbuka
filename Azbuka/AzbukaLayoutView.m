#import "AzbukaLayoutView.h"
#import "CGGeometry+Utils.h"
#import "LetterView.h"

static const float GAP = 5;
static const int colsInPortrait = 6;
static const int colsInLandscape = 7;
static const float animationDuration = 0.5;

@implementation AzbukaLayoutView
@synthesize delegate;
@synthesize  exposedLetter;

#pragma mark private

-(void)calcCols:(int*)pCols rows:(int*)pRows colsInLastRow:(int*)pColsInLastRow{
    if(UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)){
        *pCols = colsInPortrait;
    }else{
        *pCols = colsInLandscape;
    }
    
    *pRows = 33 / (*pCols);
    *pColsInLastRow = (33 - (*pRows) * (*pCols));
    if(*pColsInLastRow != 0) (*pRows)++;
}

-(CGSize)gridCellSize{
    int cols, rows, colsInLastRow;
    [self calcCols:&cols rows:&rows colsInLastRow:&colsInLastRow];    
    CGSize  cellSize;
    cellSize.width = (self.bounds.size.width - (cols + 1) * GAP) / cols;
    cellSize.height = (self.bounds.size.height - (rows + 1) * GAP) / rows;
    return  cellSize;
}

-(void)initButtons{
    UIImage *im = [UIImage imageNamed:@"prev_button.png"];
    prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [prevButton setImage:im forState:UIControlStateNormal];
    prevButton.bounds = (CGRect){CGPointZero, im.size};
    [prevButton addTarget:self action:@selector(onPrevButton) forControlEvents:UIControlEventTouchUpInside];
    prevButton.alpha = 0; prevButton.hidden = YES;
    [self addSubview:prevButton];    
    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    im = [UIImage imageNamed:@"next_button.png"];
    [nextButton setImage:im forState:UIControlStateNormal];
    nextButton.bounds = (CGRect){CGPointZero, im.size};
    [nextButton addTarget:self action:@selector(onNextButton) forControlEvents:UIControlEventTouchUpInside];
    nextButton.alpha = 0; nextButton.hidden = YES;
    [self addSubview:nextButton];    
}

-(void)initLetters{
    NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:33];
    for(int i = 0; i < 33; i++){
        LetterView *v = [[[LetterView alloc] initWithLetterIndex:i] autorelease];
        v.thumbnailSize = [self gridCellSize];
        [v beThumbnail];
        UIGestureRecognizer *gr = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)] autorelease];
        [v addGestureRecognizer:gr];
        
        [self addSubview:v];
        [tmp addObject:v];
    }
    letters = [tmp copy];
}

-(void)privateInit{
    [self initLetters];
    [self initButtons];
}

-(int)exposedLetterIndex{
    return [letters indexOfObject:exposedLetter];
}

-(CGRect)exposedLetterRect{
    BOOL isPortrait = UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
    CGRect r;
    if(isPortrait){
        r = CGRectScale(self.bounds, 0.75);
        r.origin.y = 5;
        r.origin.x = (self.bounds.size.width - r.size.width) / 2;
    }else{
        r = self.bounds;
        r = CGRectInset(r, 0, 5);
    }
    return CGSizeFitIntoRect(exposedLetter.bounds.size, r);
}

-(void)layoutExposedLetter{
    exposedLetter.transform = CGAffineTransformIdentity;
    exposedLetter.frame = [self exposedLetterRect];
}

-(void)deckLetter:(LetterView*)v{
    CGPoint deckAnchor = CGPointMake(100, self.bounds.size.height - 100);
    
    CGPoint shift = CGPointMake(10-rand()%20, 10-rand()%20);
    v.bounds = (CGRect){CGPointZero, CGSizeFitIntoSize(v.image.size, [self gridCellSize])};
    v.center = CGPointAddPoint(deckAnchor, shift);    
    CGAffineTransform t = CGAffineTransformRotate(v.transform, deg2rad((double)(50 - rand() % 100) / 10) );
    v.transform = t;    
}

-(void)deckOtherLetters{
    for (LetterView *v in letters) {
        if(v != exposedLetter){
            [self deckLetter:v];
        }
    }
}

-(void)layoutLetters{
    int cols, rows, colsInLastRow;    
    [self calcCols:&cols rows:&rows colsInLastRow:&colsInLastRow];    
    CGSize cellSize = [self gridCellSize];
    
    for(int row = 0; row < rows; row++){
        for(int col = 0; col < cols; col++){
            if(row == rows-1 && col >= colsInLastRow)
                break;
            
            int index = row * cols + col;
            UIImageView *letter = [letters objectAtIndex:index];
            letter.transform = CGAffineTransformIdentity;
            
            CGPoint availRectOrigin = CGPointMake(GAP + (cellSize.width + GAP)*col, GAP + (cellSize.height + GAP)*row);
            CGRect availRect = (CGRect){availRectOrigin, cellSize};            
            CGRect letterRect = CGSizeFitIntoRect(letter.image.size, availRect);
            letter.frame = letterRect;
        }
    }

}

-(void)showNextLetter:(BOOL)isNext{
    int index = [letters indexOfObject:exposedLetter];
    isNext ? index++ : index--;
    LetterView *newExposed = [letters objectAtIndex:index];
    [exposedLetter beThumbnail];
    [newExposed beFullsized];
    [UIView animateWithDuration:animationDuration
                     animations:^(void){
                         [self deckLetter:exposedLetter];
                         exposedLetter = newExposed;
                         [self layoutExposedLetter];
                     }];    

}

-(void) layoutButtons{
    CGRect letterRect = [self exposedLetterRect];
    prevButton.center = CGPointMake(CGRectGetMinX(letterRect) - 10 - prevButton.bounds.size.width/2, CGRectGetMidY(letterRect));
    nextButton.center = CGPointMake(CGRectGetMaxX(letterRect) + 10 + nextButton.bounds.size.width/2, CGRectGetMidY(letterRect));
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
    [letters release];
    [nextButton release];
    [prevButton release];
    [super dealloc];
}

#pragma mark UIView

-(void)layoutSubviews{
    [super layoutSubviews];
    
    if(exposedLetter){
        [self layoutExposedLetter]; 
        [self deckOtherLetters];
    }else{
        [self layoutLetters];
    }
    
    [self layoutButtons];
}

#pragma mark actions

-(void)exposeLetter:(int)index uponCompletionDo:(void (^)())aBlock{
    exposedLetter = [letters objectAtIndex:index];
    [self bringSubviewToFront:exposedLetter];
    [exposedLetter beFullsized];
    [UIView animateWithDuration:animationDuration
                     animations:^(void){
                         [self layoutExposedLetter];
                         [self deckOtherLetters];
                         prevButton.hidden = NO;
                         prevButton.alpha = 0.5;
                         nextButton.hidden = NO;
                         nextButton.alpha = 0.5;
                     }
                     completion:^(BOOL finished){
                         if(aBlock) aBlock();
                         prevButton.userInteractionEnabled = YES;
                         nextButton.userInteractionEnabled = YES;
                     }
     ];    
}

-(void)unexpose{
    [exposedLetter beThumbnail];
    exposedLetter = nil;
    [UIView animateWithDuration:animationDuration
                     animations:^(void){
                         [self layoutLetters];
                         prevButton.alpha = 0.0;
                         nextButton.alpha = 0.0;                         
                         prevButton.userInteractionEnabled = NO;
                         nextButton.userInteractionEnabled = NO;
                     }
                     completion:^(BOOL finished){
                         prevButton.hidden = YES;
                         nextButton.hidden = YES;                         
                     }];

}

#pragma mark events

-(void)onTapped:(UIGestureRecognizer*)gr{
    UIView *v = gr.view;
    int letterIndex = [letters indexOfObject:v];
    [delegate tappedLetter:letterIndex view:v];
}

-(void)onPrevButton{
    if([self exposedLetterIndex] > 0) [self showNextLetter:NO];     
}

-(void)onNextButton{
    if([self exposedLetterIndex] < 32) [self showNextLetter:YES];
}


@end
