#import "rpg01DarkNode.h"

@implementation rpg01DarkNode
+ (id)dark{
    rpg01DarkNode *node = [rpg01DarkNode spriteNodeWithImageNamed:@"darkHeroDown0"];
    node.name = @"golem";
    node.userData =  @{ @"name" : @"シャドー",
                        @"life" : @(210),
                        @"exp" : @(999),
                        @"speed_dx" : @(210),
                        @"speed_dy" : @(0),
                        @"attacked" : @(0),
                        @"str" : @(9)
                        }.mutableCopy;

    node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(45, 32)];
    node.physicsBody.affectedByGravity = YES;
    node.physicsBody.allowsRotation = NO;
    node.physicsBody.categoryBitMask = enemyCategory | metalBodyCategory;
    node.physicsBody.contactTestBitMask = heroCategory | swordCategory| houseCategory;
    node.physicsBody.collisionBitMask = worldCategory | heroCategory;
    node.physicsBody.restitution = 1.0f;
    node.physicsBody.linearDamping = 0;
    node.physicsBody.friction = 0;
    
    // 敵のスピード
    int dx = [node.userData[@"speed_dx"] intValue];
    node.physicsBody.velocity = CGVectorMake( dx, 0);
    
    return node;
}

@end
