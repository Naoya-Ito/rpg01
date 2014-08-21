#import <SpriteKit/SpriteKit.h>
#import "rpg01Utilities.h"

@interface rpg01FireNode : SKEmitterNode
+ (id)fire:(CGPoint)from;
- (SKAction *)fireShot:(CGPoint)from direction:(NSString *)direction;
@end