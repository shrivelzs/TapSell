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
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtLoginUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtLoginPassword;
@property(nonatomic,strong)UserData * userDataObjectVC;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.txtLoginUserName becomeFirstResponder];
    _userDataObjectVC = [[UserData alloc]init];
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
                UIAlertAction * ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
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
                NSString * firstName = [object objectForKey:@"UserFirstName"];
                NSString * lastname = [object objectForKey:@"UserLastName"];
                NSString * emailID = [object objectForKey:@"EmailID"];
                NSString * address = [object objectForKey:@"Address"];
                NSString * aptNo = [object objectForKey:@"AptNo"];
                NSString * city = [object objectForKey:@"City"];
                NSString * state = [object objectForKey:@"State"];
                NSString * zipcode = [object objectForKey:@"Zipcode"];
                NSString * phone = [object objectForKey:@"Phone"];
                PFFile *pictureFile = [object objectForKey:@"UserProfileImage"];
                    [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                        if (!error){
                            _userDataObjectVC.userProfileImage = data;
                        }}];
                _userDataObjectVC.objectID = objectID;
                _userDataObjectVC.fname = firstName;
                _userDataObjectVC.lname = lastname;
                _userDataObjectVC.emailID = emailID;
                _userDataObjectVC.address = address;
                _userDataObjectVC.aptNo = aptNo;
                _userDataObjectVC.city = city;
                _userDataObjectVC.state = state;
                _userDataObjectVC.zipcode =zipcode;
                _userDataObjectVC.phone = phone;
                
                NSLog(@"%@", self.userDataObjectVC.userProfileImage);
                NSLog(@"ObjectID is %@", objectID);
                }
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
- (IBAction)rememberMeActionSwitch:(id)sender
{
//    
//    UISwitch * s = [[UISwitch alloc]init];
//    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//
//    if(s.on == YES)
//    {
//         NSString* username = _txtLoginUserName.text;
//        [defaults setObject:username forKey:@"username"];
//        
//        NSString *password = _txtLoginPassword.text;
//        [defaults setObject:password forKey:@"password"];
//        [defaults synchronize];
//    }
//    else
//    {   [defaults removeObjectForKey:@"username"];
//        [defaults removeObjectForKey:@"password"];
//        NSLog(@"Remember me off");
//    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   
    if ([[segue identifier] isEqualToString:@"afterlogin"])
    {
        UITabBarController * tabbar = segue.destinationViewController;
        
        // passing data to userprofile tabbar
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

//#pragma mark Custom Methods
//
//-(void)displayAlertView:(NSString *)message
//{
//   UIAlertController *alertCont =[UIAlertController alertControllerWithTitle:@"Alert" message:message preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//    [alertCont addAction:okAction];
//    [self.navigationController presentViewController:alertCont animated:YES completion:nil];
//}

@end

