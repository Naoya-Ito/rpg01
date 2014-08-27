#import "rpg01SlimeNode.h"
const int SLIME_IMAGE_NUM = 2;

@implementation rpg01SlimeNode

+ (id)slime {
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"slime"];
    rpg01SlimeNode *node = [rpg01SlimeNode spriteNodeWithTexture:[atlas textureNamed:@"slime0"]];
    node.name = ENEMY_NAME;
    node.userData =  @{ @"name" : @"スライム",
                        @"life" : @(1),
                        @"exp" : @(2),
                        @"speed_dx" : @(0.0f),
                        @"speed_dy" : @(-60.0f),
                        @"attacked" : @(2),
                        @"str" : @(1)
                        }.mutableCopy;
    [node setPhysic];
    return node;
}

+ (id)greenSlime {
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"greenSlime"];
    rpg01SlimeNode *node = [rpg01SlimeNode spriteNodeWithTexture:[atlas textureNamed:@"greenSlime0"]];
    node.name = ENEMY_NAME;
    node.userData =  @{ @"name" : @"凶悪ピーマン",
                        @"life" : @(10),
                        @"exp" : @(40),
                        @"speed_dx" : @(0),
                        @"speed_dy" : @(-70.0f),
                        @"attacked" : @(2),
                        @"str" : @(19),
                        @"kieru" : @"OK"
                        }.mutableCopy;
    [node setPhysic];
    return node;
}

- (void)setPhysic{
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(TILE_SIZE, TILE_SIZE)];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.allowsRotation = YES;
    self.physicsBody.categoryBitMask = enemyCategory;
    //self.physicsBody.categoryBitMask = enemyCategory | slimeCategory;
    self.physicsBody.contactTestBitMask = heroCategory | swordCategory | houseCategory;
//    self.physicsBody.collisionBitMask = worldCategory | slimeCategory | heroCategory;
    self.physicsBody.collisionBitMask = worldCategory;
    self.physicsBody.restitution = 0.0f;
    self.physicsBody.linearDamping = 0;
    self.physicsBody.friction = 0;
}

- (NSMutableArray *)readTextures:(NSString *)name{
    NSMutableArray *textures = @[].mutableCopy;
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:name];
    for( int i=0; i < SLIME_IMAGE_NUM; i++){
        SKTexture *texture = [atlas textureNamed:[NSString stringWithFormat:@"%@%d", name,i]];
        [textures addObject:texture];
    }
    return textures;
}

- (void)slimeAnimation{
    SKAction *animate = [SKAction animateWithTextures:[self readTextures:@"slime"] timePerFrame:0.5f];
    SKAction *forever = [SKAction repeatActionForever:animate];
    [self runAction:forever];
}

- (void)greenSlimeAnimation{
    SKAction *animate = [SKAction animateWithTextures:[self readTextures:@"greenSlime"] timePerFrame:0.5f];
    SKAction *forever = [SKAction repeatActionForever:animate];
    [self runAction:forever];
}

- (void)moveSlime{
    int dx = [self.userData[@"speed_dx"] intValue];
    int dy = [self.userData[@"speed_dy"] intValue];
    self.physicsBody.velocity = CGVectorMake( dx, dy);
}

@end
