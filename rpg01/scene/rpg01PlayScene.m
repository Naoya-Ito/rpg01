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
#import "rpg01MapNode.h"

static inline CGFloat skRandf() {
    return rand() / (CGFloat) RAND_MAX;
}
static inline CGFloat skRand(CGFloat low, CGFloat high) {
    return skRandf() * (high - low) + low;
}


@interface rpg01PlayScene () <SKPhysicsContactDelegate>
@end

@implementation rpg01PlayScene {
    BOOL _onceFlag;
    NSTimeInterval _lastUpdateTimeInterval;
    NSTimeInterval _timeSinceStart;
    NSTimeInterval _timeSinceLastSecond;
    NSTimeInterval _stageTime;
    int _fires;
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
    BOOL _clearFlag;
    double _base_height;
    BOOL _displayedLife;
    int _story;
    int _fireDistance;
    BOOL _canMagic;
    BOOL _isWakeUp;
    BOOL _isMidare;
    BOOL _isSpeed;
    BOOL _isBlue;
    BOOL _isBrave;
    int _fireCost;
}

-(void)createSceneContents{
    _lastUpdateTimeInterval = 0;
    _timeSinceStart = 0;
    _timeSinceLastSecond = 0;
    _fires = 0;
    _score = [_params[@"gold"] intValue];
    _clearFlag = NO;
    _weaponType = @"sword";
    _base_height = self.size.height*0.2f;
    _direction = @"right";
    _onceFlag = NO;
    _displayedLife = NO;
    _canMagic = YES;
    
    _hp = [_params[@"HP"] intValue];
    _MAXHP = [_params[@"HP"] intValue];
    _mp = [_params[@"MP"] intValue];
    _MAXMP = [_params[@"MP"] intValue];
    _str = [_params[@"str"] intValue];
    _luck = [_params[@"luck"] intValue];
    _int = [_params[@"int"] intValue];
    _story = [_params[@"story"] intValue];

    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.categoryBitMask = worldCategory;
    self.physicsBody.friction = 0.0;
    self.physicsWorld.contactDelegate = self;
    self.physicsWorld.gravity = CGVectorMake(0.0, -3.0);
    
    rpg01HeroNode *hero = [rpg01HeroNode hero];
    [self _addHero:CGPointMake(CGRectGetMidX(self.frame), _base_height + hero.size.height)];

    [self createStage];
    [self setSkill];
    [self displayHouseHPBar];
    [self addStatusFrame];
    [self addController:_base_height];
    
    if(_story == 99){
        [self playBGM:@"final" type:@"mp3"];
    } else {
        [self playBGM:@"tekichi" type:@"wav"];
    }
}

