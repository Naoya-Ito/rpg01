#import "rpg01PlayScene.h"
#import "rpg01HeroNode.h"
#import "rpg01SwordNode.h"
#import "rpg01BatNode.h"
#import "rpg01SlimeNode.h"
#import "rpg01CatNode.h"
#import "rpg01DragonNode.h"
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
    BOOL _onceFlag;
    NSTimeInterval _lastUpdateTimeInterval;
    NSTimeInterval _timeSinceStart;
    NSTimeInterval _timeSinceLastSecond;
    NSTimeInterval _stageTime;
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
    int _houseHP;
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
    _stageTime = 20.0f;
    _houseHP = 200;
    _onceFlag = NO;
    
    _hp = [_params[@"currentHP"] intValue];
    _MAXHP = [_params[@"HP"] intValue];
    _mp = [_params[@"MP"] intValue];
    _MAXMP = [_params[@"MP"] intValue];
    _str = [_params[@"str"] intValue];
    _def = [_params[@"def"] intValue];
    _int = [_params[@"int"] intValue];
    
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsWorld.contactDelegate = self;
    self.physicsWorld.gravity = CGVectorMake(0.0, -3.0);
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
    
    [self displayHouseHPBar];
    [self addStatusFrame];
    [self addController:_base_height];
    
    [self playBGM:@"tekichi" type:@"wav"];
}

- (void) displayHouseHPBar{
    
    CGRect rect = CGRectMake(CGRectGetMaxX(self.frame) - 40.0f, _base_height + 20.0f, 30.0f, 200.0f);
    SKSpriteNode *square = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:rect.size];
    square.position = rect.origin;
    square.name = @"houseHPBox";
    square.anchorPoint = CGPointMake(0, 0);
    [self addChild:square];
    
    rect = CGRectMake(CGRectGetMaxX(self.frame) - 40.0f, _base_height + 20.0f, 30.0f, 200.0f);
    square = [SKSpriteNode spriteNodeWithColor:[UIColor yellowColor] size:rect.size];
    square.position = rect.origin;
    square.name = @"houseHP";
    square.anchorPoint = CGPointMake(0, 0);
    [self addChild:square];
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
    enemy.position = CGPointMake(skRand(TILE_SIZE * 0.5, 7.5*TILE_SIZE), CGRectGetMaxY(self.frame) - TILE_SIZE);
    enemy.name = ENEMY_NAME;
    [self addChild:enemy];
    [enemy slimeAnimation];
    [enemy moveSlime];
}

- (void)_addEnemyGreenSlime{
    _enemies++;
    rpg01SlimeNode *enemy = [rpg01SlimeNode greenSlime];
    enemy.position = CGPointMake(skRand(TILE_SIZE * 0.5, 7.5*TILE_SIZE), CGRectGetMaxY(self.frame) - TILE_SIZE);
    [self addChild:enemy];
    [enemy greenSlimeAnimation];
    [enemy moveSlime];
}

// ネコを追加する
- (void)_addEnemyCat{
    rpg01CatNode *enemy = [rpg01CatNode cat];
    enemy.position = CGPointMake(skRand(TILE_SIZE * 0.5, 7.5*TILE_SIZE), CGRectGetMaxY(self.frame) - TILE_SIZE);
    [self addChild:enemy];
}

- (void)_addEnemyDragon{
    rpg01DragonNode *enemy = [rpg01DragonNode dragon];
    enemy.position = CGPointMake(skRand(TILE_SIZE * 1.5, 6.5*TILE_SIZE), CGRectGetMaxY(self.frame) - TILE_SIZE*2);
    [self addChild:enemy];
}

// コウモリを追加する
- (void)_addEnemyBat{
    rpg01BatNode *enemy = [rpg01BatNode bat];
    enemy.position = CGPointMake(skRand(TILE_SIZE * 0.5, 7.5*TILE_SIZE), CGRectGetMaxY(self.frame) - TILE_SIZE);
    [self addChild:enemy];
    [enemy fly];
}

