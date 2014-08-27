#import "rpg01FieldScene.h"
#import "rpg01HeroNode.h"
#import "rpg01MapNode.h"
#import "SKMessageNode.h"
#import "rpg01SlimeNode.h"

const int GO_TAG = 0;
const int FINAL_TAG = 1;
const int SAVE_TAG = 2;
const int GAMBLE_TAG = 3;
const int GAMBLE_TAG2 = 4;
const int GO_TAG2 = 5;

@interface rpg01FieldScene () <SKPhysicsContactDelegate>
@end

@implementation rpg01FieldScene

-(void)createSceneContents{
    
    SKMessageNode *message = [[SKMessageNode alloc] initWithSize:CGSizeMake(self.size.width, self.size.height * 0.3f)];
    [self addChild:message];
    
    CGPoint point = CGPointMake(50.0f, self.frame.size.height * 0.3 + 310.0f);
    [self makeButton:point name:@"final" text:@"最終決戦"];
    [self outputDescription:point text:@"いきなりラスボスに挑みます"];

    point = CGPointMake(50.0f, self.frame.size.height * 0.3 + 270.0f);
    [self makeButton:point name:@"go" text:@"戦場へ"];
    [self outputDescription:point text:@"準備ができたら出撃しましょう"];
    
    point = CGPointMake(50.0f, self.frame.size.height * 0.3 + 230.0f);
    [self makeButton:point name:@"LVUP" text:@"修行屋"];
    [self outputDescription:point text:@"レベルアップします"];

    point = CGPointMake(50.0f, self.frame.size.height * 0.3 + 190.0f);
    [self makeButton:point name:@"skill" text:@"スキル屋"];
    [self outputDescription:point text:@"スキルを習得"];
    
    point = CGPointMake(50.0f, self.frame.size.height * 0.3 + 150.0f);
    [self makeButton:point name:@"kajino" text:@"カジノ"];
    [self outputDescription:point text:@"70%で財産２倍。30％で０になる"];
    
    point = CGPointMake(50.0f, self.frame.size.height * 0.3 + 110.0f);
    [self makeButton:point name:@"info" text:@"民家"];
    [self outputDescription:point text:@"情報を入手できます"];
    
    point = CGPointMake(50.0f, self.frame.size.height * 0.3 + 70.0f);
    [self makeButton:point name:@"zoo" text:@"動物園"];
    [self outputDescription:point text:@"魔物図鑑が観れます"];

    point = CGPointMake(50.0f, self.frame.size.height * 0.3 + 30.0f);
    [self makeButton:point name:@"save" text:@"セーブ"];
    
    [self addStatusFrame];
    [self stopBGM];
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
    if([_params[@"story"] isEqualToString:@"b1"]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"まずはチュートリアル面をどうぞっす" message:@"迫り来るモンスター軍から町を守るであります！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ふーん", nil];
        alertView.tag = GO_TAG;
        [alertView show];
    } else if ([_params[@"story"] isEqualToString:@"b2"]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"次のステージではゴーストが出るであります！" message:@"物理攻撃では１しかダメージを与えられないので魔法を使いましょう！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"そんなの常識だぜ", nil];
        alertView.tag = GO_TAG;
        [alertView show];
    } else {
        [self loadSceneWithParam:@"title" params:_params];
    }
}

- (void)goFinal{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ほ、本当にラスボスに挑むんですか？" message:nil delegate:self cancelButtonTitle:@"冗談だよーん" otherButtonTitles:@"覚悟はできてる", nil];
    alertView.tag = FINAL_TAG;
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
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ギャンブルであります！" message:@"※勝負後に自動でセーブされます" delegate:self cancelButtonTitle:@"帰ろう" otherButtonTitles:@"勝負だー！", nil];
    alertView.tag = GAMBLE_TAG;
    [alertView show];
}

- (void)doGamble{
    int i = arc4random()%10;
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
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    SKNode *nodeAtPoint = [self nodeAtPoint:[touch locationInNode:self]];
    
    if ([nodeAtPoint.name isEqualToString:@"go"]) {
        [self goStage];
    } else if ([nodeAtPoint.name isEqualToString:@"final"]) {
        [self goFinal];
    } else if ([nodeAtPoint.name isEqualToString:@"LVUP"]) {
        _params[@"done"] = @"field";
        [self loadSceneWithParam:@"status" params:_params];
    } else if ([nodeAtPoint.name isEqualToString:@"skill"]) {
        [self loadSceneWithParam:@"shop" params:_params];
    } else if ([nodeAtPoint.name isEqualToString:@"kajino"]) {
        [self gamble];
    } else if ([nodeAtPoint.name isEqualToString:@"save"]) {
        [self saveData];
    }
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == GO_TAG){
        if([_params[@"story"] isEqualToString:@"b1"]){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"出撃準備はできましたか？" message:nil delegate:self cancelButtonTitle:@"まだ心の準備が……" otherButtonTitles:@"行くぜ！", nil];
            alertView.tag = GO_TAG2;
            [alertView show];
        } else if([_params[@"story"] isEqualToString:@"b2"]){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"魔法はMPがなくなったら使えません。" message:@"剣を敵に当てればMPが回復するのでよく考えて闘いましょう！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"はいはい", nil];
            alertView.tag = GO_TAG2;
            [alertView show];
        }
    } else if(alertView.tag == GO_TAG2){
        if([_params[@"story"] isEqualToString:@"b1"]){
            switch (buttonIndex) {
                case 0:   // まだ心の準備が……
                    _params[@"nickname"] = @"慎重な";
                    break;
                case 1:   // 覚悟はできてる。
                    [self loadSceneWithParam:@"title" params:_params];
                    break;
            }
        } else if([_params[@"story"] isEqualToString:@"b2"]){
            [self loadSceneWithParam:@"title" params:_params];
        }
    } else if(alertView.tag == FINAL_TAG){
        switch (buttonIndex) {
            case 0:   // cancel
                break;
            case 1:
                _params[@"story"] = @"final";
                [self loadSceneWithParam:@"play" params:_params];
                break;
        }
    } else if(alertView.tag == GAMBLE_TAG){
        switch (buttonIndex) {
            case 0:   // cancel
                _params[@"nickname"] = @"臆病な";
                break;
            case 1:
                [self doGamble];
        }
    }
}

@end