- (void)setSkill{
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
    if([_params[@"midare"] isEqualToString:@"OK"]){
        _isMidare = YES;
    } else {
        _isMidare = NO;
    }
    if([_params[@"speed"] isEqualToString:@"OK"]){
        _isSpeed = YES;
    } else {
        _isSpeed = NO;
    }
    if([_params[@"blue"] isEqualToString:@"OK"]){
        _isBlue = YES;
    } else {
        _isBlue = NO;
    }
    if([_params[@"study"] isEqualToString:@"OK"]){
        _fireCost = 4;
    } else {
        _fireCost = 5;
    }
    if([_params[@"brave"] isEqualToString:@"OK"]){
        _isBrave = YES;
    } else {
        _isBrave = NO;
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


- (void)createStage{
    switch(_story){
        case 1:{
            _stageTime = 20.0f;
            rpg01MapNode *map = [[rpg01MapNode alloc] initWithMapNamed:@"b1" base_height:_base_height];
            [self addChild:map];
            break;
        }
        case 2:{
            _stageTime = 30.0f;
            rpg01MapNode *map = [[rpg01MapNode alloc] initWithMapNamed:@"b2" base_height:_base_height];
            [self addChild:map];
            break;
        }
        case 3:{
            _stageTime = 30.0f;
            rpg01MapNode *map = [[rpg01MapNode alloc] initWithMapNamed:@"b4" base_height:_base_height];
            [self addChild:map];
            break;
        }
        case 4:{
            _stageTime = 30.0f;
            rpg01MapNode *map = [[rpg01MapNode alloc] initWithMapNamed:@"b3" base_height:_base_height];
            [self addChild:map];
            break;
        }
        case 5:{
            _stageTime = 30.0f;
            rpg01MapNode *map = [[rpg01MapNode alloc] initWithMapNamed:@"b5" base_height:_base_height];
            [self addChild:map];
            break;
        }
        case 6:{
            _stageTime = 40.0f;
            rpg01MapNode *map = [[rpg01MapNode alloc] initWithMapNamed:@"b5" base_height:_base_height];
            [self addChild:map];
            break;
        }
        case 7:{
            _stageTime = 40.0f;
            rpg01MapNode *map = [[rpg01MapNode alloc] initWithMapNamed:@"b5" base_height:_base_height];
            [self addChild:map];
            break;
        }
        case 8:{
            _stageTime = 40.0f;
            rpg01MapNode *map = [[rpg01MapNode alloc] initWithMapNamed:@"b5" base_height:_base_height];
            [self addChild:map];
            break;
        }
        case 9:{
            _stageTime = 40.0f;
            rpg01MapNode *map = [[rpg01MapNode alloc] initWithMapNamed:@"b5" base_height:_base_height];
            [self addChild:map];
            break;
        }
        case 10:{
            _stageTime = 45.0f;
            rpg01MapNode *map = [[rpg01MapNode alloc] initWithMapNamed:@"b5" base_height:_base_height];
            [self addChild:map];
            break;
        }
        case 11:{
            _stageTime = 45.0f;
            rpg01MapNode *map = [[rpg01MapNode alloc] initWithMapNamed:@"b5" base_height:_base_height];
            [self addChild:map];
            break;
        }
        case 12:{
            _stageTime = 60.0f;
            rpg01MapNode *map = [[rpg01MapNode alloc] initWithMapNamed:@"b5" base_height:_base_height];
            [self addChild:map];
            break;
        }
        case 13:{
            _stageTime = 60.0f;
            rpg01MapNode *map = [[rpg01MapNode alloc] initWithMapNamed:@"b5" base_height:_base_height];
            [self addChild:map];
            break;
        }
        case 14:{
            _stageTime = 60.0f;
            rpg01MapNode *map = [[rpg01MapNode alloc] initWithMapNamed:@"b5" base_height:_base_height];
            [self addChild:map];
            break;
        }
        case 15:{
            _stageTime = 10.0f;
            rpg01MapNode *map = [[rpg01MapNode alloc] initWithMapNamed:@"b5" base_height:_base_height];
            [self addChild:map];
            break;
        }
        case 99:{
            _stageTime = 87.0f;
            rpg01MapNode *map = [[rpg01MapNode alloc] initWithMapNamed:@"final" base_height:_base_height];
            [self addChild:map];
            break;
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint locaiton = [touch locationInNode:self];
    SKNode *nodeAtPoint = [self nodeAtPoint:locaiton];

    if ([nodeAtPoint.name isEqualToString:@"attackButton" ]) {
        rpg01HeroNode *hero = (rpg01HeroNode *)[self childNodeWithName:HERO_NAME];
        _direction = @"up";
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
    sword.position = CGPointMake(position.x, position.y + TILE_SIZE);
    [self addChild:sword];
    
    sword.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(TILE_SIZE, TILE_SIZE)];
    sword.physicsBody.affectedByGravity = NO;
    sword.physicsBody.categoryBitMask = swordCategory;
    sword.physicsBody.contactTestBitMask = enemyCategory;
    sword.physicsBody.collisionBitMask = 0;

    if(_isMidare){
        [sword swordMoveMidare];
    }else {
        [sword swordMove];
    }
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
    
    CGFloat heroSpeed;
    if(_isSpeed){
        heroSpeed = 0.5f;
    } else {
        heroSpeed = 1.5f;
    }
    
    CGFloat diff = abs(hero.position.x - x);
    CGFloat durationX = heroSpeed * diff / self.frame.size.width;
    diff = abs(hero.position.y - y);
    CGFloat durationY = heroSpeed * diff / self.frame.size.height;
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

- (void)_addEnemyGoldCat{
    rpg01CatNode *enemy = [rpg01CatNode goldCat];
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

- (void)_addEnemyBlueGhost{
    rpg01GhostNode *enemy = [rpg01GhostNode blueGhost];
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
    if(_mp < _fireCost){
        return;
    }
    // 炎は三つまで　処理重いんだよね
    _fires++;
    if(_fires > 3){
        _fires = 3;
        return;
    }
    [self _changeMP: - _fireCost];
    if(_mp < _fireCost && _canMagic){
        SKSpriteNode *fireButton = (SKSpriteNode *)[self childNodeWithName:@"fireButton"];
        fireButton.texture = [SKTexture textureWithImageNamed:@"fireButtonOff"];
        _canMagic = NO;
    }
        
    rpg01FireNode *fire;
    if(_isBlue){
        fire = [rpg01FireNode blueFire:from];
    } else {
        fire = [rpg01FireNode fire:from];
    }
    
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
    if(_score > 999999 ){
        _score = 999999;
    }
    SKLabelNode *scoreLabel = (SKLabelNode *)[self childNodeWithName:SCORE_NAME];
    scoreLabel.text = [NSString stringWithFormat:@"GOLD : %d", _score];
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
    if(_clearFlag){
        return;
    }
    
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
        // MP回復
        if(_isBrave){
            [self _changeMP:2];
        } else {
            [self _changeMP:1];
        }
        if(_mp >= _fireCost && !_canMagic){
            SKSpriteNode *fireButton = (SKSpriteNode *)[self childNodeWithName:@"fireButton"];
            fireButton.texture = [SKTexture textureWithImageNamed:@"fireButton"];
            _canMagic = YES;
        }
        [enemy.physicsBody applyImpulse:CGVectorMake( 0,[enemy.userData[@"attacked"] intValue])];
    } else {
        if(_isBlue){
            damage = _int*2;
        } else {
            damage = _int;
        }
    }
    if(damage <= 0){
        damage = 1;
    }
    [self displayDamage:damage position:enemy.position color:[SKColor blackColor]];

    life -= damage;

    if(life <= 0){
        int score = [enemy.userData[@"exp"] intValue] + _luck;
        if(_luck >= 30){
            score += 100;
        }
        [enemy removeFromParent];
        [self _score:score];
    } else {
        enemy.userData[@"life"] = @(life);
        [self displayLife:life name:enemy.userData[@"name"]];
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
    if(_displayedLife == YES){
        return;
    }
    SKLabelNode *damageLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    damageLabel.text = [NSString stringWithFormat:@"%@　残りHP：%d", name, life];
    damageLabel.position = CGPointMake(5.0f, CGRectGetMaxY(self.frame) - TILE_SIZE * 4);
    damageLabel.fontColor = [SKColor blackColor];
    damageLabel.fontSize = 16.0f;
    damageLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    [self addChild:damageLabel];
    _displayedLife = YES;
    
    SKAction *fadeOut = [SKAction fadeOutWithDuration:1.0f];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *sequence = [SKAction sequence:@[fadeOut, remove]];
    [damageLabel runAction:sequence completion:^{
        _displayedLife = NO;
    }];
}

- (void)update:(NSTimeInterval)currentTime {    
    if(_clearFlag == NO){
        if (_lastUpdateTimeInterval > 0) {
            CFTimeInterval timeSinceLast = currentTime - _lastUpdateTimeInterval;
            _timeSinceStart += timeSinceLast;
            _timeSinceLastSecond += timeSinceLast;
            SKLabelNode *timeLabel = (SKLabelNode *)[self childNodeWithName:TIME_NAME];
            timeLabel.fontSize = FONT_SIZE + 5;
            timeLabel.text = [NSString stringWithFormat:@"防衛完了まで残り %03.1f", _stageTime - _timeSinceStart];

            if (_timeSinceLastSecond >= 1) {
                _timeSinceLastSecond = 0;
                [self updateStage];
                
                if(_stageTime - _timeSinceStart < 5.0f){
                    SKLabelNode *count = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
                    count.fontSize = 48.0;
                    count.text = [NSString stringWithFormat:@"残り%d", (int)(_stageTime - _timeSinceStart )];
                    count.fontColor = [SKColor blackColor];
                    count.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 50.0f);
                    [self addChild:count];
                    
                    SKAction *fadeOut = [SKAction fadeOutWithDuration:1.0f];
                    SKAction *remove = [SKAction removeFromParent];
                    SKAction *sequence = [SKAction sequence:@[fadeOut, remove]];
                    [count runAction:sequence];
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
        } else if([enemy isEqualToString:@"goldCat"]){
            [self _addEnemyGoldCat];
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
        } else if([enemy isEqualToString:@"blueGhost"]){
            [self _addEnemyBlueGhost];
        } else if([enemy isEqualToString:@"greenSlime"]){
            [self _addEnemyGreenSlime];
        } else if([enemy isEqualToString:@"dark"]){
            [self _addEnemyDark];
        }
    }
}

- (void)updateStage{
    switch(_story){
        case 1: {
            [self addEnemyTiming:@"slime" timing:2];
            [self addEnemyTiming:@"cat" timing:3];
            [self addEnemyTiming:@"bat" timing:4];
            break;
        }
        case 2 : {
            [self addEnemyTiming:@"slime" timing:3];
            [self addEnemyTiming:@"cat" timing:5];
            [self addEnemyTiming:@"bat" timing:6];
            [self addEnemyTiming:@"ghost" timing:7];
            if(_onceFlag == NO){
                [self _addEnemyGhost];
                _onceFlag = YES;
            }
            break;
        }
        case 3 : {  // 骸とダンス
            [self addEnemyTiming:@"bat" timing:3];
            [self addEnemyTiming:@"skelton" timing:15];
            if(_onceFlag == NO){
                [self _addEnemySkelton];
                _onceFlag = YES;
            }
            
            break;
        }
        case 4 : {  // ドラゴン
            [self addEnemyTiming:@"bat" timing:5];
            [self addEnemyTiming:@"cat" timing:7];
            [self addEnemyTiming:@"dragon" timing:15];
            [self addEnemyTiming:@"goldCat" timing:28];
            if(_onceFlag == NO){
                [self _addEnemyDragon];
                _onceFlag = YES;
            }
            break;
        }
        case 5 : {  // 大きなネコ
            [self addEnemyTiming:@"cat" timing:2];
            [self addEnemyTiming:@"ghost" timing:3];
            [self addEnemyTiming:@"bigCat" timing:15];
            if(_onceFlag == NO){
                [self _addEnemyBigCat];
                _onceFlag = YES;
            }
            break;
        }
        case 6: {  // ここから本番
            [self addEnemyTiming:@"cat" timing:3];
            [self addEnemyTiming:@"bat" timing:5];
            [self addEnemyTiming:@"skelton" timing:10];
            break;
        }
        case 7: {  // ドラゴン面
            [self addEnemyTiming:@"cat" timing:2];
            [self addEnemyTiming:@"ghost" timing:5];
            [self addEnemyTiming:@"dragon" timing:7];
            [self addEnemyTiming:@"bigCat" timing:30];
            if(_onceFlag == NO){
                [self _addEnemyDragon];
                _onceFlag = YES;
            }
            break;
        }
        case 8: {  // ネコタウン
            [self addEnemyTiming:@"cat" timing:1];
            [self addEnemyTiming:@"cat" timing:2];
            [self addEnemyTiming:@"cat" timing:3];
            [self addEnemyTiming:@"goldCat" timing:35];
            for (int i=0; i<8; i++) {
                [self addEnemyTiming:@"cat" timing:34];
            }
            if(_onceFlag == NO){
                for (int i=0; i<8; i++) {
                    [self _addEnemyCat];
                }
                _onceFlag = YES;
            }
            break;
        }
        case 9: {  // ゴーレム
            [self addEnemyTiming:@"golem" timing:9];
            [self addEnemyTiming:@"dragon" timing:5];
            [self addEnemyTiming:@"slime" timing:2];
            if(_onceFlag == NO){
                [self _addEnemyGolem];
                _onceFlag = YES;
            }
            break;
        }
        case 10 : {  // スライムパニック
            [self addEnemyTiming:@"greenSlime" timing:1];
            [self addEnemyTiming:@"greenSlime" timing:3];
            for(int i=0; i< 8; i++){
                [self addEnemyTiming:@"greenSlime" timing:35];
            }
            if(_onceFlag == NO){
                for(int i=0; i< 8; i++){
                    [self _addEnemyGreenSlime];
                }
                _onceFlag = YES;
            }
            break;
        }
        case 11 : {   // 宿命の対決
            [self addEnemyTiming:@"goldCat" timing:35];
            [self addEnemyTiming:@"goldCat" timing:45];
            if(_onceFlag == NO){
                [self _addEnemyDark];
                _onceFlag = YES;
            }
            break;
        }
        case 12 : {   // last skelton
            [self addEnemyTiming:@"skelton" timing:4];
            if(_onceFlag == NO){
                [self _addEnemySkelton];
                _onceFlag = YES;
            }
            break;
        }
        case 13 : {   // 宿命の対決2
            [self addEnemyTiming:@"dark" timing:10];
            if(_onceFlag == NO){
                [self _addEnemyDark];
                _onceFlag = YES;
            }
            break;
        }
        case 14 : {   // 魔法しか効かない面
            [self addEnemyTiming:@"ghost" timing:2];
            [self addEnemyTiming:@"blueGhost" timing:5];
            [self addEnemyTiming:@"golem" timing:3];
            [self addEnemyTiming:@"dark" timing:20];
            break;
        }
        case 15 : {   // ボーナスステージ
            [self addEnemyTiming:@"goldCat" timing:1];
            [self addEnemyTiming:@"goldCat" timing:3];
            if(_onceFlag == NO){
                [self _addEnemyGoldCat];
                _onceFlag = YES;
            }
            break;
        }
        case 99 : {
            [self addEnemyTiming:@"greenSlime" timing:3];
            [self addEnemyTiming:@"blueGhost" timing:6];
            [self addEnemyTiming:@"skelton" timing:9];
            [self addEnemyTiming:@"golem" timing:11];
            [self addEnemyTiming:@"dragon" timing:16];
            [self addEnemyTiming:@"bigCat" timing:20];
            [self addEnemyTiming:@"goldCat" timing:24];
            [self addEnemyTiming:@"dark" timing:50];
            [self addEnemyTiming:@"dark" timing:81];
            break;
        }
    }
}

- (void)clearStage{
    _params[@"done"] = @"field";
    [self stopBGM];
    if(_story != 99){
        [self playBGM:@"clear" type:@"mp3"];
    }
    
    if(_story == 99){

    } else if (_story == 15){
        _params[@"story"] = @"15";
    } else {
        _params[@"story"] = [NSString stringWithFormat:@"%d", _story + 1];
    }
    
    SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    titleLabel.fontSize = 32.0;
    titleLabel.text = @"防衛成功！！";
    titleLabel.fontColor = [SKColor blackColor];
    titleLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 100.0f);
    [self addChild:titleLabel];

    SKLabelNode *text1 = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    text1.text = [NSString stringWithFormat:@"クリアボーナス:%d", _story * 50];
    text1.fontColor = [SKColor blackColor];
    text1.position = CGPointMake(10.0f, CGRectGetMidY(self.frame) + 40.0f);
    text1.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    [self addChild:text1];

    if(_hp >= _MAXHP - 10 && _story > 3){
        SKLabelNode *text2 = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
        text2.text = [NSString stringWithFormat:@"残りHPボーナス:%d", _hp];
        text2.fontColor = [SKColor blackColor];
        text2.position = CGPointMake(10.0f, CGRectGetMidY(self.frame));
        text2.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        [self addChild:text2];
        [self _score:_hp];
    }

    SKLabelNode *text3 = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    if(_hp < 10){
        text3.text = @"ギリギリ勝利！";
    } else if (_hp < 60){
        text3.text = @"なんとか勝利！";
    } else if (_hp < 120){
        text3.text = @"勝利にカンパイ！";
    } else if (_hp < 180){
        text3.text = @"平和ばんざい！";
    } else if (_hp < 240){
        text3.text = @"まだまだ戦いは続く";
    } else if (_hp < 300){
        text3.text = @"余裕のよっちゃん！";
    } else {
        text3.text = @"美しすぎる勝利";
    }
    text3.fontColor = [SKColor blackColor];
    text3.position = CGPointMake(10.0f, CGRectGetMidY(self.frame) - 40.0f);
    text3.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    [self addChild:text3];
    
    [self _score:_story * 50];
    _params[@"gold"] = [NSString stringWithFormat:@"%d", _score];
    
    [self performSelector:@selector(backToField) withObject:nil afterDelay:10.0f];
}

- (void)backToField{
    if(_story == 99){
        [self loadScene:@"ending"];        
    } else {
        [self stopBGM];
        [self loadSceneToDone:_params];
    }
}


@end