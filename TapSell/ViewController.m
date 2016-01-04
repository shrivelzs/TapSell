//
//  ViewController.m
//  TapSell
//
//  Created by Shu Zhang on 12/7/15.
//  Copyright © 2015 Shu Zhang. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import "UserData.h"
#import "UserProfileViewController.h"
#import "PostListViewController.h"
#import "RegisterViewController.h"
#import "MBProgressHUD.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtLoginUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtLoginPassword;
@property (weak, nonatomic) IBOutlet UISwitch *rememberMe;
@property(nonatomic,strong)UserData * userDataObjectVC;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.txtLoginUserName becomeFirstResponder];
    _userDataObjectVC = [[UserData alloc]init];
    _rememberMe.transform = CGAffineTransformMakeScale(0.75, 0.75);
   
//    [self rememberMe:self];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)btnAction_Login:(id)sender {
 
    if ([_txtLoginUserName.text isEqualToString:@" "]||[_txtLoginPassword.text isEqualToString:@""]) {
        
        NSLog(@"Please enter username and password");
        UIAlertController * alcont = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Pelase enter username and password" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction * ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alcont addAction:ok];
        [self presentViewController:alcont animated:YES completion:nil];
    }
    else
    {
        MBProgressHUD * ac = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        ac.labelText=@"Retrieving";
        ac.detailsLabelText = @"User Data";
        ac.mode = MBProgressHUDModeAnnularDeterminate;

        [self retrieveDataFromParse];
    }
}

-(void)retrieveDataFromParse
{
    //retrive userdata and show in main menu
    NSString * username = _txtLoginUserName.text;
    NSString * password = _txtLoginPassword.text;
    PFQuery * query =[PFQuery queryWithClassName:@"User"];
    [query whereKey:@"EmailID" equalTo:username];
    [query whereKey:@"Password" equalTo:password];
    [query findObjectsInBackgroundWithBlock:^( NSArray * objects, NSError *error) {
        if (!error)
        {
                NSLog(@"ObjectID is %lu", (unsigned long)objects.count);
            if ([objects count]==0) {
                NSLog(@"Enter Valied Email ID. Your Emailid is not registered. Please register");
                UIAlertController * alcont = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Enter Valied Email ID. Your Emailid is not registered. Please register" preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction * ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    _txtLoginPassword.text =@"";
                    _txtLoginUserName.text =@"";
                    [MBProgressHUD hideHUDForView:self.view animated:YES];

                } ];
                [alcont addAction:ok];
                [self presentViewController:alcont animated:YES completion:nil];
                NSLog(@"NO object in array");
                }
            else
                
            {
                for (PFObject * object in objects)
                {
                // retreive data
                NSString * objectID = [object objectId];
                    NSString * emailID = [object objectForKey:@"EmailID"];
                    NSString * pass = [object objectForKey:@"Password"];

                //User login to make [PFUser currentUser] not be nil
                [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * _Nullable user, NSError * _Nullable error) {
                    
                }];
                _userDataObjectVC.objectID =objectID;
                _userDataObjectVC.emailID =emailID;
                _userDataObjectVC.password =pass;
                    
                [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
                [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
                [[NSUserDefaults standardUserDefaults] setObject:objectID forKey:@"objectID"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                NSLog(@"%@", self.userDataObjectVC.userProfileImage);
                NSLog(@"ObjectID is %@", objectID);
                }
            NSLog(@"Successfully retrieved: %@", objects);
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            [self performSegueWithIdentifier:@"afterlogin" sender:self];
            }
            
            }
        else
        {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
    }];

}
//- (void)rememberMe:(id)sender {
//    if (_rememberMe.on != YES) {
//        NSLog(@"Switch is OFF!!");
//        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"username"];
//        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"password"];
//        _txtLoginPassword.text =@"";
//        _txtLoginUserName.text =@"";
//    }
//    else {
//        NSLog(@"Switch is ON!!");
//        [[NSUserDefaults standardUserDefaults] setObject:_txtLoginUserName.text forKey:@"username"];
//        [[NSUserDefaults standardUserDefaults] setObject:_txtLoginPassword.text forKey:@"password"];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//        _txtLoginUserName.text =[[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
//        _txtLoginPassword.text =[[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
//    }
//
//}
//
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   
    if ([[segue identifier] isEqualToString:@"afterlogin"])
    {
        UITabBarController * tabbar = segue.destinationViewController;
        
        // passing data to PostList tabbar
       UINavigationController * navControllerPL = (UINavigationController *)[[tabbar viewControllers]objectAtIndex:1];
         PostListViewController * postList = (PostListViewController *)[[navControllerPL viewControllers]objectAtIndex:0];
        postList.userDataObjPL = self.userDataObjectVC;

        
        // passing data to userprofile tabbar
        UINavigationController * navControllerUP = (UINavigationController *)[[tabbar viewControllers]objectAtIndex:3];
        UserProfileViewController * user = (UserProfileViewController *)[[navControllerUP viewControllers]objectAtIndex:0];
        user.userDataObjectUP = self.userDataObjectVC;
       NSLog(@"entered login screen");
    }
    else if([segue.identifier isEqualToString:@"register"]){
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        NSLog(@"entered signup screen");
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
   [_txtLoginPassword resignFirstResponder];
    [_txtLoginUserName resignFirstResponder];
}

@end

