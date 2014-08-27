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
//    SKAction *forever = [SKAction repeatAction:animate count:1];
    [self runAction:forever];
}

- (void)heroMoveLeft{
    SKAction *animate = [SKAction animateWithTextures:[self readTextures:@"heroLeft"] timePerFrame:0.1f];
    SKAction *forever = [SKAction repeatActionForever:animate];
    //    SKAction *forever = [SKAction repeatAction:animate count:1];
    [self runAction:forever];
}


- (void)stop {
    [self removeAllActions];
    self.state = rpg01HeroStateStop;
}

- (void)walkRight {
    SKAction *animate = [SKAction animateWithTextures:[self readTextures:@"heroRight"] timePerFrame:0.5f];
    SKAction *forever = [SKAction repeatActionForever:animate];
    [self runAction:forever];
    self.state = rpg01HeroStateWalk;
}

- (void)walkLeft {
    SKAction *animate = [SKAction animateWithTextures:[self readTextures:@"heroLeft"] timePerFrame:0.5f];
    SKAction *forever = [SKAction repeatActionForever:animate];
    [self runAction:forever];
    self.state = rpg01HeroStateWalk;
}

- (void)walkUp {
    SKAction *animate = [SKAction animateWithTextures:[self readTextures:@"heroUp"] timePerFrame:0.5f];
    SKAction *forever = [SKAction repeatActionForever:animate];
    [self runAction:forever];
    self.state = rpg01HeroStateWalk;
}

- (void)walkDown {
    SKAction *animate = [SKAction animateWithTextures:[self readTextures:@"heroDown"] timePerFrame:0.5f];
    SKAction *forever = [SKAction repeatActionForever:animate];
    [self runAction:forever];
    self.state = rpg01HeroStateWalk;
}

// 攻撃アクション
- (void)attack{
//    [self catMove];
/*
    [self _animate:@"clotharmor" withRow:5 cols:5 time:0.05f completion:^{
        self.state = rpg01HeroStateStop;
    }];
 */
    self.state = rpg01HeroStateAttack;
}

@end
