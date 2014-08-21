#import "rpg01SlimeNode.h"
const int SLIME_IMAGE_NUM = 2;

@implementation rpg01SlimeNode

+ (id)slime {
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"slime"];
    rpg01SlimeNode *node = [rpg01SlimeNode spriteNodeWithTexture:[atlas textureNamed:@"slime0"]];
    node.name = ENEMY_NAME;
    node.userData =  @{ @"name" : @"スライム",
                        @"life" : @(10),
                        @"exp" : @(2),
                        @"speed_dx" : @(0),
                        @"speed_dy" : @(-120.0f),
                        @"attacked" : @(2),
                        @"str" : @(2)
                        }.mutableCopy;
    node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(TILE_SIZE, TILE_SIZE)];
    node.physicsBody.affectedByGravity = NO;
    node.physicsBody.allowsRotation = YES;
    node.physicsBody.categoryBitMask = enemyCategory | slimeCategory;
    node.physicsBody.contactTestBitMask = heroCategory | swordCategory;
    node.physicsBody.collisionBitMask = worldCategory | slimeCategory;
    node.physicsBody.restitution = 1.0f;
    node.physicsBody.linearDamping = 0;
    node.physicsBody.friction = 0;
    node.physicsBody.usesPreciseCollisionDetection = YES;

    return node;
}

- (NSMutableArray *)readTextures{
    NSMutableArray *textures = @[].mutableCopy;
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"slime"];
    for( int i=0; i < SLIME_IMAGE_NUM; i++){
        SKTexture *texture = [atlas textureNamed:[NSString stringWithFormat:@"slime%d",i]];
        [textures addObject:texture];
    }
    return textures;
}

- (void)slimeAnimation{
    SKAction *animate = [SKAction animateWithTextures:[self readTextures] timePerFrame:0.5f];
    SKAction *forever = [SKAction repeatActionForever:animate];
    [self runAction:forever];
}

- (void)moveSlime{
    int dx = [self.userData[@"speed_dx"] intValue];
    int dy = [self.userData[@"speed_dy"] intValue];
    self.physicsBody.velocity = CGVectorMake( dx, dy);
}

@end
