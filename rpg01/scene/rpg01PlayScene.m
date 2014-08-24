#import "rpg01PlayScene.h"
#import "rpg01HeroNode.h"
#import "rpg01SwordNode.h"
#import "rpg01BatNode.h"
#import "rpg01SlimeNode.h"
#import "rpg01SkeltonNode.h"
#import "rpg01FireNode.h"
#import "rpg01DoorNode.h"

#import "rpg01MapNode.h"

static inline CGFloat skRandf() {
    return rand() / (CGFloat) RAND_MAX;
}
static inline CGFloat skRand(CGFloat low, CGFloat high) {
    return skRandf() * (high - low) + low;
}

const int FIRE_COST = 5;

@interface rpg01PlayScene () <SKPhysicsContactDelegate>
@end

@implementation rpg01PlayScene {
    BOOL _contentCreated;
    NSTimeInterval _lastUpdateTimeInterval;
    NSTimeInterval _timeSinceStart;
    NSTimeInterval _timeSinceLastSecond;
    int _enemies;
    int _fires;
    int _boxes;
    int _skelton;
    int _score;
    int _hp;
    int _MAXHP;
    int _mp;
    int _MAXMP;
    int _str;
    int _def;
    int _int;
    NSString *_direction;
    NSString *_weaponType;
    BOOL _doorFlag;
    BOOL _clearFlag;
    double _base_height;
}

-(void)createSceneContents{
    _lastUpdateTimeInterval = 0;
    _timeSinceStart = 0;
    _timeSinceLastSecond = 0;
    _enemies = 0;
    _fires = 0;
    _skelton = 0;
    _boxes = 0;
    _score = 0;
    _doorFlag = NO;
    _clearFlag = NO;
    _weaponType = @"sword";
    _base_height = self.size.height*0.2f;
    _direction = @"right";
    
    _hp = [_params[@"currentHP"] intValue];
    _MAXHP = [_params[@"HP"] intValue];
    _mp = [_params[@"MP"] intValue];
    _MAXMP = [_params[@"MP"] intValue];
    _str = [_params[@"str"] intValue];
    _def = [_params[@"def"] intValue];
    _int = [_params[@"int"] intValue];
    
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsWorld.contactDelegate = self;
    self.physicsBody.categoryBitMask = worldCategory;
    
    
    rpg01HeroNode *hero = [rpg01HeroNode hero];
    [self _addHero:CGPointMake(CGRectGetMidX(self.frame), _base_height + hero.size.height)];

    if([_params[@"story"] isEqualToString:@"b1"]){
        [self createB1Stage];
    } else if([_params[@"story"] isEqualToString:@"b2"]){
        [self createB2Stage];
    } else if([_params[@"story"] isEqualToString:@"b3"]){
        [self createB3Stage];
    } else if([_params[@"story"] isEqualToString:@"b4"]){
        [self createB4Stage];
    }
    
    [self addStatusFrame];
    [self addController:_base_height];
}

- (void)createB1Stage{
    rpg01MapNode *map = [[rpg01MapNode alloc] initWithMapNamed:@"b1" base_height:_base_height];
    [self addChild:map];
}

- (void)createB2Stage{
    rpg01MapNode *map = [[rpg01MapNode alloc] initWithMapNamed:@"b2" base_height:_base_height];
    [self addChild:map];
}

- (void)createB3Stage{
    rpg01MapNode *map = [[rpg01MapNode alloc] initWithMapNamed:@"b3" base_height:_base_height];
    [self addChild:map];
}

- (void)createB4Stage{
    rpg01MapNode *map = [[rpg01MapNode alloc] initWithMapNamed:@"b4" base_height:_base_height];
    [self addChild:map];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint locaiton = [touch locationInNode:self];
    SKNode *nodeAtPoint = [self nodeAtPoint:locaiton];

    if ([nodeAtPoint.name isEqualToString:@"attackButton" ]) {
        rpg01HeroNode *hero = (rpg01HeroNode *)[self childNodeWithName:HERO_NAME];
        _direction = @"up";
        [hero walkUp];
        [hero attack];
        [self _swordAttack:hero.position];
    } else if ([nodeAtPoint.name isEqualToString:@"fireButton" ]) {
        rpg01HeroNode *hero = (rpg01HeroNode *)[self childNodeWithName:HERO_NAME];
        _direction = @"up";
        [hero walkUp];
        [self _addFire:hero.position];
    } else if ([nodeAtPoint.name isEqualToString:@"controller" ]) {
        return;
    } else {
        if ([nodeAtPoint.name isEqualToString:HERO_NAME ]) {
/*
            rpg01HeroNode *hero = (rpg01HeroNode *)nodeAtPoint;
            [hero attack];
            [self _swordAttack:nodeAtPoint.position];
 */
        } else {
            [self _moveHero:locaiton];
        }
    }
}

