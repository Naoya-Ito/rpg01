#import <SpriteKit/SpriteKit.h>
#import "rpg01Utilities.h"


@interface rpg01HeroNode : SKSpriteNode

+ (id)hero;
- (void)stop;
- (void)walkLeft;
- (void)walkRight;
- (void)walkUp;
- (void)walkDown;
- (void)attack;

@end
