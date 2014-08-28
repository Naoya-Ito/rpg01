#import "rpg01GolemNode.h"

@implementation rpg01GolemNode

+ (id)golem{
    rpg01GolemNode *node = [rpg01GolemNode spriteNodeWithImageNamed:@"golem"];
    node.name = @"golem";
    node.userData =  @{ @"name" : @"ゴーレム",
                        @"life" : @(110),
                        @"exp" : @(80),
                        @"speed_dx" : @(0),
                        @"speed_dy" : @(-35.0f),
                        @"attacked" : @(0),
                        @"str" : @(15)
                        }.mutableCopy;
    node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(120, 120)];
    node.physicsBody.affectedByGravity = NO;
    node.physicsBody.allowsRotation = NO;
    node.physicsBody.categoryBitMask = enemyCategory | metalBodyCategory;
    node.physicsBody.contactTestBitMask = heroCategory | swordCategory | houseCategory;
    node.physicsBody.collisionBitMask = worldCategory;
    
    // 敵のスピード
    int dy = [node.userData[@"speed_dy"] intValue];
    node.physicsBody.velocity = CGVectorMake( 0, dy);
    
    return node;
}

@end