-(void)_swordAttack:(CGPoint)position {
    rpg01SwordNode *sword = [rpg01SwordNode sword];
    if([_direction isEqualToString:@"down"]){
        sword.position = CGPointMake(position.x, position.y - TILE_SIZE);
    } else if([_direction isEqualToString:@"up"]){
        sword.position = CGPointMake(position.x, position.y + TILE_SIZE);
    } else if([_direction isEqualToString:@"right"]){
        sword.position = CGPointMake(position.x + TILE_SIZE, position.y);
    } else if([_direction isEqualToString:@"left"]){
        sword.position = CGPointMake(position.x - TILE_SIZE, position.y);
    }
    sword.name = @"sword";
    [self addChild:sword];
    
    sword.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(TILE_SIZE, TILE_SIZE)];
    sword.physicsBody.affectedByGravity = NO;
    sword.physicsBody.categoryBitMask = swordCategory;
    sword.physicsBody.contactTestBitMask = enemyCategory;
    sword.physicsBody.collisionBitMask = 0;
    
    [sword swordMove];
}

// 主人公を描画
- (void)_addHero:(CGPoint)position {
    rpg01HeroNode *hero = [rpg01HeroNode hero];
    hero.position = position;
    hero.name = HERO_NAME;
    hero.zPosition = 1.0f;
    [self addChild:hero];
}

// 主人公を動かす
- (void)_moveHero:(CGPoint)locaiton {
    rpg01HeroNode *hero = (rpg01HeroNode *)[self childNodeWithName:HERO_NAME];
    [hero removeAllActions];

    CGFloat x = locaiton.x;
    CGFloat y = locaiton.y;
    
    // MAXY
    if(y > CGRectGetMaxY(self.frame) - 30.0f){
        y = CGRectGetMaxY(self.frame)  - 30.0f;
    }
    
    CGFloat diff = abs(hero.position.x - x);
    CGFloat durationX = HERO_SPEED * diff / self.frame.size.width;
    diff = abs(hero.position.y - y);
    CGFloat durationY = HERO_SPEED * diff / self.frame.size.height;
    CGFloat duration;
    if(durationX >= durationY){
        duration = durationX;
        if(hero.position.x > locaiton.x){
            _direction = @"left";
            [hero walkLeft];
        } else {
            _direction = @"right";
            [hero walkRight];
        }
    } else {
        duration = durationY;
        if(hero.position.y > locaiton.y){
            _direction = @"down";
            [hero walkDown];
        } else {
            _direction = @"up";
            [hero walkUp];
        }
    }
    /*
    CGVector vector = CGVectorMake( (locaiton.x - hero.position.x)/30 , (locaiton.y - hero.position.y)/30);
    [hero.physicsBody applyImpulse:vector];
    */
    SKAction *move = [SKAction moveTo:CGPointMake(locaiton.x, hero.position.y) duration:duration];
    [hero runAction:move completion:^{
        [hero stop];
    }];
}

// 主人公に向かって動いて来る
- (void)_moveNode:(SKSpriteNode*)enemy target:(CGPoint)location duration:(CGFloat)duration completion:(void (^)(void))completion {
    SKAction *move = [SKAction moveTo:location duration:duration];
    [enemy runAction:move completion:completion];
}

// 敵を追加する
- (void)_addEnemySlime{
    _enemies++;
    rpg01SlimeNode *enemy = [rpg01SlimeNode slime];
    enemy.position = CGPointMake(skRand(40.0f, CGRectGetMaxX(self.frame) - 40.0f), CGRectGetMaxY(self.frame) - TILE_SIZE);
    enemy.name = ENEMY_NAME;
    [self addChild:enemy];
    [enemy slimeAnimation];
    [enemy moveSlime];
}

- (void)_addEnemyGreenSlime{
    _enemies++;
    rpg01SlimeNode *enemy = [rpg01SlimeNode greenSlime];
    enemy.position = CGPointMake(skRand(40.0f, CGRectGetMaxX(self.frame) - 40.0f), CGRectGetMaxY(self.frame) - TILE_SIZE);
    enemy.name = ENEMY_NAME;
    [self addChild:enemy];
    [enemy greenSlimeAnimation];
    [enemy moveSlime];
}

