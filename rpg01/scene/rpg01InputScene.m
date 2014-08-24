#import "rpg01InputScene.h"
#import "SKMessageNode.h"

const int QUESTION_NAME = 0;
const int QUESTION_JOB = 1;
const int QUESTION_IMPORTANT = 2;

@interface rpg01InputScene () <SKPhysicsContactDelegate>
@end

@implementation rpg01InputScene{
    CGFloat _story;
    NSString* _name;
    NSString* _job;
    NSString* _nickname;
    int _HP;
    int _LV;
    int _MP;
    int _gold;
    int _str;
    int _def;
    int _int;
}

- (void)createSceneContents
{
    _story = 0;
    _LV = 1;
    _HP = 20;
    _MP = 10;
    _str = 6;
    _def = 6;
    _int = 6;
    _gold = 100;
    _nickname = @"普通の";
    self.physicsWorld.contactDelegate = self;

    rpg01MapNode *map = [[rpg01MapNode alloc] initWithMapNamed:@"shop" base_height:self.frame.size.height * 0.3f];
    [self addChild:map];
    
    SKMessageNode *message = [[SKMessageNode alloc] initWithSize:CGSizeMake(self.size.width, self.size.height * 0.3f)];
    [self addChild:message];
//    [self messageNode].hidden = NO;
    
    [self setPeople];
}

- (SKMessageNode *)messageNode {
    return (SKMessageNode *)[self childNodeWithName:kMessageName];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if(_story == 0){
        _story = 1;
    } else if (_story == 1){
        _story = 3;
    } else if (_story == 2){
        _story = 3;
    } else if (_story == 5 || _story == 7){  // 質問1終了
        _story = 8;
    } else if (_story == 6){
        _story = 7;
    } else if (_story == 8){
        _story = 9;
    } else if (_story == 11 || _story == 12 || _story == 13 || _story == 14 || _story == 15){  // 質問2 終了
        _story = 18;
    } else if (_story == 20){
        _story = 21;
    } else if (_story == 21 || _story == 22 || _story == 23 || _story == 24){ // 質問3終了
        _story = 99;
    } else if (_story == 99){
        [self goStatusScene];
    } else if (_story == 100) {
        _story = 101;
    } else if (_story == 101 || _story == 500) {  // そして冒険へ
        _story = 102;
        _params[@"story"] = @"b1";
        [self loadSceneWithParam:@"field" params:_params];;
    } else if (_story == 499){
        _story = 500;
    }
}

- (void)goStatusScene{
    NSMutableDictionary *params;
    if(_HP <= 0){
        _HP = 1;
    }
    if(_str <= 0){
        _str = 1;
    }
    if(_gold <= 0){
        _gold = 0;
    }
    NSString *nickname = [NSString stringWithFormat:@"%@%@%@", _nickname, _job, _name];
    params = [@{@"name": _name,
                @"nickname" : nickname,
                @"LV" : @(_LV),
                @"HP" : @(_HP),
                @"currentHP" : @(_HP),
                @"MP" : @(_MP),
                @"gold" : @(_gold),
                @"str" : @(_str),
                @"def" : @(_def),
                @"int" : @(_int),
                @"done" : @"input",
                @"story" : @"question_end"
                } mutableCopy];
    [self loadSceneWithParam:@"status" params:params];
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == QUESTION_NAME){
        switch (buttonIndex) {
            // 名乗る名前などない
            case 0:
                _LV += 1;
                _HP += 3;
                _def += 1;
                _int += 1;
                _gold -= 10;
                _story = 6;
                _nickname = @"謎の";
                _name = @"イケメン";
                break;
            // 名前を入力した。
            case 1:
                _name = [[alertView textFieldAtIndex:0] text];
                _HP -= 1;
                _str += 1;
                _story = 5;
                break;
        }
    } else if(alertView.tag == QUESTION_JOB){
        switch (buttonIndex) {
            case 0:    // 勇者
                _HP += 3;
                _MP += 1;
                _gold -= 20;
                _str += 1;
                _def += 1;
                _int += 1;
                _job = @"勇者";
                _story = 11;
                break;
            case 1:             // 戦士
                _HP += 5;
                _MP -= 7;
                _gold -= 10;
                _str += 2;
                _def += 2;
                _int -= 1;
                _job = @"戦士";
                _story = 12;
                
                break;
            case 2:             // 魔法使い
                _HP -= 3;
                _MP += 12;
                _str -= 2;
                _def -= 1;
                _int += 5;
                _job = @"魔術師";
                _story = 13;
                break;
            case 3:             // 盗賊
                _HP -= 1;
                _MP -= 1;
                _gold += 70;
                _job = @"盗賊";
                _story = 15;
                break;
            case 4:             // 遊び人
                _job = @"遊び人";
                _gold += 7;
                _story = 14;
                break;
        }
    } else if(alertView.tag == QUESTION_IMPORTANT){
        switch (buttonIndex) {
            case 0:             // 酒代を稼ぐため
                _HP -= 5;
                _gold += 20;
                _str += 1;
                _story = 20;
                _nickname = @"アル中";
                break;
            case 1:             // "復讐"と答えた場合
                _str += 1;
                _def -= 1;
                _story = 22;
                break;
            case 2:             // "修行"と答えた場合
                _gold -= 3;
                _HP += 1;
                _int += 1;
                _story = 23;
                break;
            case 3:             // "平和"と答えた場合
                _gold -= 7;
                _HP += 3;
                _def += 1;
                _story = 24;
                if([_job isEqualToString:@"盗賊"]){
                    _int += 1;
                    _str += 1;
                    _MP += 1;
                }
                break;
        }
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if(alertView.tag == QUESTION_NAME){
        NSString *inputText = [[alertView textFieldAtIndex:0] text];
        if( [inputText length] >= 1 && [inputText length] <= 4 ) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return  YES;
    }
}

