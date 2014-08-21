#import <SpriteKit/SpriteKit.h>
#import "rpg01Utilities.h"


typedef enum : uint8_t {
    rpg01HeroStateStop = 0,
    rpg01HeroStateWalk,
    rpg01HeroStateAttack
} rpg01HeroState;

@interface rpg01HeroNode : SKSpriteNode

@property (nonatomic) rpg01HeroState state;
+ (id)hero;
- (void)stop;
- (void)walkLeft;
- (void)walkRight;
- (void)walkUp;
- (void)walkDown;
- (void)attack;

@end
