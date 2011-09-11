#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>

@interface SoundEffect : NSObject {
    SystemSoundID _soundID;
}

+ (id)soundEffectWithContentsOfFile:(NSString *)aPath;
- (id)initWithContentsOfFile:(NSString *)path;
- (void)play;

+(SoundEffect*)selectBrushEffect;
+(SoundEffect*)eraseEffect;

@end
