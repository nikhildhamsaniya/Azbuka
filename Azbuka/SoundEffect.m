#import "SoundEffect.h"

static SoundEffect *_selectBrushEffect;
static SoundEffect *_eraseEffect;

@implementation SoundEffect



//NSBundle *mainBundle = [NSBundle mainBundle];	
//erasingSound = [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"Erase" ofType:@"caf"]];
//selectSound =  [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"Select" ofType:@"caf"]];


// Creates a sound effect object from the specified sound file
+ (id)soundEffectWithContentsOfFile:(NSString *)aPath {
    if (aPath) {
        return [[[SoundEffect alloc] initWithContentsOfFile:aPath] autorelease];
    }
    return nil;
}

// Initializes a sound effect object with the contents of the specified sound file
- (id)initWithContentsOfFile:(NSString *)path {
    self = [super init];
    
	// Gets the file located at the specified path.
    if (self != nil) {
        NSURL *aFileURL = [NSURL fileURLWithPath:path isDirectory:NO];
        
		// If the file exists, calls Core Audio to create a system sound ID.
        if (aFileURL != nil)  {
            SystemSoundID aSoundID;
            OSStatus error = AudioServicesCreateSystemSoundID((CFURLRef)aFileURL, &aSoundID);
            
            if (error == kAudioServicesNoError) { // success
                _soundID = aSoundID;
            } else {
                NSLog(@"Error %ld loading sound at path: %@", error, path);
                [self release], self = nil;
            }
        } else {
            NSLog(@"NSURL is nil for path: %@", path);
            [self release], self = nil;
        }
    }
    return self;
}

// Releases resouces when no longer needed.
-(void)dealloc {
    AudioServicesDisposeSystemSoundID(_soundID);
    [super dealloc];
}

// Plays the sound associated with a sound effect object.
-(void)play {
	// Calls Core Audio to play the sound for the specified sound ID.
    AudioServicesPlaySystemSound(_soundID);
}

+(SoundEffect*)selectBrushEffect{
    if(!_selectBrushEffect){
      NSBundle *mainBundle = [NSBundle mainBundle];	
      _selectBrushEffect =  [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"Select" ofType:@"caf"]];  
    }
    return _selectBrushEffect;
}

+(SoundEffect*)eraseEffect{
    if(!_eraseEffect){
        NSBundle *mainBundle = [NSBundle mainBundle];	
        _eraseEffect =  [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"Erase" ofType:@"caf"]];  
    }
    return _eraseEffect;    
}



@end
