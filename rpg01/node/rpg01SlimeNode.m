#import "rpg01SlimeNode.h"
const int SLIME_IMAGE_NUM = 2;

@implementation rpg01SlimeNode

+ (id)slime {
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"slime"];
    rpg01SlimeNode *node = [rpg01SlimeNode spriteNodeWithTexture:[atlas textureNamed:@"slime0"]];
    node.name = ENEMY_NAME;
    node.userData =  @{ @"name" : @"スライム",
                        @"life" : @(5),
                        @"exp" : @(2),
                        @"speed_dx" : @(0.0f),
                        @"speed_dy" : @(-120.0f),
                        @"attacked" : @(2),
                        @"str" : @(2)
                        }.mutableCopy;
    [node setPhysic];
    return node;
}

+ (id)greenSlime {
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"greenSlime"];
    rpg01SlimeNode *node = [rpg01SlimeNode spriteNodeWithTexture:[atlas textureNamed:@"greenSlime0"]];
    node.name = ENEMY_NAME;
    node.userData =  @{ @"name" : @"凶悪ピーマン",
                        @"life" : @(30),
                        @"exp" : @(30),
                        @"speed_dx" : @(20),
                        @"speed_dy" : @(-120.0f),
                        @"attacked" : @(2),
                        @"str" : @(4)
                        }.mutableCopy;
    [node setPhysic];
    return node;
}

- (void)setPhysic{
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(TILE_SIZE, TILE_SIZE)];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.allowsRotation = YES;
    self.physicsBody.categoryBitMask = enemyCategory | slimeCategory;
    self.physicsBody.contactTestBitMask = heroCategory | swordCategory;
    self.physicsBody.collisionBitMask = worldCategory | slimeCategory;
    self.physicsBody.restitution = 1.0f;
    self.physicsBody.linearDamping = 0;
    self.physicsBody.friction = 0;
    self.physicsBody.usesPreciseCollisionDetection = YES;
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

- (void)moveSlimeHolizon{
    int dx = [self.userData[@"speed_dx"] intValue];
    int dy = 0;
    self.physicsBody.velocity = CGVectorMake( dx, dy);
}

- (void)moveSlimeVertical{
    int dy = [self.userData[@"speed_dy"] intValue];
    self.physicsBody.velocity = CGVectorMake( 0, dy);
}

@end
