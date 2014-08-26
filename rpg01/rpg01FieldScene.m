#import "rpg01FieldScene.h"
#import "rpg01HeroNode.h"
#import "rpg01MapNode.h"
#import "SKMessageNode.h"
#import "rpg01SlimeNode.h"
#import "rpg01DoorNode.h"

const int DOOR_TAG = 0;
const int HEAL_TAG = 1;
const int SAVE_TAG = 2;
const int GAMBLE_TAG = 3;
const int GAMBLE_TAG2 = 4;

@interface rpg01FieldScene () <SKPhysicsContactDelegate>
@end

@implementation rpg01FieldScene{
    bool _canMove;
    NSString* _talk;
}

-(void)createSceneContents{    
    
    _canMove = YES;
//    int _base_height = self.size.height*0.3f;
    
    SKMessageNode *message = [[SKMessageNode alloc] initWithSize:CGSizeMake(self.size.width, self.size.height * 0.3f)];
    [self addChild:message];
    
    CGPoint point = CGPointMake(50.0f, self.frame.size.height * 0.3 + 310.0f);
    [self makeButton:point name:@"go" text:@"戦場へ"];
    [self outputDescription:point text:@"準備ができたら出撃しましょう"];
    
    point = CGPointMake(50.0f, self.frame.size.height * 0.3 + 275.0f);
    [self makeButton:point name:@"LVUP" text:@"修行屋"];
    [self outputDescription:point text:@"レベルアップします"];

    point = CGPointMake(50.0f, self.frame.size.height * 0.3 + 240.0f);
    [self makeButton:point name:@"weapon" text:@"武器屋"];
    [self outputDescription:point text:@"武器攻撃力をパワーアップします"];
    
    point = CGPointMake(50.0f, self.frame.size.height * 0.3 + 205.0f);
    [self makeButton:point name:@"magic" text:@"魔法屋"];
    [self outputDescription:point text:@"魔法をパワーアップします"];
    
    point = CGPointMake(50.0f, self.frame.size.height * 0.3 + 170.0f);
    [self makeButton:point name:@"daiku" text:@"大工屋"];
    [self outputDescription:point text:@"町の防衛力を上げます"];

    point = CGPointMake(50.0f, self.frame.size.height * 0.3 + 135.0f);
    [self makeButton:point name:@"kajino" text:@"カジノ"];
    [self outputDescription:point text:@"70%で財産２倍。30％で０になります"];
    
    point = CGPointMake(50.0f, self.frame.size.height * 0.3 + 100.0f);
    [self makeButton:point name:@"info" text:@"民家"];
    [self outputDescription:point text:@"情報を入手できます"];
    
    point = CGPointMake(50.0f, self.frame.size.height * 0.3 + 65.0f);
    [self makeButton:point name:@"zoo" text:@"動物園"];
    [self outputDescription:point text:@"魔物図鑑が観れます"];

    point = CGPointMake(50.0f, self.frame.size.height * 0.3 + 30.0f);
    [self makeButton:point name:@"save" text:@"セーブ"];
    
    [self addStatusFrame];
}

- (void)outputDescription:(CGPoint)point text:(NSString*)text{
    SKLabelNode *textLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    textLabel.text = text;
    textLabel.position = CGPointMake(point.x + 50.0f, point.y - 5.0f);
    textLabel.fontSize = 14.0f;
    textLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;

    textLabel.color = [SKColor whiteColor];
    [self addChild:textLabel];
}

- (SKMessageNode *)messageNode {
    return (SKMessageNode *)[self childNodeWithName:kMessageName];
}

- (void)goStage{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"出撃準備はできましたか？" message:nil delegate:self cancelButtonTitle:@"まだ心の準備が……" otherButtonTitles:@"行くぜ！", nil];
    alertView.tag = DOOR_TAG;
    [alertView show];
}

- (void)saveData{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_params forKey:@"params"];

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"セーブ完了であります！" message:@"これで負けても安心ですな。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"にやり", nil];
    alertView.tag = SAVE_TAG;
    [alertView show];
}

- (void)gamble{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ギャンブルであります！" message:@"勝負後に自動でセーブされますので注意" delegate:self cancelButtonTitle:@"帰ろう" otherButtonTitles:@"勝負だー！", nil];
    alertView.tag = GAMBLE_TAG;
    [alertView show];
}

/*
- (void)talkSister{
    if([_params[@"sisterStory"] isEqualToString:@"friend"]){
        int exp = 5 * [_params[@"LV"] intValue];
        int gold = [_params[@"gold"] intValue];
        if(exp >= gold){
            [self messageNode].message = @"傷ついた人々を癒したいですが……残念ながら寄付金が足りません。";
        } else {
            [self messageNode].message = [NSString stringWithFormat:@"%dの寄付金をいただければ戦争で傷ついた人々を癒せます", exp];
            _talk = @"sisterHeal";
            _canMove = NO;
        }
    } else {
        [self messageNode].message = [NSString stringWithFormat:@"こんにちは、%@さん。私はシスターのエリー。戦争で傷つく人を癒したくてここに来ました。", _params[@"nickname"]];
        _params[@"slimeStory"] = @"friend";
        _canMove = NO;
        _talk = @"sister0";
    }
}
 */

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    SKNode *nodeAtPoint = [self nodeAtPoint:[touch locationInNode:self]];
    
    if(_canMove == NO){
        if([_talk isEqualToString:@"sisterHeal"]){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"シスターの回復" message:@"寄付金を払って回復しますか？" delegate:self cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい", nil];
            alertView.tag = HEAL_TAG;
            [alertView show];
        } else if([_talk isEqualToString:@"sister0"]){
            [self messageNode].message = @"小額の寄付をいただければ戦争で傷ついた人々を癒せます。";
            _canMove = YES;
            _params[@"sisterStory"] = @"friend";
        }
    } else {
        if ([nodeAtPoint.name isEqualToString:@"go"]) {
            [self goStage];
        } else if ([nodeAtPoint.name isEqualToString:@"LVUP"]) {
            _params[@"done"] = @"field";
            [self loadSceneWithParam:@"status" params:_params];
        } else if ([nodeAtPoint.name isEqualToString:@"kajino"]) {
            [self gamble];
        } else if ([nodeAtPoint.name isEqualToString:@"save"]) {
            [self saveData];
        }
    }
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == DOOR_TAG){
        switch (buttonIndex) {
            case 0:   // まだ心の準備が……
                _params[@"nickname"] = @"慎重な";
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
    } else if(alertView.tag == GAMBLE_TAG){
        int i;
        switch (buttonIndex) {
            case 0:   // cancel
                _params[@"nickname"] = @"臆病な";
                break;
            case 1:
                i = arc4random()%10;
                if(i <= 6){
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"大勝利！" message:@"ふっふっふ、財産が２倍になったであります！" delegate:self cancelButtonTitle:@"今夜は焼き肉だー！" otherButtonTitles:nil, nil];
                    alertView.tag = GAMBLE_TAG2;
                    _params[@"gold"] = [NSString stringWithFormat:@"%d", [_params[@"gold"] intValue]*2];
                    _params[@"nickname"] = @"勝負師";
                    [alertView show];
                } else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"とほほ。負けちゃいました" message:@"悲しいであります　(´；ω；｀)" delegate:self cancelButtonTitle:@"帰ろうか……" otherButtonTitles:nil, nil];
                    alertView.tag = GAMBLE_TAG2;
                    _params[@"gold"] = @"0";
                    _params[@"nickname"] = @"文無し";
                    [alertView show];
                }
                NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:_params forKey:@"params"];
                [self outputGold];
                break;
        }
    }
}

@end
