#import "rpg01FieldScene.h"
#import "rpg01HeroNode.h"
#import "SKMessageNode.h"
#import "rpg01SlimeNode.h"

const int GO_TAG = 0;
const int FINAL_TAG = 1;
const int SAVE_TAG = 2;
const int GAMBLE_TAG = 3;
const int GAMBLE_TAG2 = 4;
const int GO_TAG2 = 5;
const int INFO_TAG = 6;
const int INFO_TAG2 = 7;
const int TIME_TAG = 8;

@interface rpg01FieldScene () <SKPhysicsContactDelegate>
@end

@implementation rpg01FieldScene

-(void)createSceneContents{
    CGPoint point = CGPointMake(50.0f, 490.0f);
    [self makeButton:point name:@"final" text:@"最終決戦"];
    [self outputDescription:point text:@"いきなりラスボスに挑みます"];

    point = CGPointMake(50.0f, 440.0f);
    [self makeButton:point name:@"go" text:@"戦場へ"];
    [self outputDescription:point text:@"準備ができたら出撃しましょう"];
    
    point = CGPointMake(50.0f, 390.0f);
    [self makeButton:point name:@"LVUP" text:@"修行屋"];
    [self outputDescription:point text:@"レベルアップします"];

    point = CGPointMake(50.0f, 340.0f);
    [self makeButton:point name:@"skill" text:@"スキル屋"];
    [self outputDescription:point text:@"スキルを習得"];
    
    point = CGPointMake(50.0f, 290.0f);
    [self makeButton:point name:@"kajino" text:@"カジノ"];
    [self outputDescription:point text:[NSString stringWithFormat:@"%d%@で勝利。勝てば所持金が倍", 50+[_params[@"luck"] intValue], @"\%"]];
    
    point = CGPointMake(50.0f, 240.0f);
    [self makeButton:point name:@"info" text:@"民家"];
    [self outputDescription:point text:@"10ゴールドで極秘情報を入手"];
    
    point = CGPointMake(50.0f, 190.0f);
    [self makeButton:point name:@"zoo" text:@"魔物図鑑"];
    [self outputDescription:point text:@"魔物図鑑が観れます"];

    point = CGPointMake(50.0f, 140.0f);
    [self makeButton:point name:@"time" text:@"時よ戻れ"];
    [self outputDescription:point text:@"ステージが一つ戻ります"];
    
    point = CGPointMake(50.0f, 90.0f);
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

- (void)goStage{
    if([_params[@"story"] isEqualToString:@"1"]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"まずはチュートリアル面をどうぞっす" message:@"迫り来るモンスター軍から町を守るであります！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ふーん", nil];
        alertView.tag = GO_TAG;
        [alertView show];
    } else if ([_params[@"story"] isEqualToString:@"2"]){
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
    int i = arc4random()%101;
    
    if(i <= 50 + [_params[@"luck"] intValue]){
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
    } else if ([nodeAtPoint.name isEqualToString:@"zoo"]) {
        _params[@"done"] = @"field";
        [self loadSceneWithParam:@"library" params:_params];
    } else if ([nodeAtPoint.name isEqualToString:@"info"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"情報の調査費用は10ゴールドであります！" message:@"" delegate:self cancelButtonTitle:@"遠慮しとくよ" otherButtonTitles:@"安い安い", nil];
        alertView.tag = INFO_TAG;
        [alertView show];
    } else if ([nodeAtPoint.name isEqualToString:@"time"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"もうあの頃には戻れないのでしょうか？" message:@"" delegate:self cancelButtonTitle:@"そうだね……" otherButtonTitles:@"戻れるよ", nil];
        alertView.tag = TIME_TAG;
        [alertView show];
        
    } else if ([nodeAtPoint.name isEqualToString:@"save"]) {
        [self saveData];
    }
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == GO_TAG){
        if([_params[@"story"] isEqualToString:@"1"]){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"出撃準備はできましたか？" message:nil delegate:self cancelButtonTitle:@"まだ心の準備が……" otherButtonTitles:@"行くぜ！", nil];
            alertView.tag = GO_TAG2;
            [alertView show];
        } else if([_params[@"story"] isEqualToString:@"2"]){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"魔法はMPがなくなったら使えません。" message:@"剣を敵に当てればMPが回復するのでよく考えて闘いましょう！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"はいはい", nil];
            alertView.tag = GO_TAG2;
            [alertView show];
        }
    } else if(alertView.tag == GO_TAG2){
        if([_params[@"story"] isEqualToString:@"1"]){
            switch (buttonIndex) {
                case 0:   // まだ心の準備が……
                    _params[@"nickname"] = @"慎重な";
                    break;
                case 1:   // 覚悟はできてる。
                    [self loadSceneWithParam:@"title" params:_params];
                    break;
            }
        } else if([_params[@"story"] isEqualToString:@"2"]){
            [self loadSceneWithParam:@"title" params:_params];
        }
    } else if(alertView.tag == FINAL_TAG){
        switch (buttonIndex) {
            case 0:   // cancel
                break;
            case 1:
                _params[@"story"] = @"99";
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
    } else if(alertView.tag == INFO_TAG){
        if(buttonIndex == 1){
            if([_params[@"gold"] intValue] < 10){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"お金が足りないであります……" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"うそ……俺の年収低すぎ", nil];
                alertView.tag = INFO_TAG2;
                _params[@"_nickname"] = @"ヘタレ";
                [alertView show];
            } else {
                [self outputGold];
                _params[@"gold"] = [NSString stringWithFormat:@"%d",[_params[@"gold"] intValue] -10];
                [self outputGold];
                int i = arc4random()%22;
                NSString *title;
                NSString *text;
                if(i == 0){
                    title = @"情報No01";
                    text = @"名前をオレツエにすると最強状態になる";
                } else if(i == 1){
                    title = @"情報No02";
                    text = @"名前を社長にすると金持ち状態でスタート";
                } else if(i == 2){
                    title = @"情報No03";
                    text = @"カジノの勝率は (50+幸運)になる。最高80%";
                } else if(i == 3){
                    title = @"情報No04";
                    text = @"ステージ４以降、ダメージ10以下でクリアすればボーナスをもらえる";
                } else if(i == 4){
                    title = @"情報No05";
                    text = @"感想とか貰えると制作者はとても嬉しいぞ！";
                } else if(i == 5){
                    title = @"情報No06";
                    text = @"魔力の最大値は50";
                } else if(i == 6){
                    title = @"情報No07";
                    text = @"力の最大値は999";
                } else if(i == 7){
                    title = @"情報No08";
                    text = @"HPの最大値は350";
                } else if(i == 8){
                    title = @"情報No09";
                    text = @"MPの最大値は50";
                } else if(i == 9){
                    title = @"情報No10";
                    text = @"幸運が上がると敵モンスターが落とすゴールドが幸運の値だけ増える";
                } else if(i == 10){
                    title = @"情報No11";
                    text = @"幸運の最大値は30";
                } else if(i == 11){
                    title = @"情報No12";
                    text = @"幸運の最大値は30";
                } else if(i == 12){
                    title = @"情報No13";
                    text = @"ゴールドの最大値は999999";
                } else if(i == 13){
                    title = @"情報No14";
                    text = @"ゴーレムはHPが超高い上に物理攻撃が効かない";
                } else if(i == 14){
                    title = @"情報No15";
                    text = @"主人公の色違いの敵は、宿命の敵という設定。光と影って奴だ！";
                } else if(i == 15){
                    title = @"情報No16";
                    text = @"ドラゴンの絵は失敗したと思ってる";
                } else if(i == 16){
                    title = @"情報No17";
                    text = @"巨大ネコは調子に乗って大きいサイズにしすぎた";
                } else if(i == 17){
                    title = @"情報No18";
                    text = @"お金が足りないのに買い物をしようとするとヘタレ等の称号がつく";
                } else if(i == 18){
                    title = @"情報No19";
                    text = @"ぶっちゃけ魔力が高くないとクリアは不可能だと思う";
                } else if(i == 19){
                    title = @"情報No20";
                    text = @"明日はきっと良いことがある";
                } else if(i == 20){
                    title = @"情報No21";
                    text = @"幸運を最大値にすれと貰えるゴールドが激増する";
                } else if(i == 21){
                    title = @"情報No22";
                    text = @"LVアップに必要なゴールドは最大で1000";
                }
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:text delegate:self cancelButtonTitle:nil otherButtonTitles:@"へー、そうなんだ", nil];
                alertView.tag = INFO_TAG2;
                [alertView show];
            }
        }
    } else if(alertView.tag == TIME_TAG){
        if(buttonIndex == 1){
            if([_params[@"story"] isEqualToString:@"1"] || [_params[@"story"] isEqualToString:@"99"]){
                // 戻れない
            } else {
                _params[@"story"] = [NSString stringWithFormat:@"%d", [_params[@"story"] intValue] -1];
            }
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"時を戻しました！" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"にやり", nil];
            alertView.tag = INFO_TAG2;
            _params[@"_nickname"] = @"ヘタレ";
            [alertView show];
        }
    }
}

@end
