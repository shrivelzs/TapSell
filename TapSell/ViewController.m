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
@interface ViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) NSMutableArray* array_userData;

@property (weak, nonatomic) IBOutlet UITextField *txtLoginUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtLoginPassword;
@property(nonatomic,strong)UserData * userDataObjectVC;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.txtLoginUserName becomeFirstResponder];
    //_array_userData = [NSMutableArray new];
    _userDataObjectVC = [[UserData alloc]init];
           // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnAction_Login:(id)sender {
 
    if ([self.txtLoginPassword.text isEqualToString:@""]||[self.txtLoginUserName.text isEqualToString:@""])
    {
        [self displayAlertView:@"Please enter username and password"];

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
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
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
                UIImage * userprofile = [object objectForKey:@"UserProfileImage"];
               
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
                _userDataObjectVC.userProfileImage = userprofile;
                
                NSLog(@"ObjectID is %@", objectID);
            }
            if (![objects count]==0) {
                dispatch_async(dispatch_get_main_queue(),^{
                    [self performSegueWithIdentifier:@"afterlogin" sender:self];
                });
                NSLog(@"Successfully retrieved: %@", objects);
                NSLog(@"%@",_userDataObjectVC.fname);

            }
            else
            {
                [self displayAlertView:@"Please enter valid emailID and password"];
            }
            
            

        }
        else
        {
            
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
            [self displayAlertView:errorString];
        }
    }];
    
}
- (IBAction)rememberMeActionSwitch:(id)sender
{
    /*
    UISwitch * s = [[UISwitch alloc]init];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    if ( s.on == YES )
    {
        NSString * username = self.txtLoginUserName.text;
        [defaults setObject:username forKey:@"username"];
        
        NSString * password = self.txtLoginPassword.text;
        [defaults setObject:password forKey:@"password"];
        [defaults synchronize];
        
        NSLog(@"Remember me success");
    }
    else
    {
        [defaults removeObjectForKey:@"username"];
        [defaults removeObjectForKey:@"password"];

    }
     */
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"afterlogin"])
    {
        UINavigationController * navController = (UINavigationController *)segue.destinationViewController;
        UserProfileViewController * user = (UserProfileViewController *)navController.topViewController;
        user.userDataObjectUP = self.userDataObjectVC;
        NSLog(@"%@  %@",user.userDataObjectUP.fname, self.userDataObjectVC.fname);
    }
}


#pragma mark UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.txtLoginUserName]) {
        BOOL status = [self validateEmailWithString:self.txtLoginUserName.text];
        if (!status)
        {
            [self displayAlertView:@"Enter Valied Email-ID"];
            return NO;
        }
    }
       return YES;
}



#pragma mark Custom Methods

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

-(void)displayAlertView:(NSString *)message
{
    UIAlertController *alertCont =[UIAlertController alertControllerWithTitle:@"Alert" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertCont addAction:okAction];
    [self presentViewController:alertCont animated:YES completion:nil];
    
}

@end



// NSString * username = self.txtLoginUserName.text;
// NSString * password = self.txtLoginPassword.text;

/*
 [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *  user, NSError *  error)
 {
 if (user)
 {           NSLog(@"Successfully logged in");
 [self retrieveDataFromParse];
 
 //[self performSegueWithIdentifier:@"Login" sender:self];
 
 }
 else
 {
 [self displayAlertView:@"Please Enter Valid Username and Password"];
 self.txtLoginUserName.text = @"";
 self.txtLoginPassword.text =@"";
 NSLog(@"Cannot login");
 
 }
 }];*/
