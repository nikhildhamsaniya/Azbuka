#import "LettersNavigatorView.h"
#import "Azbuka.h"

@implementation LettersNavigatorView

const float GAP = 5;

#pragma mark private

-(UIView*)hiliter{
    if(!hiliter){
        hiliter = [[UIView alloc] initWithFrame:CGRectZero];
        hiliter.backgroundColor = [UIColor whiteColor];
        hiliter.alpha = 0.7;        
    }
    
    return hiliter;
}

-(void)hiliteLetter:(int)index{
    [self.hiliter removeFromSuperview];
    
    for(int i = 0; i < self.subviews.count; i++){
        UIImageView *letterView = [self.subviews objectAtIndex:i];
        if(i == index){
            hiliter.frame = letterView.bounds;
            [letterView addSubview:self.hiliter];
            [letterView bringSubviewToFront:self.hiliter];
        }
    }
}

-(void)privateInit{
    for(int i = 1; i <= 33; i++){
        NSString *imageName = [NSString stringWithFormat:@"%d.JPG", i];
        UIImage *image = [UIImage imageNamed:imageName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gr = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onLetterTapped:)] autorelease];
        [imageView addGestureRecognizer:gr];
        [self addSubview:imageView];
    }
    
    [azbuka addObserver:self
              forKeyPath:@"selectedLetterIndex"
                 options:(NSKeyValueObservingOptionNew |
                          NSKeyValueObservingOptionOld)
                 context:NULL];
}

-(void)layoutPortrait{
    float xFreeSpace = self.bounds.size.width - (11 + 1) * GAP;
    float width = xFreeSpace / 11.0;
    float height = width / 3.0 * 4.0;
    
    for(int row = 0; row < 3; row++){
        for(int col = 0; col < 11; col++){
            int index = row * 11 + col;
            UIImageView * letter = [self.subviews objectAtIndex:index];
            letter.frame = CGRectMake(GAP + (float)col * (width + GAP), GAP + (float)row * (height + GAP), width, height);
        }
    }
}

-(void)layoutLandscape{
    float yFreeSpace = self.bounds.size.height - (11 + 1) * GAP;
    float height = yFreeSpace / 11.0;
    float width = height / 4.0 * 3.0;
    
    for(int col = 0; col < 3; col++){
        for(int row = 0; row < 11; row++){
            int index = row * 3 + col;
            UIImageView * letter = [self.subviews objectAtIndex:index];
            letter.frame = CGRectMake(GAP + (float)col * (width + GAP), GAP + (float)row * (height + GAP), width, height);
        }
    }    
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
    [hiliter release];
    
    [azbuka removeObserver:self forKeyPath:@"selectedLetterIndex"];
    [azbuka release];
     
    [super dealloc];
}

#pragma mark UIView

-(void)layoutSubviews{
   if(self.bounds.size.width > self.bounds.size.height)
       [self layoutPortrait];
    else
        [self layoutLandscape];
    
    // for hilite view layouting
    [self hiliteLetter:azbuka.selectedLetterIndex];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqual:@"selectedLetterIndex"]) {
        [self hiliteLetter:azbuka.selectedLetterIndex];
    }
}

#pragma mark event handling

-(void)onLetterTapped:(UIGestureRecognizer*)gr{
    azbuka.selectedLetterIndex = [self.subviews indexOfObject:gr.view];
}

@end