// コウモリを追加する
- (void)_addEnemyBat{
    rpg01BatNode *enemy = [rpg01BatNode bat];
    enemy.position = CGPointMake(skRand(40.0f, CGRectGetMaxX(self.frame) - 40.0f), CGRectGetMaxY(self.frame) - TILE_SIZE);
    enemy.name = ENEMY_BAT_NAME;
    [self addChild:enemy];
    [enemy fly];
}

- (void)_addEnemySkelton{
    rpg01SkeltonNode *enemy = [rpg01SkeltonNode skelton];
    enemy.position = CGPointMake(skRand(40.0f, CGRectGetMaxX(self.frame) - 40.0f), CGRectGetMaxY(self.frame) - TILE_SIZE);
    enemy.name = ENEMY_SKELTON_NAME;
    [self addChild:enemy];
    [enemy skeltonMove];
}

- (void)addWall:(CGRect)rect{
    SKSpriteNode *square = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:rect.size];
    square.position = rect.origin;
    square.name = @"wall";
    square.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rect.size];
    square.physicsBody.affectedByGravity = NO;
    square.physicsBody.allowsRotation = NO;
    square.physicsBody.dynamic = NO;
    square.physicsBody.categoryBitMask = worldCategory;
    square.physicsBody.contactTestBitMask = 0;
    square.physicsBody.collisionBitMask = heroCategory | enemyCategory;
    [self addChild:square];
}

- (void)_addFire:(CGPoint)from{

    if(_mp < FIRE_COST){
        return;
    }
    // 炎は三つまで　処理重いんだよね
    _fires++;
    if(_fires > 3){
        _fires = 3;
        return;
    }
    [self _changeMP: - FIRE_COST];
    
    rpg01FireNode *fire = [rpg01FireNode fire:from];
    [self addChild:fire];

    CGPoint target;
    if([_direction isEqualToString:@"up"]){
        target = CGPointMake(from.x, from.y + 180.0f);
    } else if ([_direction isEqualToString:@"down"]){
        target = CGPointMake(from.x, from.y - 180.0f);
    } else if ([_direction isEqualToString:@"right"]){
        target = CGPointMake(from.x + 180.0f, from.y);
    } else if ([_direction isEqualToString:@"left"]){
        target = CGPointMake(from.x - 180.0f, from.y);
    }
    SKAction *move = [SKAction moveTo:target duration:1.0f];
    
//    SKAction *move = [SKAction moveTo:target duration:3.0f];
    [fire runAction:move completion:^{
        SKAction *fadeOut = [SKAction fadeOutWithDuration:0.3f];
        SKAction *remove = [SKAction removeFromParent];
        SKAction *sequence = [SKAction sequence:@[fadeOut, remove]];
        [fire runAction:sequence];
        _fires--;
    }];
}

- (void)_score:(int)score {
    _score += score;
    SKLabelNode *scoreLabel = (SKLabelNode *)[self childNodeWithName:SCORE_NAME];
    scoreLabel.text = [NSString stringWithFormat:@"SCORE : %05d", _score];
}

- (void)_changeHP:(int)point {
    _hp += point;
    SKLabelNode *hpLabel = (SKLabelNode *)[self childNodeWithName:HP_NAME];
    hpLabel.text = [NSString stringWithFormat:@"HP : %03d / %03d", _hp, _MAXHP];
    if(_hp <= 0){
        [self _dead];
    }
}

- (void)_changeMP:(int)point {
    _mp += point;
    SKLabelNode *mpLabel = (SKLabelNode *)[self childNodeWithName:MP_NAME];
    if(_mp > _MAXMP){
        _mp = _MAXMP;
    }
    mpLabel.text = [NSString stringWithFormat:@"MP : %03d / %03d", _mp, _MAXMP];
}

# pragma mark - SKPhysicsContactDelegate
// 衝突判定
- (void)didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }

    if ((firstBody.categoryBitMask & heroCategory) != 0) {
        // 主人公と敵が当たった時
        if ((secondBody.categoryBitMask & enemyCategory) != 0) {
            [self _damaged:firstBody.node enemy:secondBody.node];
        // 壁と当たった時
        } else if ((secondBody.categoryBitMask & worldCategory) != 0) {
//            [firstBody.node removeAllActions];
        } else if ((secondBody.categoryBitMask & doorCategory) != 0) {
            _clearFlag = true;
            [self clearStage];
        }
        
    // 剣と敵の衝突判定
    } else if ((firstBody.categoryBitMask & swordCategory) != 0) {
        if ((secondBody.categoryBitMask & enemyCategory) != 0) {
            [self _attack:firstBody.node enemy:secondBody.node];
        }
    // 敵の衝突判定
    } else if ((firstBody.categoryBitMask & enemyCategory) != 0) {
        // 世界（壁）と衝突した時
        if ((secondBody.categoryBitMask & worldCategory) != 0) {

        // box と衝突した時
        } else if ((secondBody.categoryBitMask & boxCategory) != 0) {
//            [firstBody.node removeFromParent];
//            _enemies--;
//            [self _miss:secondBody.node];
        }
    }
}

