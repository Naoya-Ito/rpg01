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
    int _int;
    int _luck;
}

- (void)createSceneContents
{
    _story = 0;
    _LV = 1;
    _HP = 150;
    _MP = 10;
    _str = 6;
    _int = 6;
    _luck = 1;
    _gold = 100;
    _nickname = @"普通の";
    self.physicsWorld.contactDelegate = self;
    
    SKMessageNode *message = [[SKMessageNode alloc] initWithSize:CGSizeMake(self.size.width, self.size.height * 0.3f)];
    [self addChild:message];

    NSArray *textures = [self _textures:@"hiroin" withRow:3 cols:1];
    SKSpriteNode *heroin = [SKSpriteNode spriteNodeWithTexture:textures.firstObject];
    heroin.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:heroin];
}

- (NSArray *)_textures:(NSString *)name withRow:(int)row cols:(int)cols {
    SKTexture *texture = [SKTexture textureWithImageNamed:name];
    
    NSMutableArray *textures = @[].mutableCopy;
    for (int col = 0; col < cols; col++) {
        CGFloat x = col * 32 / texture.size.width;
        CGFloat y = row * 32/ texture.size.height;
        CGFloat w = 32 / texture.size.width;
        CGFloat h = 32 / texture.size.height;
        SKTexture *t = [SKTexture textureWithRect:CGRectMake(x, y, w, h) inTexture:texture];
        [textures addObject:t];
    }
    return textures;
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
    } else if (_story == 99 || _story == 500){
        [self goStatusScene];
    } else if (_story == 100) {
        _story = 101;
    } else if (_story == 101) {  // そして冒険へ
        _story = 102;
        _params[@"story"] = @"1";
        [self loadSceneWithParam:@"field" params:_params];;
    } else if (_story == 499){
        _story = 500;
    }
}

