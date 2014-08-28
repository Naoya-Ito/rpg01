#import "rpg01HeroNode.h"

const CGFloat HERO_HEIGHT = 45.0f;
const CGFloat HERO_WEIGHT = 32.0f;

const CGFloat HERO_IMAGE_NUM = 1;

@implementation rpg01HeroNode

+ (id)hero {
    rpg01HeroNode *hero = [rpg01HeroNode spriteNodeWithImageNamed:@"heroRight0"];
    hero.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(HERO_WEIGHT - 3, HERO_HEIGHT -1)];
    //hero.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(TILE_SIZE, TILE_SIZE)];
    hero.physicsBody.affectedByGravity = NO;
    hero.physicsBody.categoryBitMask = heroCategory;
    hero.physicsBody.contactTestBitMask = enemyCategory | worldCategory | doorCategory;
    hero.physicsBody.collisionBitMask = worldCategory;
    hero.physicsBody.allowsRotation = NO;
    return hero;
}

- (id)initWithTexture:(SKTexture *)texture color:(UIColor *)color size:(CGSize)size {
    if (self = [super initWithTexture:texture color:color size:size]) {
        [self stop];
    }
    return self;
}

- (NSMutableArray *)readTextures:(NSString *)name{
    NSMutableArray *textures = @[].mutableCopy;
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"hero"];
    for( int i=0; i < HERO_IMAGE_NUM; i++){
        SKTexture *texture = [atlas textureNamed:[NSString stringWithFormat:@"%@%d", name, i]];
        [textures addObject:texture];
    }
    return textures;
}

- (void)heroMoveRight{
    SKAction *animate = [SKAction animateWithTextures:[self readTextures:@"heroRight"] timePerFrame:0.1f];
    SKAction *forever = [SKAction repeatActionForever:animate];
    [self runAction:forever];
}

- (void)heroMoveLeft{
    SKAction *animate = [SKAction animateWithTextures:[self readTextures:@"heroLeft"] timePerFrame:0.1f];
    SKAction *forever = [SKAction repeatActionForever:animate];
    [self runAction:forever];
}


- (void)stop {
    [self removeAllActions];
}

- (void)walkRight {
    SKAction *animate = [SKAction animateWithTextures:[self readTextures:@"heroRight"] timePerFrame:0.5f];
    SKAction *forever = [SKAction repeatActionForever:animate];
    [self runAction:forever];
}

- (void)walkLeft {
    SKAction *animate = [SKAction animateWithTextures:[self readTextures:@"heroLeft"] timePerFrame:0.5f];
    SKAction *forever = [SKAction repeatActionForever:animate];
    [self runAction:forever];
}

- (void)walkUp {
    SKAction *animate = [SKAction animateWithTextures:[self readTextures:@"heroUp"] timePerFrame:0.5f];
    SKAction *forever = [SKAction repeatActionForever:animate];
    [self runAction:forever];
}

- (void)walkDown {
    SKAction *animate = [SKAction animateWithTextures:[self readTextures:@"heroDown"] timePerFrame:0.5f];
    SKAction *forever = [SKAction repeatActionForever:animate];
    [self runAction:forever];
}

// 攻撃アクション
- (void)attack{
    NSMutableArray *textures = @[].mutableCopy;
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"hero"];
    for( int i=0; i < 2; i++){
        SKTexture *texture = [atlas textureNamed:[NSString stringWithFormat:@"%@%d", @"heroAttack", i]];
        [textures addObject:texture];
    }
    SKAction *animate = [SKAction animateWithTextures:textures timePerFrame:0.1f];
    SKAction *forever = [SKAction repeatAction:animate count:3];
    
    [self runAction:forever];
}

@end
