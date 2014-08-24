#import "rpg01FieldScene.h"
#import "rpg01HeroNode.h"
#import "rpg01MapNode.h"
#import "SKMessageNode.h"
#import "rpg01SlimeNode.h"
#import "rpg01DoorNode.h"

const int DOOR_TAG = 0;
const int HEAL_TAG = 1;

@interface rpg01FieldScene () <SKPhysicsContactDelegate>
@end

@implementation rpg01FieldScene{
    bool _canMove;
    NSString* _talk;
}

-(void)createSceneContents{
    _canMove = YES;
    int _base_height = self.size.height*0.3f;
    
    rpg01MapNode *map = [[rpg01MapNode alloc] initWithMapNamed:@"shop" base_height:_base_height];
    [self addChild:map];
    
    rpg01HeroNode *hero = [rpg01HeroNode hero];
    hero.position = CGPointMake(CGRectGetMidX(self.frame), _base_height + hero.size.height);
    hero.name = HERO_NAME;
    hero.zPosition = 1.0f;
    [self addChild:hero];
    
    SKMessageNode *message = [[SKMessageNode alloc] initWithSize:CGSizeMake(self.size.width, self.size.height * 0.3f)];
    [self addChild:message];
    
    SKSpriteNode * door = [rpg01DoorNode door];
    door.position = CGPointMake(TILE_SIZE*2.5, self.frame.size.height - TILE_SIZE*3);
    [self addChild:door];

    [self setPeople];
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsWorld.contactDelegate = self;
    self.physicsBody.categoryBitMask = worldCategory;
    self.physicsBody.collisionBitMask = heroCategory;
    self.physicsBody.usesPreciseCollisionDetection = YES;
    
    [self addStatusFrame];
}

- (SKMessageNode *)messageNode {
    return (SKMessageNode *)[self childNodeWithName:kMessageName];
}

- (void)touchDoor{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"迷宮への扉" message:@"覚悟ができたなら通るべし。" delegate:self cancelButtonTitle:@"まだ心の準備が……" otherButtonTitles:@"行くぜ！", nil];
    alertView.tag = DOOR_TAG;
    [alertView show];
}

- (void)talkSlime{
    if([_params[@"slimeStory"] isEqualToString:@"friend"]){
        int exp = 100 * [_params[@"LV"] intValue];
        [self messageNode].message = [NSString stringWithFormat:@"プルプル。レベルアップに必要なゴールドは%dだよ", exp];
        _talk = @"slimeStatus";
        _canMove = NO;
    } else {
        [self messageNode].message = @"プルプル。僕に声をかけてくれれば君のステータスを見せてあげるよ。お金をくれればレベルアップもできるんだ。";
        _params[@"slimeStory"] = @"friend";
    }
}

- (void)talkSister{
    if([_params[@"sisterStory"] isEqualToString:@"friend"]){
        int exp = 5 * [_params[@"LV"] intValue];
        int gold = [_params[@"gold"] intValue];
        if(exp >= gold){
            [self messageNode].message = @"あなたの傷を治したいですが……残念ながら寄付金が足りません。";
        } else {
            [self messageNode].message = [NSString stringWithFormat:@"%dの寄付金をいただければ傷を癒せます", exp];
            _talk = @"sisterHeal";
            _canMove = NO;
        }
    } else {
        [self messageNode].message = [NSString stringWithFormat:@"こんにちは、%@さん。私はシスターのエリー。迷宮で傷つく人を癒したくてここに来ました。", _params[@"nickname"]];
        _params[@"slimeStory"] = @"friend";
        _canMove = NO;
        _talk = @"sister0";
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint locaiton = [touch locationInNode:self];

    if(_canMove == NO){
        if([_talk isEqualToString:@"slimeStatus"]){
            _params[@"done"] = @"field";
            [self loadSceneWithParam:@"status" params:_params];
        } else if([_talk isEqualToString:@"slimeStatus"]){
            _params[@"done"] = @"field";
            [self loadSceneWithParam:@"play" params:_params];
        } else if([_talk isEqualToString:@"sisterHeal"]){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"シスターの回復" message:@"寄付金を払って回復しますか？" delegate:self cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい", nil];
            alertView.tag = HEAL_TAG;
            [alertView show];
        } else if([_talk isEqualToString:@"sister0"]){
            [self messageNode].message = @"小額の寄付をいただければ体力を満タンにしてあげることができます。くれぐれも無理はなさらないでくださいね……。";
            _canMove = YES;
            _params[@"sisterStory"] = @"friend";
        }
    } else {
        [self _moveHero:locaiton];
    }
}

// 主人公を動かす
- (void)_moveHero:(CGPoint)locaiton {

    rpg01HeroNode *hero = (rpg01HeroNode *)[self childNodeWithName:@"hero"];
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
    NSString *_direction;
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
    
    CGVector vector = CGVectorMake( (locaiton.x - hero.position.x)/30 , (locaiton.y - hero.position.y)/30);
    [hero.physicsBody applyImpulse:vector];

    /*
    SKAction *move = [SKAction moveTo:CGPointMake(locaiton.x, y) duration:duration];
    [hero runAction:move completion:^{
        [hero stop];
    }];
     */
}


- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == DOOR_TAG){
        switch (buttonIndex) {
            case 0:   // まだ心の準備が……
                _params[@"_nickname"] = @"慎重な";
                break;
            case 1:   // 覚悟はできてる。
                [self loadSceneWithParam:@"play" params:_params];
                break;
        }
    } else if(alertView.tag == HEAL_TAG){
        switch (buttonIndex) {
            case 0:   // cancel
                _canMove = YES;
                break;
            case 1:   // heal
                _params[@"currentHP"] = _params[@"HP"];
                _params[@"gold"] = @([_params[@"gold"] intValue] - [_params[@"LV"] intValue]*5);
                _canMove = YES;
                break;
        }
    }
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
        if ((secondBody.categoryBitMask & slimeCategory) != 0) {
            [self talkSlime];
        } else if ((secondBody.categoryBitMask & doorCategory) != 0) {
            [self touchDoor];
        } else if ((secondBody.categoryBitMask & sisterCategory) != 0) {
            [self talkSister];
        }
    }
    [firstBody.node removeAllActions];
}

@end
