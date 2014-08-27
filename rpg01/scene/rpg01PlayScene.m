#import "rpg01PlayScene.h"
#import "rpg01HeroNode.h"
#import "rpg01SwordNode.h"
#import "rpg01BatNode.h"
#import "rpg01SlimeNode.h"
#import "rpg01CatNode.h"
#import "rpg01GhostNode.h"
#import "rpg01DragonNode.h"
#import "rpg01BigCatNode.h"
#import "rpg01SkeltonNode.h"
#import "rpg01GolemNode.h"
#import "rpg01DarkNode.h"
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
    int _fires;
    int _boxes;
    int _skelton;
    int _score;
    int _hp;
    int _MAXHP;
    int _mp;
    int _MAXMP;
    int _str;
    int _luck;
    int _int;
    NSString *_direction;
    NSString *_weaponType;
    BOOL _doorFlag;
    BOOL _clearFlag;
    double _base_height;
    BOOL _isWakeUp;
    int _fireDistance;

}

-(void)createSceneContents{
    _lastUpdateTimeInterval = 0;
    _timeSinceStart = 0;
    _timeSinceLastSecond = 0;
    _fires = 0;
    _skelton = 0;
    _boxes = 0;
    _score = [_params[@"gold"] intValue];
    _doorFlag = NO;
    _clearFlag = NO;
    _weaponType = @"sword";
    _base_height = self.size.height*0.2f;
    _direction = @"right";
    _onceFlag = NO;
    
    _hp = [_params[@"HP"] intValue];
    _MAXHP = [_params[@"HP"] intValue];
    _mp = [_params[@"MP"] intValue];
    _MAXMP = [_params[@"MP"] intValue];
    _str = [_params[@"str"] intValue];
    _luck = [_params[@"luck"] intValue];
    _int = [_params[@"int"] intValue];

    if([_params[@"cons"] isEqualToString:@"OK"]){
        _fireDistance = 300;
    } else {
        _fireDistance = 180;
    }
    
    if([_params[@"wakeUp"] isEqualToString:@"OK"]){
        _isWakeUp = YES;
    } else {
        _isWakeUp = NO;
    }
    
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.categoryBitMask = worldCategory;
    self.physicsBody.friction = 0.0;
    self.physicsWorld.contactDelegate = self;
    self.physicsWorld.gravity = CGVectorMake(0.0, -3.0);
    
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
    } else if([_params[@"story"] isEqualToString:@"b5"]){
        [self createB5Stage];
    } else if([_params[@"story"] isEqualToString:@"b6"]){
        [self createB5Stage];
    } else if([_params[@"story"] isEqualToString:@"b7"]){
        [self createB5Stage];
    } else if([_params[@"story"] isEqualToString:@"b8"]){
        _stageTime = 60.0f;
        [self createB5Stage];
    } else if([_params[@"story"] isEqualToString:@"final"]){
        [self createFinalStage];
    }
    
    [self displayHouseHPBar];
    [self addStatusFrame];
    [self addController:_base_height];
    
    if([_params[@"story"] isEqualToString:@"final"]){
        [self playBGM:@"final" type:@"mp3"];
    } else {
        [self playBGM:@"tekichi" type:@"wav"];
    }
}

- (void) displayHouseHPBar{
    CGRect rect = CGRectMake(CGRectGetMaxX(self.frame) - 40.0f, _base_height + 20.0f, 30.0f, _hp);
    SKSpriteNode *square = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:rect.size];
    square.position = rect.origin;
    square.name = @"houseHPBox";
    square.anchorPoint = CGPointMake(0, 0);
    [self addChild:square];
    
    rect = CGRectMake(CGRectGetMaxX(self.frame) - 40.0f, _base_height + 20.0f, 30.0f, _hp);
    square = [SKSpriteNode spriteNodeWithColor:[UIColor yellowColor] size:rect.size];
    square.position = rect.origin;
    square.name = @"houseHP";
    square.anchorPoint = CGPointMake(0, 0);
    [self addChild:square];
}

