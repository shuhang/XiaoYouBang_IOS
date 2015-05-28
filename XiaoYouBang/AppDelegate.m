//
//  AppDelegate.m
//  XiaoYouBang
//
//  Created by shuhang on 15/4/14.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "Tab1ViewController.h"
#import "Tab2ViewController.h"
#import "Tab3ViewController.h"
#import "Tab4ViewController.h"
#import "Tool.h"
#import "MyDatabase.h"
#import "IQKeyboardManager.h"
#import "IQSegmentedNextPrevious.h"
#import "UMessage.h"
#import "NetWork.h"

@interface AppDelegate ()
{
    UIView * startView;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    ////umeng
    [UMessage startWithAppkey:@"5563da2467e58e2e6c001719" launchOptions:launchOptions];
    
    if( OSVersionIsAtLast8 )
    {
            UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
            action1.identifier = @"action1_identifier";
            action1.title=@"Accept";
            action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
            UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
            action2.identifier = @"action2_identifier";
            action2.title=@"Reject";
            action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
            action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
            action2.destructive = YES;
        
            UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
            categorys.identifier = @"category1";//这组动作的唯一标示
            [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
            UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                         categories:[NSSet setWithObject:categorys]];
            [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
    }
    else
    {
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
    
    [UMessage setAutoAlert:NO];
    [UMessage setLogEnabled:YES];
    //////////
    [[MyDatabase shareInstance] openDatabase];
    
    [[IQKeyboardManager sharedManager] setCanAdjustTextView:YES];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    MainViewController * mainController = [MainViewController new];
    
    Tab1ViewController * tab1 = [Tab1ViewController new];
    Tab2ViewController * tab2 = [Tab2ViewController new];
    Tab3ViewController * tab3 = [Tab3ViewController new];
    Tab4ViewController * tab4 = [Tab4ViewController new];
    
    UINavigationController * navigation1 = [[UINavigationController alloc] initWithRootViewController:tab1];
    UINavigationController * navigation2 = [[UINavigationController alloc] initWithRootViewController:tab2];
    UINavigationController * navigation3 = [[UINavigationController alloc] initWithRootViewController:tab3];
    UINavigationController * navigation4 = [[UINavigationController alloc] initWithRootViewController:tab4];

    mainController.controller = [UITabBarController new];
    [mainController.controller.tabBar setBackgroundColor:Bg_Red];
    [mainController.controller.view setFrame:mainController.view.frame];
    [mainController.view addSubview:mainController.controller.view];
     
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, Screen_Width, 50 )];
    [view setBackgroundColor:Bg_Red];
    [mainController.controller.tabBar insertSubview:view atIndex:1];
    
    mainController.controller.viewControllers = @[ navigation1, navigation2, navigation3, navigation4 ];
    [mainController setupTabbarItem];
    [mainController.controller setSelectedIndex:0];
    
    self.window.rootViewController = mainController;
    
    [self.window makeKeyAndVisible];
    
    [self setupStartView];
    
    return YES;
}

- ( void ) setupStartView
{
    startView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, Screen_Width, Screen_Height )];
    startView.backgroundColor = Bg_Red;
    
    UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake( 0, Screen_Height / 5, Screen_Width, 60 )];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"校友邦";
    label1.textColor = [UIColor whiteColor];
    label1.font = [UIFont systemFontOfSize:35];
    [startView addSubview:label1];
    
    UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake( 0, [Tool getBottom:label1] + Screen_Height / 10, Screen_Width, 25 )];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = @"与校友分享你的";
    label2.textColor = [UIColor whiteColor];
    label2.font = [UIFont systemFontOfSize:20];
    [startView addSubview:label2];
    
    UILabel * label3 = [[UILabel alloc] initWithFrame:CGRectMake( 0, [Tool getBottom:label2] + 10, Screen_Width, 25 )];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.text = @"智慧、资源与人脉";
    label3.textColor = [UIColor whiteColor];
    label3.font = [UIFont systemFontOfSize:20];
    [startView addSubview:label3];
    
    [self.window addSubview:startView];
    [self performSelector:@selector(removeStartView) withObject:nil afterDelay:3.0f];
}

- ( void ) removeStartView
{
    [startView removeFromSuperview];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[MyDatabase shareInstance] closeDatabase];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UMessage didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];
    
    NSString * device = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                          stringByReplacingOccurrencesOfString: @">" withString: @""]
                         stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    __block NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * token = [userDefaults objectForKey:@"token"];
    if( token && ![userDefaults boolForKey:@"has_upload_device"] )
    {
        NSString * url = [NSString stringWithFormat:@"api/user/%@/device", [userDefaults objectForKey:@"userId"]];
        NSMutableDictionary * request = [NSMutableDictionary dictionary];
        [request setValue:token forKey:@"token"];
        [request setValue:device forKey:@"device"];
        [[NetWork shareInstance] httpRequestWithGet:url params:request success:^(NSDictionary * result)
         {
             NSNumber * code = [result objectForKey:@"result"];
             if( [code intValue] == 1000 )
             {
                 [userDefaults setBool:YES forKey:@"has_upload_device"];
                 [userDefaults synchronize];
                 
                 NSLog( @"upload device success" );
             }
         }
         error:^(NSError * error)
         {
             NSLog( @"%@", error );
         }];
    }
    else
    {
        [userDefaults setObject:device forKey:@"device"];
        [userDefaults synchronize];
    }
}

- ( void ) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"Failed to get token, error:%@", error_str);
}

@end
