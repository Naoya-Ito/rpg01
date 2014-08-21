#import <SpriteKit/SpriteKit.h>
#import "rpg01Utilities.h"

@interface rpg01BaseScene : SKScene{
    NSMutableDictionary *_params;
}

@property (nonatomic) BOOL contentCreated;
@property (nonatomic) NSDictionary *sceneData;

- (id)initWithSize:(CGSize)size name:(NSString *)name;
- (void)createSceneContents;
- (void)loadScene:(NSString *)name;
- (void)loadSceneWithParam:(NSString *)name params:(NSMutableDictionary *)params;
- (void)loadSceneToDone:(NSMutableDictionary *)params;
@end