- (void)createB1Stage{
    _stageTime = 20.0f;
    rpg01MapNode *map = [[rpg01MapNode alloc] initWithMapNamed:@"b1" base_height:_base_height];
    [self addChild:map];
}

- (void)createB2Stage{
        _stageTime = 30.0f;
    rpg01MapNode *map = [[rpg01MapNode alloc] initWithMapNamed:@"b2" base_height:_base_height];
    [self addChild:map];
}

- (void)createB3Stage{
    _stageTime = 30.0f;
    rpg01MapNode *map = [[rpg01MapNode alloc] initWithMapNamed:@"b3" base_height:_base_height];
    [self addChild:map];
}

- (void)createB4Stage{
    _stageTime = 30.0f;
    rpg01MapNode *map = [[rpg01MapNode alloc] initWithMapNamed:@"b4" base_height:_base_height];
    [self addChild:map];
}

- (void)createB5Stage{
    _stageTime = 30.0f;
    rpg01MapNode *map = [[rpg01MapNode alloc] initWithMapNamed:@"b5" base_height:_base_height];
    [self addChild:map];
}

- (void)createFinalStage{
    _stageTime = 87.0f;
    rpg01MapNode *map = [[rpg01MapNode alloc] initWithMapNamed:@"final" base_height:_base_height];
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
        [self _moveHero:locaiton];
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
    SKAction *move = [SKAction moveTo:CGPointMake(locaiton.x, hero.position.y) duration:duration];
    [hero runAction:move completion:^{
        [hero stop];
    }];
}

// 敵を追加する
- (void)_addEnemySlime{
    rpg01SlimeNode *enemy = [rpg01SlimeNode slime];
    enemy.position = CGPointMake(skRand(TILE_SIZE * 0.5, 7.5*TILE_SIZE), CGRectGetMaxY(self.frame) - TILE_SIZE);
    [self addChild:enemy];
    [enemy slimeAnimation];
    [enemy moveSlime];
}

- (void)_addEnemyGreenSlime{
    rpg01SlimeNode *enemy = [rpg01SlimeNode greenSlime];
    enemy.position = CGPointMake(skRand(TILE_SIZE * 0.5, 7.5*TILE_SIZE), CGRectGetMaxY(self.frame) - TILE_SIZE);
    [self addChild:enemy];
    [enemy greenSlimeAnimation];
    [enemy moveSlime];
}

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

- (void)_addEnemyBigCat{
    rpg01BigCatNode *enemy = [rpg01BigCatNode bigCat];
    enemy.position = CGPointMake(skRand(100, self.frame.size.width - 105), CGRectGetMaxY(self.frame) - TILE_SIZE*2);
    [self addChild:enemy];
}

- (void)_addEnemyGolem{
    rpg01GolemNode *enemy = [rpg01GolemNode golem];
    enemy.position = CGPointMake(skRand(60, self.frame.size.width - 60), CGRectGetMaxY(self.frame) - TILE_SIZE*2);
    [self addChild:enemy];
}

- (void)_addEnemyDark{
    rpg01DarkNode *enemy = [rpg01DarkNode dark];
    enemy.position = CGPointMake(skRand(60, self.frame.size.width - 60), CGRectGetMaxY(self.frame) - TILE_SIZE*2);
    [self addChild:enemy];
}

