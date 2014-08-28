#import "rpg01CatNode.h"

@implementation rpg01CatNode

+ (id)cat{
    rpg01CatNode *node = [rpg01CatNode spriteNodeWithImageNamed:@"cat"];
    node.name = ENEMY_CAT_NAME;
    node.userData =  @{ @"name" : @"わるネコ",
                        @"life" : @(7),
                        @"exp" : @(5),
                        @"speed_dx" : @(0),
                        @"speed_dy" : @(-150.0f),
                        @"attacked" : @(3),
                        @"str" : @(3),
                        @"kieru" : @"OK"
                        }.mutableCopy;
    node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(TILE_SIZE, TILE_SIZE)];
    node.physicsBody.affectedByGravity = NO;
    node.physicsBody.allowsRotation = NO;
    node.physicsBody.categoryBitMask = enemyCategory;
    node.physicsBody.contactTestBitMask = heroCategory | swordCategory | houseCategory;
    node.physicsBody.collisionBitMask = worldCategory;
    
    // 敵のスピード
    int dx = [node.userData[@"speed_dx"] intValue];
    int dy = [node.userData[@"speed_dy"] intValue];
    node.physicsBody.velocity = CGVectorMake( dx, dy);
    
    return node;
}
@end
