#import "rpg01SkeltonNode.h"

const int SKELTON_IMAGE_NUM = 2;
@implementation rpg01SkeltonNode

+ (id)skelton {
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"skelton"];
    rpg01SkeltonNode *node = [rpg01SkeltonNode spriteNodeWithTexture:[atlas textureNamed:@"skelton0"]];
    node.name = ENEMY_SKELTON_NAME;
    node.userData =  @{ @"name" : @"メガデス",
                        @"life" : @(66),
                        @"exp" : @(40),
                        @"speed_dx" : @(160),
                        @"speed_dy" : @(0),
                        @"attacked" : @(1),
                        @"str" : @(5)
                        }.mutableCopy;
    node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(TILE_SIZE, TILE_SIZE*2)];
    node.physicsBody.affectedByGravity = YES;
    node.physicsBody.allowsRotation = NO;
    node.physicsBody.categoryBitMask = enemyCategory;
    node.physicsBody.contactTestBitMask = heroCategory | swordCategory| houseCategory;
    node.physicsBody.collisionBitMask = worldCategory | heroCategory;
    node.physicsBody.restitution = 1.0f;
    node.physicsBody.linearDamping = 0;
    node.physicsBody.friction = 0;
//    node.physicsBody.usesPreciseCollisionDetection = YES;
    
    // 敵のスピード
    int dx = [node.userData[@"speed_dx"] intValue];
    int dy = [node.userData[@"speed_dy"] intValue];
    node.physicsBody.velocity = CGVectorMake( dx, dy);
    
    return node;
}

- (NSMutableArray *)readTextures{
    NSMutableArray *textures = @[].mutableCopy;
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"skelton"];
    for( int i=0; i < SKELTON_IMAGE_NUM; i++){
        SKTexture *texture = [atlas textureNamed:[NSString stringWithFormat:@"skelton%d",i]];
        [textures addObject:texture];
    }
    return textures;
}

- (void)skeltonMove{
    SKAction *animate = [SKAction animateWithTextures:[self readTextures] timePerFrame:0.5f];
    SKAction *forever = [SKAction repeatActionForever:animate];
    [self runAction:forever];
}

@end