- (void)goStatusScene{
    NSMutableDictionary *params;
    if(_HP <= 100){
        _HP = 100;
    }
    if(_MP <= 5){
        _MP = 5;
    }
    if(_str <= 0){
        _str = 1;
    }
    if(_int <= 3){
        _int = 3;
    }
    if(_luck <= 0){
        _luck = 1;
    }
    if(_gold <= 0){
        _gold = 0;
    }
    NSString *nickname = [NSString stringWithFormat:@"%@%@%@", _nickname, _job, _name];
    params = [@{@"name": _name,
                @"nickname" : _nickname,
                @"job" : _job,
                @"nickname" : nickname,
                @"LV" : @(_LV),
                @"HP" : @(_HP),
                @"currentHP" : @(_HP),
                @"MP" : @(_MP),
                @"gold" : @(_gold),
                @"str" : @(_str),
                @"luck" : @(_luck),
                @"int" : @(_int),
                @"done" : @"input",
                @"story" : @"question_end"
                } mutableCopy];
    if([_name isEqualToString:@"オレツエ"]){
        params[@"speed"] = @"OK";
        params[@"cons"] = @"OK";
        params[@"wakeUp"] = @"OK";
        params[@"midare"] = @"OK";
        params[@"blue"] = @"OK";
    }
    [self loadSceneWithParam:@"status" params:params];
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == QUESTION_NAME){
        switch (buttonIndex) {
            case 0:             // 名乗る名前などない
                _LV += 1;
                _HP += 30;
                _gold -= 10;
                _story = 6;
                _nickname = @"謎の";
                _name = @"イケメン";
                break;
            case 1:             // 名前を入力した。
                _name = [[alertView textFieldAtIndex:0] text];
                _HP -= 10;
                _str += 1;
                _MP += 1;
                _story = 5;
                if([_name isEqualToString:@"社長"]){
                    _gold = 50000;
                }
                break;
        }
    } else if(alertView.tag == QUESTION_JOB){
        switch (buttonIndex) {
            case 0:    // 勇者
                _LV += 2;
                _HP += 30;
                _MP += 2;
                _gold += 10;
                _str += 1;
                _int += 1;
                _luck += 1;
                _job = @"勇者";
                _story = 11;
                break;
            case 1:             // 戦士
                _LV += 1;
                _HP += 50;
                _MP -= 6;
                _gold -= 20;
                _str += 2;
                _int -= 1;
                _job = @"戦士";
                _story = 12;
                break;
            case 2:             // 魔法使い
                _LV += 2;
                _HP -= 30;
                _MP += 12;
                _str -= 2;
                _int += 5;
                _job = @"魔術師";
                _story = 13;
                break;
            case 3:             // 盗賊
                _LV += 1;
                _HP -= 10;
                _MP -= 1;
                _gold += 70;
                _luck += 3;
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
                _HP -= 20;
                _gold += 20;
                _str += 1;
                _story = 20;
                _nickname = @"アル中";
                break;
            case 1:             // "復讐"と答えた場合
                _str += 1;
                _luck -= 1;
                _story = 22;
                break;
            case 2:             // "修行"と答えた場合
                _gold -= 3;
                _HP += 10;
                _int += 1;
                _story = 23;
                break;
            case 3:             // "平和"と答えた場合
                _gold -= 7;
                _HP += 20;
                _luck += 1;
                _story = 24;
                if([_job isEqualToString:@"盗賊"]){
                    _nickname = @"正義の";
                    _LV += 1;
                    _int += 1;
                    _str += 1;
                    _luck += 1;
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
        [self messageNode].message = @"それでは、準備ができたら出撃しましょう！　モンスター群から町を守るのが我々の使命でありますね。";
        _story = 101;
    } else if(_story == 0){
        [self messageNode].message = @"こんにちはであります大佐！　私は今日から防衛軍に配属されたルビーであります！";
    } else if (_story == 1){
        [self messageNode].message = @"初めに大佐の事を知る為にいくつか質問させてもらうであります！";
    } else if (_story == 3) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"質問１" message:@"お名前を教えて欲しいであります！（４文字以内）" delegate:self cancelButtonTitle:@"名乗る名前などない" otherButtonTitles:@"OK", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        alertView.tag = QUESTION_NAME;
        [alertView show];
        _story = 4;
    } else if (_story == 5) {
        if([_name isEqualToString:@"オレツエ"]){
            [self messageNode].message = @"まさかあなたが伝説の剣士オレツエさんでありますか！？　サインをください！！";
            _nickname = @"究極";
            _job = @"勇者";
            _HP = 350;
            _MP = 50;
            _gold = 200000;
            _str = 99;
            _luck = 30;
            _int = 50;
            _story = 499;
        } else {
            [self messageNode].message = [[NSString alloc]initWithFormat:@"%@でありますか。格好良い名前です！", _name];
        }
    } else if (_story == 6) {
        [self messageNode].message = @"訳ありでございますか。失礼しましたであります！";
    } else if (_story == 7) {
        [self messageNode].message = @"呼ぶ名がないと不便なので、とりあえずイケメンと呼ばせてもらうであります！";
    } else if (_story == 8) {
        [self messageNode].message = @"この調子でいくつか質問させてもらうであります。これらの返答で初期パラメーターが決まるらしいので気をつけてください。";
    } else if (_story == 9) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"質問2"
                                                            message:@"大佐のジョブはなんでありますか？"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"勇者だぜ", @"戦士だよ", @"魔法使いです", @"盗賊だ",@"遊び人っす", nil];
        alertView.tag = QUESTION_JOB;
        [alertView show];
        _story = 10;
    } else if (_story == 11) {
        [self messageNode].message = @"なんと！　自ら勇者を名乗るとはかなりの大物であります！";
    } else if (_story == 12) {
        [self messageNode].message = @"脳筋の戦士……大佐は体育会系でございましたか。その優れた攻撃力と防御力は是非見習いたいであります！";
    } else if (_story == 13) {
        [self messageNode].message = @"魔法を使えるとは格好良いであります！　このゲームでは魔法が凄く強いですもんね。";
    } else if (_story == 14) {
        [self messageNode].message = @"大佐にもそんな時期があったんでありますね。いよっ、色男。";
    } else if (_story == 15) {
        [self messageNode].message = @"……堂々と犯罪者自慢なんかして、逮捕されても知らないですよ。";
    } else if (_story == 18) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"質問3" message:@"入隊の目的は？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"酒代を稼ぐため", @"復讐のため", @"修行のため", @"世界平和のため", nil];
        alertView.tag = QUESTION_IMPORTANT;
        [alertView show];
        _story = 19;
    } else if (_story == 20) {
        [self messageNode].message = @"気が合うであります！　こんど一杯飲もうであります。";
    } else if (_story == 21) {
        [self messageNode].message = @"けどウェーイ！とかそういうノリは苦手なので静かに飲みましょう！";
    } else if (_story == 22) {
        [self messageNode].message = @"復讐ですか……悲しい戦いも早く終わると良いですね。";
    } else if (_story == 23) {
        [self messageNode].message = @"修行でありますか……目指せLV99ですね。";
    } else if (_story == 24) {
        if([_job isEqualToString:@"盗賊"]){
            [self messageNode].message = @"盗賊なのに界平和を目指すとは……義賊でありますね。格好良いっす！";
        } else {
            [self messageNode].message = @"立派であります！　ちょっとうさん臭いけど立派であります！";
        }
    } else if (_story == 99) {
        [self messageNode].message = [NSString stringWithFormat:@"質問は以上であります！　話を聞く限り大佐のパラメーターは次の通りでありますね。"];
    } else if (_story == 500){
        [self messageNode].message = @"こちらがあなた様の究極ステータスであります！";
    }
}

@end