- (void)_addEnemySkelton{
    rpg01SkeltonNode *enemy = [rpg01SkeltonNode skelton];
    enemy.position = CGPointMake(skRand(TILE_SIZE * 0.5, 7.5*TILE_SIZE), CGRectGetMaxY(self.frame) - TILE_SIZE);
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
    scoreLabel.text = [NSString stringWithFormat:@"GOLD : %05d", _score];
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
/*
        } else if ((secondBody.categoryBitMask & doorCategory) != 0) {
            _clearFlag = true;
            [self clearStage];
*/
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

        // houseと衝突した時
        } else if ((secondBody.categoryBitMask & houseCategory) != 0) {
            [self burnHouse:firstBody.node house:secondBody.node];
        }
    }
}

- (void)burnHouse:(SKNode*)enemy house:(SKNode*)house{
    int damage = [enemy.userData[@"str"] intValue];
    _houseHP -= damage;
    
    if(_houseHP <= 0){
        [self loadScene:@"gameOver"];
    }
    SKSpriteNode *bar = (SKSpriteNode *)[self childNodeWithName:@"houseHP"];
    bar.size = CGSizeMake(30.0f, _houseHP);

    [self displayDamage:damage position:house.position color:[SKColor redColor]];
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

        [enemy.physicsBody applyImpulse:CGVectorMake( 0,[enemy.userData[@"attacked"] intValue])];
    }
}

- (void)displayDamage:(int)damage position:(CGPoint)position color:(SKColor*)color{
    SKLabelNode *damageLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    damageLabel.text = [NSString stringWithFormat:@"%d", damage];
    damageLabel.name = @"damage";
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
    [self displayDamage:damage position:hero.position color:[SKColor blueColor]];
    [self _changeHP: -damage];
}

- (void)_dead {
    // ５秒後に復活
    
    //[self loadScene:@"gameOver"];
}

- (void)update:(NSTimeInterval)currentTime {    
    if(_clearFlag == NO){
        if (_lastUpdateTimeInterval > 0) {
            CFTimeInterval timeSinceLast = currentTime - _lastUpdateTimeInterval;
            _timeSinceStart += timeSinceLast;
            _timeSinceLastSecond += timeSinceLast;
            SKLabelNode *timeLabel = (SKLabelNode *)[self childNodeWithName:TIME_NAME];
            timeLabel.text = [NSString stringWithFormat:@"%07.1f", _stageTime - _timeSinceStart];
            
            if (_timeSinceLastSecond >= 1) {
                _timeSinceLastSecond = 0;
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
            if(_stageTime <= _timeSinceStart && _clearFlag == NO){
                _clearFlag = YES;
                [self clearStage];
            }
        }
        _lastUpdateTimeInterval = currentTime;
    }
}

// timing秒毎にモンスターを出現
- (void)addEnemyTiming:(NSString*)enemy timing:(int)timing{
    if((int)_timeSinceStart % timing == 0){
        if([enemy isEqualToString:@"slime"]){
            [self _addEnemySlime];
        } else if([enemy isEqualToString:@"cat"]){
            [self _addEnemyCat];
        } else if([enemy isEqualToString:@"bat"]){
            [self _addEnemyBat];
        } else if([enemy isEqualToString:@"skelton"]){
            [self _addEnemySkelton];
        } else if([enemy isEqualToString:@"dragon"]){
            [self _addEnemyDragon];
        }
    }
}

// ステージ設定
- (void)updateStage1{
    [self addEnemyTiming:@"slime" timing:2];
    [self addEnemyTiming:@"cat" timing:3];
}

- (void)updateStage2{
    [self addEnemyTiming:@"slime" timing:3];
    [self addEnemyTiming:@"cat" timing:5];
    [self addEnemyTiming:@"bat" timing:4];
    [self addEnemyTiming:@"dragon" timing:15];
    if(_onceFlag == NO){
        [self _addEnemyDragon];
        _onceFlag = YES;
    }
}

- (void)updateStage3{
    [self addEnemyTiming:@"slime" timing:3];
    [self addEnemyTiming:@"bat" timing:5];
    if(_onceFlag == NO){
        [self _addEnemySkelton];
        _onceFlag = YES;
    }
}

- (void)updateStage4{
    [self addEnemyTiming:@"slime" timing:1];
    [self addEnemyTiming:@"bat" timing:3];
    [self addEnemyTiming:@"skelton" timing:15];
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