- (void)_attack:(SKNode *)weapon enemy:(SKNode *)enemy {
    // MPを1回復
    [self _changeMP:1];
    
    // 火花を散らす
    NSString *sparkPath = [[NSBundle mainBundle] pathForResource:@"spark" ofType:@"sks"];
    SKEmitterNode *spark = [NSKeyedUnarchiver unarchiveObjectWithFile:sparkPath];
    spark.position = enemy.position;
    spark.xScale = spark.yScale = 0.3f;
    [self addChild:spark];

    // 火花を消す
    SKAction *fadeOut = [SKAction fadeOutWithDuration:0.3f];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *sequence = [SKAction sequence:@[fadeOut, remove]];
    [spark runAction:sequence];
    
    // 敵のHPを判定
    int life = [enemy.userData[@"life"] intValue] ;
    int damage;
    
    if ([weapon.userData[@"type"] isEqualToString:@"sword"]){
        damage = arc4random() % _str + 1;
        if(enemy.name == ENEMY_SKELTON_NAME){
            damage = 1;
        }
    } else {
        damage = _int;
    }
    if(damage <= 0){
        damage = 1;
    }
    [self displayDamage:damage position:enemy.position color:[SKColor blackColor]];

    life -= damage;

    if(life <= 0){
        int score = [enemy.userData[@"exp"] intValue];
        [enemy removeFromParent];
        _enemies--;
        [self _score:score];
    } else {
        enemy.userData[@"life"] = @(life);
        [self displayLife:life name:enemy.userData[@"name"]];
        
        if([_direction isEqualToString:@"right"]){
            [enemy.physicsBody applyImpulse:CGVectorMake([enemy.userData[@"attacked"] intValue], 0)];
        } else if([_direction isEqualToString:@"left"]){
            [enemy.physicsBody applyImpulse:CGVectorMake( - [enemy.userData[@"attacked"] intValue], 0)];
        } else if([_direction isEqualToString:@"up"]){
            [enemy.physicsBody applyImpulse:CGVectorMake( 0,[enemy.userData[@"attacked"] intValue])];
        } else if([_direction isEqualToString:@"down"]){
            [enemy.physicsBody applyImpulse:CGVectorMake( 0,- [enemy.userData[@"attacked"] intValue])];
        }
    }
}

- (void)displayDamage:(int)damage position:(CGPoint)position color:(SKColor*)color{
    SKLabelNode *damageLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    damageLabel.text = [NSString stringWithFormat:@"%d", damage];
    damageLabel.position = CGPointMake(position.x, position.y + TILE_SIZE);
    damageLabel.fontColor = color;
    [self addChild:damageLabel];
    
    SKAction *fadeOut = [SKAction fadeOutWithDuration:1.0f];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *sequence = [SKAction sequence:@[fadeOut, remove]];
    [damageLabel runAction:sequence];
}

- (void)displayLife:(int)life name:(NSString *)name{
    SKLabelNode *damageLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    damageLabel.text = [NSString stringWithFormat:@"%@　残りHP：%d", name, life];
    damageLabel.position = CGPointMake( 120.0f, CGRectGetMinY(self.frame) + 25.0f);
    damageLabel.fontColor = [SKColor blackColor];
    damageLabel.fontSize = 16.0f;
    [self addChild:damageLabel];
    
    SKAction *fadeOut = [SKAction fadeOutWithDuration:1.0f];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *sequence = [SKAction sequence:@[fadeOut, remove]];
    [damageLabel runAction:sequence];
}

// 敵からダメージを受けた時の処理
- (void)_damaged:(SKNode *)hero enemy:(SKNode *)enemy {
    // 出血を表示
    NSString *bloodPath = [[NSBundle mainBundle] pathForResource:@"blood" ofType:@"sks"];
    SKEmitterNode *blood = [NSKeyedUnarchiver unarchiveObjectWithFile:bloodPath];
    blood.position = hero.position;
    blood.xScale = blood.yScale = 0.1f;
    [self addChild:blood];
    
    // 出血を消す
    SKAction *fadeOut = [SKAction fadeOutWithDuration:0.3f];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *sequence = [SKAction sequence:@[fadeOut, remove]];
    [blood runAction:sequence];
    
    int damage = [enemy.userData[@"str"] intValue] - _def;
    if(damage <= 0){
        damage = 1;
    }
    [self displayDamage:damage position:hero.position color:[SKColor redColor]];
    [self _changeHP: -damage];
}

