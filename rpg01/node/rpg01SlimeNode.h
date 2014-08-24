#import <SpriteKit/SpriteKit.h>
#import "rpg01Utilities.h"

@interface rpg01SlimeNode : SKSpriteNode
+ (id)slime;
+ (id)greenSlime;
- (void)slimeAnimation;
- (void)moveSlime;
- (void)greenSlimeAnimation;

@end