#import <SpriteKit/SpriteKit.h>
#import "rpg01Utilities.h"
#import <AVFoundation/AVFoundation.h>

@interface rpg01BaseScene : SKScene{
    NSMutableDictionary *_params;
    AVAudioPlayer *_audioPlayer;
    BOOL _isBGMPlaying;
}

@property (nonatomic) BOOL contentCreated;
@property (nonatomic) NSDictionary *sceneData;

- (id)initWithSize:(CGSize)size name:(NSString *)name;
- (void)createSceneContents;
- (void)loadScene:(NSString *)name;
- (void)loadSceneWithParam:(NSString *)name params:(NSMutableDictionary *)params;
- (void)loadSceneToDone:(NSMutableDictionary *)params;
- (void)addStatusFrame;
- (void)addController:(CGFloat)_base_height;
- (void)makeButton:(CGPoint)point name:(NSString *)name text:(NSString*)text;
- (void)makeButtonWithSize:(CGPoint)point name:(NSString *)name text:(NSString*)text size:(CGSize)size;
- (void)playBGM:(NSString*)name type:(NSString *)type;
- (void)stopBGM;
- (void)outputGold;
@end