- (void)_dead {
    [self loadScene:@"gameOver"];
}

- (void)update:(NSTimeInterval)currentTime {    
    if(_clearFlag == NO){
        if (_lastUpdateTimeInterval > 0) {
            CFTimeInterval timeSinceLast = currentTime - _lastUpdateTimeInterval;
            _timeSinceStart += timeSinceLast;
            _timeSinceLastSecond += timeSinceLast;
            SKLabelNode *timeLabel = (SKLabelNode *)[self childNodeWithName:TIME_NAME];
            timeLabel.text = [NSString stringWithFormat:@"%07.1f", _timeSinceStart];
            
            if([_params[@"story"] isEqualToString:@"b1"]){
                [self updateStage1];
            } else if([_params[@"story"] isEqualToString:@"b2"]){
                [self updateStage2];
            } else if([_params[@"story"] isEqualToString:@"b3"]){
                [self updateStage3];
            } else if([_params[@"story"] isEqualToString:@"b4"]){
                [self updateStage4];
            } else {
                NSLog(@"no story matched. story=%@", _params[@"story"]);
            }
        }
        _lastUpdateTimeInterval = currentTime;
    }
}

- (void)updateStage1{
    if (_timeSinceLastSecond >= 1) {
        _timeSinceLastSecond = 0;
        int timing = 3;
        int max = 4;
        if ((int)_timeSinceStart % timing == 0) {
            if (_enemies < max) {
                [self _addEnemySlime];
            }
        }
    }
    if(_score >= 10){
        [self displayDoor];
    }
}

- (void)updateStage2{
    if (_timeSinceLastSecond >= 1) {
        _timeSinceLastSecond = 0;

        int timing = 3;
        int max = 5;
        if ((int)_timeSinceStart % timing == 0) {
            if (_enemies < max) {
                [self _addEnemySlime];
            }
        }
        timing = 4;
        if ((int)_timeSinceStart % timing == 0) {
            if (_enemies < max) {
                [self _addEnemyBat];
            }
        }
    }
    if(_score >= 20){
        [self displayDoor];
    }
}

- (void)updateStage3{
    if (_timeSinceLastSecond >= 1) {
        _timeSinceLastSecond = 0;
        
        if(_skelton ==0){
            [self _addEnemySkelton];
            _skelton ++;
        }
        int timing = 4;
        int max = 5;
        if ((int)_timeSinceStart % timing == 0) {
            if (_enemies < max) {
                [self _addEnemySlime];
            }
        }
        timing = 5;
        if ((int)_timeSinceStart % timing == 0) {
            if (_enemies < max) {
                [self _addEnemyBat];
            }
        }
    }
    if(_score >= 500){
        [self displayDoor];
    }
}

- (void)updateStage4{
    if (_timeSinceLastSecond >= 1) {
        _timeSinceLastSecond = 0;
        
        int timing = 3;
        int max = 5;
        if ((int)_timeSinceStart % timing == 0) {
            if (_enemies < max) {
                [self _addEnemySlime];
            }
        }
        timing = 7;
        if ((int)_timeSinceStart % timing == 0) {
            if (_enemies < max) {
                [self _addEnemyBat];
            }
        }
    }
    if(_score >= 100){
        [self displayDoor];
    }
}

- (void)displayDoor{
    if(_doorFlag == NO){
        rpg01DoorNode* door = [rpg01DoorNode door];
        door.position = CGPointMake(TILE_SIZE*2.5, self.frame.size.height - TILE_SIZE*3);
        [self addChild:door];
        _doorFlag = YES;
    }
}

- (void)clearStage{
    if([_params[@"story"] isEqualToString:@"b1"]){
        _params[@"done"] = @"title";
        _params[@"story"] = @"b2";
    } else if([_params[@"story"] isEqualToString:@"b2"]){
        _params[@"done"] = @"title";
        _params[@"story"] = @"b3";
    } else if([_params[@"story"] isEqualToString:@"b3"]){
        _params[@"done"] = @"story";
        _params[@"story"] = @"1-crear";
    } else {
        NSLog(@"no story matched. story=%@", _params[@"story"]);
    }

    _params[@"currentHP"] = [NSString stringWithFormat:@"%d", _hp];
    _params[@"gold"] = [NSString stringWithFormat:@"%d", [_params[@"gold"] intValue] + _score];
    [self loadSceneToDone:_params];
}

@end
