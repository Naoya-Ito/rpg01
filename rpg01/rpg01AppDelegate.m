#import "rpg01AppDelegate.h"
#import "rpg01ViewController.h"

@implementation rpg01AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self registerDefaults];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    rpg01ViewController *viewController = rpg01ViewController.new;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    _window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

- (void)registerDefaults {
    NSMutableDictionary *defaults = @{}.mutableCopy;
    defaults[@"username"] = @"主人公";

    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

@end
