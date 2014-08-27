#import "rpg01ViewController.h"
#import "rpg01OpeningScene.h"
#import "rpg01PlayScene.h"

@implementation rpg01ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // ナビゲーションバーは使わない
    self.navigationController.navigationBarHidden = YES;
    
    CGRect frame = self.view.bounds;
    SKView *skView = [[SKView alloc] initWithFrame:frame];
    [self.view addSubview:skView];
    
    // デバッグモード
#ifdef DEBUG
    
    skView.showsDrawCount = YES;
    skView.showsNodeCount = YES;
    skView.showsFPS = YES;
    skView.showsPhysics = YES;
#endif
    
    // オープニングのシーンを表示
    Class sceneClass = NSClassFromString(@"rpg01OpeningScene");
    CGSize size = self.view.bounds.size;
    SKScene *scene = [sceneClass sceneWithSize:size];
    scene.scaleMode = SKSceneScaleModeAspectFit;
    
    [skView presentScene:scene];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
