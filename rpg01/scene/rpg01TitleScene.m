#import "rpg01TitleScene.h"
#import "SKMessageNode.h"

static const CGFloat MARGIN = 100.0f;
static const CGFloat DELAY = 5.0f;

@implementation rpg01TitleScene

- (void)createSceneContents {
    // タイトル
    SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    titleLabel.fontSize = 20.0f;
    titleLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + MARGIN);
    titleLabel.verticalAlignmentMode =SKLabelVerticalAlignmentModeBottom;

    // 副題
    SKLabelNode *subTitleLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    subTitleLabel.fontSize = FONT_SIZE;
    subTitleLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + MARGIN - 40.0f);
    subTitleLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeBottom;
    
    SKMessageNode *message = [[SKMessageNode alloc] initWithNoBox:CGSizeMake(self.size.width, self.size.height * 0.3f)];
    [self addChild:message];

    if([_params[@"story"] isEqualToString:@"chapter1"]){
        titleLabel.text = @"真の勇者とは何か……";
        [self messageNode].message = @"時は20XX年。人々はモンスターの脅威にさらされていた。";
        [self performSelector:@selector(nextSceneFromChapter1) withObject:nil afterDelay:5.0f];
    } else if([_params[@"story"] isEqualToString:@"1"]){
        titleLabel.text = @"ステージ１　恐怖のスライム軍";
        subTitleLabel.text = @"クリア条件：20秒間町を守る";
        [self messageNode].message = @"タップをすればそこに主人公が移動する。剣マークをタップして攻撃してスライムを倒すべし！";
        [self performSelector:@selector(nextScene) withObject:nil afterDelay:DELAY];
    } else if([_params[@"story"] isEqualToString:@"2"]){
        titleLabel.text = @"ステージ２　ションボリした霊";
        subTitleLabel.text = @"クリア条件：30秒町を守る";
        [self messageNode].message = @"MPを消費して魔法を唱えるべし。剣攻撃を当てればMPが回復する。";
        [self performSelector:@selector(nextScene) withObject:nil afterDelay:DELAY];
    } else if([_params[@"story"] isEqualToString:@"3"]){
        titleLabel.text = @"ステージ3　骸とのダンス";
        subTitleLabel.text = @"クリア条件：30秒町を守る";
        [self messageNode].message = @"剣攻撃は（1〜力）のダメージ。魔法は魔力の固定ダメージ";
        [self performSelector:@selector(nextScene) withObject:nil afterDelay:DELAY];
    } else if([_params[@"story"] isEqualToString:@"4"]){
        titleLabel.text = @"ステージ4　竜っぽい敵";
        subTitleLabel.text = @"クリア条件：30秒町を守る";
        [self messageNode].message = @"剣攻撃は（1〜力）のダメージ。魔法は魔力の固定ダメージ";
        [self performSelector:@selector(nextScene) withObject:nil afterDelay:DELAY];
    } else if([_params[@"story"] isEqualToString:@"5"]){
        titleLabel.text = @"ステージ５　ネコ踏まれちゃった";
        subTitleLabel.text = @"クリア条件：30秒町を守る";
        [self messageNode].message = @"体を張って町を守るべし";
        [self performSelector:@selector(nextScene) withObject:nil afterDelay:DELAY];
    } else if([_params[@"story"] isEqualToString:@"6"]){
        titleLabel.text = @"ステージ６　ここから本番";
        subTitleLabel.text = @"クリア条件：40秒町を守る";
        [self messageNode].message = @"きつくなったら前ステージに戻って経験値を溜めるべし";
        [self performSelector:@selector(nextScene) withObject:nil afterDelay:DELAY];
    } else if([_params[@"story"] isEqualToString:@"7"]){
        titleLabel.text = @"ステージ7　";
        subTitleLabel.text = @"クリア条件：40秒町を守る";
        [self messageNode].message = @"自信が付いたならラスボスに挑もう";
        [self performSelector:@selector(nextScene) withObject:nil afterDelay:DELAY];
    } else if([_params[@"story"] isEqualToString:@"8"]){
        titleLabel.text = @"ステージ8　ネコタウン";
        subTitleLabel.text = @"クリア条件：40秒町を守る";
        [self messageNode].message = @"人海戦術の恐ろしさよ……";
        [self performSelector:@selector(nextScene) withObject:nil afterDelay:DELAY];
    } else if([_params[@"story"] isEqualToString:@"9"]){
        titleLabel.text = @"ステージ9　ゴーレム";
        subTitleLabel.text = @"クリア条件：40秒町を守る";
        [self messageNode].message = @"ゴーレムは高HP。さらに魔法しか効かない。";
        [self performSelector:@selector(nextScene) withObject:nil afterDelay:DELAY];
    } else if([_params[@"story"] isEqualToString:@"10"]){
        titleLabel.text = @"ステージ10　真のスライム";
        subTitleLabel.text = @"クリア条件：45秒町を守る";
        [self messageNode].message = @"とにかく頑張れ";
        [self performSelector:@selector(nextScene) withObject:nil afterDelay:DELAY];
    } else if([_params[@"story"] isEqualToString:@"11"]){
        titleLabel.text = @"ステージ11　光と影";
        subTitleLabel.text = @"クリア条件：45秒町を守る";
        [self messageNode].message = @"動きが速い上に魔法しか効かない強敵";
        [self performSelector:@selector(nextScene) withObject:nil afterDelay:DELAY];
    } else if([_params[@"story"] isEqualToString:@"12"]){
        titleLabel.text = @"ステージ12　ラスト骸骨";
        subTitleLabel.text = @"クリア条件：60秒町を守る";
        [self messageNode].message = @"プロの領域";
        [self performSelector:@selector(nextScene) withObject:nil afterDelay:DELAY];
    } else if([_params[@"story"] isEqualToString:@"13"]){
        titleLabel.text = @"ステージ13　最終訓練";
        subTitleLabel.text = @"クリア条件：60秒町を守る";
        [self messageNode].message = @"プロの領域　その２";
        [self performSelector:@selector(nextScene) withObject:nil afterDelay:DELAY];
    } else if([_params[@"story"] isEqualToString:@"99"]){
        titleLabel.text = @"最終ステージ　愛に全てを";
        subTitleLabel.text = @"クリア条件：88秒町を守る";
        [self messageNode].message = @"レベルを上げまくればきっとなんとかなる";
        [self performSelector:@selector(nextScene) withObject:nil afterDelay:DELAY];
    }

    [self addChild:titleLabel];
    [self addChild:subTitleLabel];
}

- (SKMessageNode *)messageNode {
    return (SKMessageNode *)[self childNodeWithName:kMessageName];
}

- (void)nextSceneFromChapter1{
    [self loadSceneWithParam:@"input" params:_params];
}

- (void)nextScene{
    [self loadSceneWithParam:@"play" params:_params];
}



@end