-(void)update:(CFTimeInterval)currentTime {
    if([_params[@"story"] isEqualToString:@"question_end"]){
        [self messageNode].message = @"まずは迷宮の地下3階にあるチェックポイントを目指すと良い。必要な買い物を終えたら赤い扉を開くんだな。";
        _story = 101;
    } else if(_story == 0){
        [self messageNode].message = @"あんたも秘宝を求めてやってきた冒険者か。命知らずだねぇ。";
    } else if (_story == 1){
        [self messageNode].message = @"すぐにでも迷宮に潜りたい気持ちは分かるが、まずは手続きが必要なんだ。俺の質問にいくつか答えてもらうぜ。";
    } else if (_story == 3) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"質問１" message:@"あんたの名前を教えてくれ（４文字以内）" delegate:self cancelButtonTitle:@"名乗る名前などない" otherButtonTitles:@"OK", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        alertView.tag = QUESTION_NAME;
        [alertView show];
        _story = 4;
    } else if (_story == 5) {
        if([_name isEqualToString:@"オレツエ"]){
            [self messageNode].message = @"まさかあんたが伝説の剣士オレツエ……！？　サインをください！！";
            _HP += 500;
            _MP += 100;
            _gold += 200000;
            _str += 400;
            _def += 300;
            _int += 400;
            _story = 499;
        } else {
            [self messageNode].message = [[NSString alloc]initWithFormat:@"%@、か……。この地方ではあまり聞かない名前だな。", _name];
        }
    } else if (_story == 6) {
        [self messageNode].message = @"へへっ。訳ありって事か。まあ、この迷宮に挑む奴らでは珍しい事じゃねえな。";
    } else if (_story == 7) {
        [self messageNode].message = @"呼ぶ名がないと不便だな。とりあえずイケメンと呼ばせてもらうぜ";
    } else if (_story == 8) {
        [self messageNode].message = [[NSString alloc]initWithFormat:@"%@。この調子でどんどん質問をさせてもらうぜ。残る質問は四つ、さくさく行こうぜ。", _name];
    } else if (_story == 9) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"質問2"
                                                            message:@"あんたの職業を聞かせてくれ？"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"勇者だぜ", @"戦士だよ", @"魔法使いです", @"盗賊だ",@"遊び人っす", nil];
        alertView.tag = QUESTION_JOB;
        [alertView show];
        _story = 10;
    } else if (_story == 11) {
        [self messageNode].message = @"自分で勇者を名乗るとは……ただもんじゃねえな。もしあんたが本物の勇者なら、攻守のバランスに優れて即戦力だろうな。";
    } else if (_story == 12) {
        [self messageNode].message = @"脳筋の戦士……あんたも体育会系か？　その優れた攻撃力と防御力なら即戦力間違いなしだな。";
    } else if (_story == 13) {
        [self messageNode].message = @"魔法使いには変わり者が多いって聞くが、あんたはどうなんだろうな。魔法使いは力と防御は低くてもMPの回復量が多いと聞いてるから羨ましいぜ。";
    } else if (_story == 14) {
        [self messageNode].message = @"良い身分だねぇ……忠告しておくが、ずっと遊び人でいたら賢者になれるってのは迷信だぜ。";
    } else if (_story == 15) {
        [self messageNode].message = @"おいおい……堂々と犯罪者自慢なんかして、逮捕されてもしらねえぜ。";
    } else if (_story == 18) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"質問3" message:@"迷宮に来た目的は？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"酒代を稼ぐため", @"復讐のため", @"修行のため", @"世界平和のため", nil];
        alertView.tag = QUESTION_IMPORTANT;
        [alertView show];
        _story = 19;
    } else if (_story == 20) {
        [self messageNode].message = @"ほほう、気が合うね。こんど一杯飲もうぜ。";
    } else if (_story == 21) {
        [self messageNode].message = @"しかし酒と言えば……他の冒険者にアル中が一人いたな。昔は名のある剣士だったらしいが今は廃人寸前だ……。あんたも酒の飲み過ぎには気をつける事だな。";
    } else if (_story == 22) {
        [self messageNode].message = @"復讐か……迷宮のモンスターに恋人でも殺されたか？　どう生きようかはあんたの勝手だ、俺から言う事は何もないぜ。";
    } else if (_story == 23) {
        [self messageNode].message = @"修行ねぇ……まあ、せいぜい頑張りな。";
    } else if (_story == 24) {
        if([_job isEqualToString:@"盗賊"]){
            [self messageNode].message = @"盗賊のくせに世界平和を目指すとは……義賊って奴か。俺は嫌いじゃないぜ。";
        } else {
            [self messageNode].message = @"立派だねぇ。";
        }
    } else if (_story == 99) {
        [self messageNode].message = [NSString stringWithFormat:@"質問は以上だ。話を聞く限りあんたのパラメーターは次の通りだ。"];
    } else if (_story == 500){
        [self messageNode].message = @"では、サクッと迷宮をクリアしちゃってください！";
    }
}

@end