- (void)_addEnemyGhost{
    rpg01GhostNode *enemy = [rpg01GhostNode ghost];
    enemy.position = CGPointMake(skRand(60, self.frame.size.width - 60), CGRectGetMaxY(self.frame) - TILE_SIZE*2);
    [self addChild:enemy];
}

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
    if(_isWakeUp){
        fire.xScale = fire.yScale = 0.5f;
        fire.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(45, 45)];
    } else {
        fire.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(42, 42)];
        fire.xScale = fire.yScale = 0.3f;
    }
    fire.physicsBody.affectedByGravity = NO;
    fire.physicsBody.categoryBitMask = swordCategory;
    fire.physicsBody.contactTestBitMask = enemyCategory;
    fire.physicsBody.collisionBitMask = 0;
    fire.physicsBody.usesPreciseCollisionDetection = YES;

    [self addChild:fire];

    CGPoint target;
    target = CGPointMake(from.x, from.y + _fireDistance);

    SKAction *move = [SKAction moveTo:target duration:1.0f];
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

    // 剣と敵の衝突判定
    if ((firstBody.categoryBitMask & swordCategory) != 0) {
        if ((secondBody.categoryBitMask & enemyCategory) != 0) {
            [self _attack:firstBody.node enemy:secondBody.node];
        }
    // 敵と家の衝突判定
    } else if ((firstBody.categoryBitMask & enemyCategory) != 0) {
        if ((secondBody.categoryBitMask & houseCategory) != 0) {
            [self burnHouse:firstBody.node house:secondBody.node];
        }
    }
}

- (void)burnHouse:(SKNode*)enemy house:(SKNode*)house{
    int damage = [enemy.userData[@"str"] intValue];
    _hp -= damage;
    [self _changeHP: -damage];
    
    if(_hp <= 0){
        [self stopBGM];
        [self loadScene:@"gameOver"];
    }
    SKSpriteNode *bar = (SKSpriteNode *)[self childNodeWithName:@"houseHP"];
    bar.size = CGSizeMake(30.0f, _hp);

    // 攻撃を与えたら消えるキャラ
    if([enemy.userData[@"kieru"] isEqualToString:@"OK"]){
        [enemy removeFromParent];
    }
    
    [self displayDamage:damage position:house.position color:[SKColor redColor]];
    
    // FIXME エフェクト
    // 出血を表示
    NSString *bloodPath = [[NSBundle mainBundle] pathForResource:@"blood" ofType:@"sks"];
    SKEmitterNode *blood = [NSKeyedUnarchiver unarchiveObjectWithFile:bloodPath];
    blood.position = house.position;
    blood.xScale = blood.yScale = 0.1f;
    [self addChild:blood];
    
    // 出血を消す
    SKAction *fadeOut = [SKAction fadeOutWithDuration:0.3f];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *sequence = [SKAction sequence:@[fadeOut, remove]];
    [blood runAction:sequence];
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
        if((enemy.physicsBody.categoryBitMask & metalBodyCategory) != 0){
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
    damageLabel.position = CGPointMake(position.x, position.y + TILE_SIZE + arc4random()%5);
    damageLabel.fontColor = color;
    [self addChild:damageLabel];
    
    SKAction *fadeOut = [SKAction fadeOutWithDuration:1.0f];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *sequence = [SKAction sequence:@[fadeOut, remove]];
    [damageLabel runAction:sequence];
}

// FIXME もっと観やすく
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
                } else if([_params[@"story"] isEqualToString:@"b5"]){
                    [self updateStage5];
                } else if([_params[@"story"] isEqualToString:@"b6"]){
                    [self updateStage6];
                } else if([_params[@"story"] isEqualToString:@"b7"]){
                    [self updateStage7];
                } else if([_params[@"story"] isEqualToString:@"b8"]){
                    [self updateStage8];
                } else if([_params[@"story"] isEqualToString:@"final"]){
                    [self updateSageFinal];
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
        } else if([enemy isEqualToString:@"bigCat"]){
            [self _addEnemyBigCat];
        } else if([enemy isEqualToString:@"golem"]){
            [self _addEnemyGolem];
        } else if([enemy isEqualToString:@"ghost"]){
            [self _addEnemyGhost];
        } else if([enemy isEqualToString:@"greenSlime"]){
            [self _addEnemyGreenSlime];
        } else if([enemy isEqualToString:@"dark"]){
            [self _addEnemyDark];
        }
    }
}

// ステージ設定
- (void)updateStage1{
    [self addEnemyTiming:@"slime" timing:2];
    [self addEnemyTiming:@"cat" timing:3];
    [self addEnemyTiming:@"bat" timing:4];
}

