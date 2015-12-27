//
//  UserDetailViewController.m
//  TapSell
//
//  Created by Shu Zhang on 12/24/15.
//  Copyright © 2015 Shu Zhang. All rights reserved.
//

#import "UserDetailViewController.h"

@interface UserDetailViewController ()


@end

@implementation UserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    // Do any additional setup after loading the view.
    NSString *Username = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserNum"];
    self.UserName.text = Username;
    NSLog(@"ID:%@",Username);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
