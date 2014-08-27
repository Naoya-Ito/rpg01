#import "rpg01BaseScene.h"
#import "rpg01OpeningScene.h"
#import "rpg01TitleScene.h"
#import "rpg01InputScene.h"
#import "rpg01PlayScene.h"
#import "rpg01GameOverScene.h"
#import "rpg01StatusScene.h"
#import "rpg01FieldScene.h"
#import "rpg01ShopScene.h"


#import "rpg01SlimeNode.h"
#import "rpg01SisterNode.h"


@implementation rpg01BaseScene

static const CGFloat SCENE_DURATION = 0.6f;

- (id)initWithSize:(CGSize)size name:(NSString *)name {
    if (self = [super initWithSize:size]) {
    }
    _isBGMPlaying = NO;
    return self;
}

- (id)initWithParam:(CGSize)size name:(NSString *)name params:(NSMutableDictionary *)params{
    _params = params;
    if (self = [super initWithSize:size]) {
    }
    return self;
}

- (void)didMoveToView:(SKView *)view {
    if (!_contentCreated) {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents {
    
}

- (void)loadScene:(NSString *)name {
    [self loadSceneWithParam:name params:nil];
}

- (void)loadSceneWithParam:(NSString *)name params:(NSMutableDictionary *)params{
    SKScene *scene;
    if ([name hasPrefix:@"title"]) {
        scene = [[rpg01TitleScene alloc] initWithParam:self.size name:name params:params];
    } else if ([name hasPrefix:@"input"]) {
        scene = [[rpg01InputScene alloc] initWithParam:self.size name:name params:params];
    } else if ([name hasPrefix:@"play"]) {
        scene = [[rpg01PlayScene alloc] initWithParam:self.size name:name params:params];
    } else if ([name hasPrefix:@"gameOver"]) {
        scene = [[rpg01GameOverScene alloc] initWithParam:self.size name:name params:params];
    } else if ([name hasPrefix:@"opening"]) {
        scene = [[rpg01OpeningScene alloc] initWithParam:self.size name:name params:params];
    } else if ([name hasPrefix:@"status"]) {
        scene = [[rpg01StatusScene alloc] initWithParam:self.size name:name params:params];
    } else if ([name hasPrefix:@"field"]) {
        scene = [[rpg01FieldScene alloc] initWithParam:self.size name:name params:params];
    } else if ([name hasPrefix:@"shop"]) {
        scene = [[rpg01ShopScene alloc] initWithParam:self.size name:name params:params];
    } else {
        NSLog(@"not exist scene. scene = %@", scene);
    }
    if (scene) {
        SKTransition *transition = [SKTransition fadeWithDuration:SCENE_DURATION];
        [self.view presentScene:scene transition:transition];
    }
}

- (void)loadSceneToDone:(NSMutableDictionary *)params{
    [self loadSceneWithParam:_params[@"done"] params:params];
}

- (void)addStatusFrame{
    CGRect rect = CGRectMake(CGRectGetMidX(self.frame), self.frame.size.height * 0.95f, self.frame.size.width, self.frame.size.height * 0.1f);
    SKSpriteNode *square = [SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:rect.size];
    square.position = rect.origin;
    square.name = @"status";
    square.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rect.size];
    square.physicsBody.dynamic = NO;
    square.physicsBody.categoryBitMask = worldCategory;
    square.physicsBody.collisionBitMask = heroCategory | enemyCategory;
    [self addChild:square];
                  
    [self addHPLabel];
    [self addMPLabel];
    [self addTimeLabel];
    [self addScoreLabel];
    
    SKLabelNode *scoreLabel = (SKLabelNode *)[self childNodeWithName:SCORE_NAME];
    scoreLabel.text = [NSString stringWithFormat:@"GOLD : %d", [_params[@"gold"] intValue]];
}

- (void)addHPLabel{
    SKLabelNode *hpLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    hpLabel.name = HP_NAME;
    hpLabel.fontColor = [SKColor whiteColor];
    hpLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    hpLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    hpLabel.position = CGPointMake(5.0f, CGRectGetMaxY(self.frame) - 20.0f);
    hpLabel.fontSize = 14.0f;
    hpLabel.text = [NSString stringWithFormat:@"HP : %d / %d", [_params[@"currentHP"] intValue], [_params[@"HP"] intValue]];

    [self addChild:hpLabel];
}

- (void)addMPLabel{
    SKLabelNode *mpLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    mpLabel.name = MP_NAME;
    mpLabel.fontColor = [SKColor whiteColor];
    mpLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    mpLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    mpLabel.position = CGPointMake(5.0f, CGRectGetMaxY(self.frame) - 40.0f);
    mpLabel.fontSize = 14.0f;
    mpLabel.text = [NSString stringWithFormat:@"MP : %d / %d", [_params[@"MP"] intValue], [_params[@"MP"] intValue]];
    
    [self addChild:mpLabel];
}

- (void)addTimeLabel{
    SKLabelNode *timeLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    timeLabel.name = TIME_NAME;
    timeLabel.fontColor = [SKColor blackColor];
    timeLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    timeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    timeLabel.position = CGPointMake(5.0f, CGRectGetMaxY(self.frame) - TILE_SIZE * 3);
    timeLabel.fontSize = 14.0f;
    [self addChild:timeLabel];
}

- (void)addScoreLabel{
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    scoreLabel.name = SCORE_NAME;
    scoreLabel.fontColor = [SKColor whiteColor];
    scoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    scoreLabel.position = CGPointMake(CGRectGetMaxX(self.frame) - scoreLabel.frame.size.width - 5.0f, CGRectGetMaxY(self.frame) - 20.0f);
    scoreLabel.fontSize = 14.0f;
    [self addChild:scoreLabel];
}


// 人々の配置
- (void)setPeople{
    rpg01SisterNode *sister = [rpg01SisterNode sister];
    sister.position = CGPointMake(TILE_SIZE*8.5, self.frame.size.height - TILE_SIZE*3);
    sister.name = SISTER_NAME;
    [self addChild:sister];
    
    rpg01SlimeNode *enemy = [rpg01SlimeNode slime];
    enemy.position = CGPointMake(200.0f, 300.0f);
    enemy.name = ENEMY_NAME;
    [self addChild:enemy];
    [enemy slimeAnimation];
}

- (void)addController:(CGFloat)_base_height{
    CGRect rect = CGRectMake(CGRectGetMidX(self.frame), _base_height/2, self.frame.size.width, _base_height);
    SKSpriteNode *square = [SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:rect.size];
    square.position = rect.origin;
    square.name = @"controller";
    square.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rect.size];
    square.physicsBody.affectedByGravity = NO;
    square.physicsBody.allowsRotation = NO;
    square.physicsBody.dynamic = NO;
    square.physicsBody.categoryBitMask = worldCategory;
    square.physicsBody.contactTestBitMask = 0;
    square.physicsBody.collisionBitMask = heroCategory | enemyCategory;
    [self addChild:square];
    
    SKSpriteNode *fireButton = [SKSpriteNode spriteNodeWithImageNamed:@"fireButton"];
    fireButton.position = CGPointMake( 50, 80.0);
    fireButton.name = @"fireButton";
    [self addChild:fireButton];
    
    SKSpriteNode *attackButton = [SKSpriteNode spriteNodeWithImageNamed:@"swordButton"];
    attackButton.position = CGPointMake( self.frame.size.width - 80, 80.0);
    attackButton.name = @"attackButton";
    [self addChild:attackButton];
}


