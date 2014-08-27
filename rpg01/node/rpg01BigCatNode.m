#import "rpg01BigCatNode.h"

@implementation rpg01BigCatNode

+ (id)bigCat{
    rpg01BigCatNode *node = [rpg01BigCatNode spriteNodeWithImageNamed:@"bigCat"];
    node.name = @"bigCat";
    node.userData =  @{ @"name" : @"巨大ネコ",
                        @"life" : @(150),
                        @"exp" : @(40),
                        @"speed_dx" : @(0),
                        @"speed_dy" : @(-35.0f),
                        @"attacked" : @(10),
                        @"str" : @(5),
                        }.mutableCopy;
    node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(205, 190)];
    node.physicsBody.affectedByGravity = YES;
    node.physicsBody.allowsRotation = NO;
    node.physicsBody.categoryBitMask = enemyCategory;
    node.physicsBody.contactTestBitMask = heroCategory | swordCategory | houseCategory;
    node.physicsBody.collisionBitMask = worldCategory | heroCategory;
    node.physicsBody.restitution = 1.0f;
    node.physicsBody.linearDamping = 0;
    node.physicsBody.friction = 0;
    
    return node;
}
@end