- (void)updateStage2{
    [self addEnemyTiming:@"slime" timing:3];
    [self addEnemyTiming:@"cat" timing:5];
    [self addEnemyTiming:@"bat" timing:6];
    [self addEnemyTiming:@"ghost" timing:7];
    if(_onceFlag == NO){
        [self _addEnemyGhost];
        _onceFlag = YES;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"今回の面はゴーストが登場しますね" message:@"奴は魔法以外の攻撃では１しかダメージを与えられないので注意であります！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"そんなの常識だぜ！", nil];
        alertView.tag = 1;
        [alertView show];
    }
}

- (void)updateStage3{
    [self addEnemyTiming:@"bat" timing:5];
    [self addEnemyTiming:@"cat" timing:7];
    [self addEnemyTiming:@"dragon" timing:15];
    if(_onceFlag == NO){
        [self _addEnemyDragon];
        _onceFlag = YES;
    }
}

- (void)updateStage4{
    [self addEnemyTiming:@"bat" timing:3];
    [self addEnemyTiming:@"skelton" timing:15];
    if(_onceFlag == NO){
        [self _addEnemySkelton];
        _onceFlag = YES;
    }
}

- (void)updateStage5{
    [self addEnemyTiming:@"ghost" timing:3];
    [self addEnemyTiming:@"bigCat" timing:15];
    if(_onceFlag == NO){
        [self _addEnemyBigCat];
        _onceFlag = YES;
    }
}

- (void)updateStage6{
    [self addEnemyTiming:@"bigCat" timing:7];
    [self addEnemyTiming:@"dragon" timing:5];
    [self addEnemyTiming:@"golem" timing:9];
    if(_onceFlag == NO){
        [self _addEnemyGolem];
        _onceFlag = YES;
    }
}

- (void)updateStage7{
    [self addEnemyTiming:@"greenSlime" timing:1];
    if(_onceFlag == NO){
        for(int i=0; i< 8; i++){
            [self _addEnemyGreenSlime];
        }
        _onceFlag = YES;
    }
}

- (void)updateStage8{
    if(_onceFlag == NO){
        [self _addEnemyDark];
        _onceFlag = YES;
    }
}

- (void)updateSageFinal{
    [self addEnemyTiming:@"greenSlime" timing:3];
//    [self addEnemyTiming:@"bat" timing:4];
//    [self addEnemyTiming:@"cat" timing:5];
    [self addEnemyTiming:@"ghost" timing:6];
    [self addEnemyTiming:@"skelton" timing:9];
    [self addEnemyTiming:@"golem" timing:11];
    [self addEnemyTiming:@"dragon" timing:16];
    [self addEnemyTiming:@"bigCat" timing:20];
    [self addEnemyTiming:@"dark" timing:50];
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
    [self stopBGM];
    _params[@"done"] = @"field";
    if([_params[@"story"] isEqualToString:@"b1"]){
        _params[@"story"] = @"b2";
    } else if([_params[@"story"] isEqualToString:@"b2"]){
        _params[@"story"] = @"b3";
    } else if([_params[@"story"] isEqualToString:@"b3"]){
        _params[@"story"] = @"b4";
    } else if([_params[@"story"] isEqualToString:@"b4"]){
        _params[@"story"] = @"b5";
    } else if([_params[@"story"] isEqualToString:@"b5"]){
        _params[@"story"] = @"b6";
    } else if([_params[@"story"] isEqualToString:@"b6"]){
        _params[@"story"] = @"b7";
    } else if([_params[@"story"] isEqualToString:@"b7"]){
        _params[@"story"] = @"b8";
    } else if([_params[@"story"] isEqualToString:@"final"]){
        // ending
    } else {
        NSLog(@"no story matched. story=%@", _params[@"story"]);
    }
    _params[@"gold"] = [NSString stringWithFormat:@"%d", _score];
    
    [self loadSceneToDone:_params];
}

@end