- (void)makeButton:(CGPoint)point name:(NSString *)name text:(NSString*)text{
    CGRect rect = CGRectMake(point.x, point.y, 65.0f, 28.0f);
    SKSpriteNode *square = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:rect.size];
    square.position = rect.origin;
    square.name = name;
    [self addChild:square];
    
    SKLabelNode *textLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    textLabel.fontColor = [SKColor blackColor];
    textLabel.name = name;
    textLabel.fontSize = 15.0f;
    textLabel.text = text;
    
    textLabel.position = CGPointMake(rect.origin.x , rect.origin.y - rect.size.height/4);
    [self addChild:textLabel];
}

- (void)makeButtonWithSize:(CGPoint)point name:(NSString *)name text:(NSString*)text size:(CGSize)size{
    SKSpriteNode *square = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:size];
    square.position = point;
    square.name = name;
    [self addChild:square];
    
    SKLabelNode *textLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    textLabel.fontColor = [SKColor blackColor];
    textLabel.name = name;
    textLabel.fontSize = 15.0f;
    textLabel.text = text;

    textLabel.position = CGPointMake(point.x , point.y - size.height/4);
    [self addChild:textLabel];
}

- (void)playBGM:(NSString*)name type:(NSString *)type{
    if(_isBGMPlaying == YES){
        return;
    }
    _isBGMPlaying = YES;
    NSString* path = [[NSBundle mainBundle]
                      pathForResource:name ofType:type];
    NSURL* url = [NSURL fileURLWithPath:path];
    _audioPlayer = [[AVAudioPlayer alloc]
                    initWithContentsOfURL:url error:nil];
    _audioPlayer.numberOfLoops = -1;
    [_audioPlayer play];
}

- (void)stopBGM{
    if(_isBGMPlaying == NO){
        return;
    }
    _isBGMPlaying = NO;
    //    [audio pause]
    [_audioPlayer stop];
}

- (void)outputGold{
    SKLabelNode *scoreLabel = (SKLabelNode *)[self childNodeWithName:SCORE_NAME];
    scoreLabel.text = [NSString stringWithFormat:@"GOLD : %05d", [_params[@"gold"] intValue]];
}

@end