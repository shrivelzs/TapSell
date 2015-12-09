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
@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtEmailID;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (nonatomic,strong) NSMutableArray* array_userData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.txtEmailID becomeFirstResponder];
    _array_userData = [NSMutableArray new];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnAction_Login:(id)sender {
    
    [PFUser logInWithUsernameInBackground:self.txtEmailID.text password:self.txtPassword.text block:^(PFUser *  user, NSError *  error)
     {
        if (user)
        {
            [self retrieveDataFromParse];
            [self performSegueWithIdentifier:@"Login" sender:self];

        }
        else
        {
            [self displayAlertView:@"Please Enter Valid Username and Password"];
            self.txtEmailID.text = @"";
            self.txtPassword.text =@"";
            NSLog(@"Cannot login");
            
        }
    }];
}

-(void)retrieveDataFromParse
{
    //retrive userdata and show in main menu
    PFQuery * query =[PFQuery queryWithClassName:@"UserData"];
    [query whereKey:@"EmailID" equalTo:self.txtEmailID];
    [query whereKey:@"Password" equalTo:self.txtPassword];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            for (PFObject *object in objects)
            {
                // retreive data
                NSString * firstName = [object objectForKey:@"UserFirstName"];
                NSString * lastname = [object objectForKey:@"UserLastName"];
                NSString * emailID = [object objectForKey:@"EmailID"];
                NSString * address = [object objectForKey:@"Address"];
                NSString * aptNo = [object objectForKey:@"AptNo"];
                NSString * city = [object objectForKey:@"City"];
                NSString * state = [object objectForKey:@"State"];
                NSString * zipcode = [object objectForKey:@"Zipcode"];
                NSString * phone = [object objectForKey:@"Password"];
                
                
                //put it in array
                UserData * userData = [[UserData alloc]init];
                userData.fname = firstName;
                userData.lname = lastname;
                userData.emailID = emailID;
                userData.address = address;
                userData.aptNo = aptNo;
                userData.city = city;
                userData.state = state;
                userData.zipcode =zipcode;
                userData.phone = phone;
                
                [self.array_userData addObject:userData];
            }
            NSLog(@"Successfully retrieved: %@", objects);
        }
        else
        {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
    }];
    
}
- (IBAction)actionSwitch:(id)sender {
    UISwitch * s = [[UISwitch alloc]init];
    
    if (s isOn) {
        statements
    }
    else
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

#pragma mark UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.txtEmailID]) {
        BOOL status = [self validateEmailWithString:self.txtEmailID.text];
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
