//
//  RegisterViewController.m
//  TapSell
//
//  Created by Thanapat Tangsittiprasert on 12/7/15.
//  Copyright © 2015 Shu Zhang. All rights reserved.
//

#import "RegisterViewController.h"
#import <Parse.h>
@interface RegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtFname;
@property (weak, nonatomic) IBOutlet UITextField *txtLname;
@property (weak, nonatomic) IBOutlet UITextField *txtEmailID;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtApt;
@property (weak, nonatomic) IBOutlet UITextField *txtCity;
@property (weak, nonatomic) IBOutlet UITextField *txtState;
@property (weak, nonatomic) IBOutlet UITextField *txtZipcode;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;


@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.txtFname becomeFirstResponder];
    self.btnRegister.enabled =FALSE;
   
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnAction_Register:(id)sender {
    
    PFObject * addUserData = [PFObject objectWithClassName:@"User"];
    
    //add data to parse
    [addUserData setObject:self.txtFname.text forKey:@"UserFirstName"];
    [addUserData setObject:self.txtLname.text forKey:@"UserLastName"];
    [addUserData setObject:self.txtEmailID.text forKey:@"EmailID"];
    [addUserData setObject:self.txtAddress.text forKey:@"Address"];
    [addUserData setObject:self.txtApt.text forKey:@"AptNo"];
    [addUserData setObject:self.txtCity.text forKey:@"City"];
    [addUserData setObject:self.txtState.text forKey:@"State"];
    [addUserData setObject:self.txtZipcode.text forKey:@"Zipcode"];
    [addUserData setObject:self.txtPhone.text forKey:@"Phone"];
    [addUserData setObject:self.txtPassword.text forKey:@"Password"];
    
    // save data back to parse
    [addUserData saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded)
        {
            
            UIAlertController *alcont =[UIAlertController alertControllerWithTitle:@"Congrats!" message:@"You are successfully registered" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
              {
                                           // dismiss screen and go back to first screen
                                           [self.navigationController dismissViewControllerAnimated:YES completion:nil];
               }];
            
            [alcont addAction:okButton];
            [self presentViewController:alcont animated:YES completion:nil];
     
            NSLog(@"Object Uploaded!");
            
        }
        else
        {
            [self displayAlertView:@"Pleast try again"];
            
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
        
    }];
   
}
- (IBAction)btnAction_Cancel:(id)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    

}
#pragma mark UITextField Delegate Methods

//dismiss keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



#pragma mark Validation
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    // validate email format
    if ([textField isEqual:self.txtEmailID])
    {
        BOOL status = [self validateEmailWithString:self.txtEmailID.text];
        if (!status)
        {
            [self displayAlertView:@"Enter Valied Email-ID"];
            return NO;
        }
        
    }
    // check phone number 10 digits
    if ([textField isEqual:self.txtPhone])
    {
        if (self.txtPhone.text.length<10) {
            [self displayAlertView:@"Enter 10 digit phone number"];
            return NO;
        }
    }
    if ([textField isEqual:self.txtPassword])
    {
        if (self.txtPassword.text.length<6) {
            [self displayAlertView:@"Password should be 6-15 digits"];
            return NO;
        }
    }


    return YES;
}

// limit character in textfield
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:self.txtPhone])
    {
        // Prevent crashing undo bug – see note below.
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 10;
    }
    
    // no more five digits for zipcode
    if ([textField isEqual:self.txtZipcode])
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 5;
    }
    
    if ([textField isEqual:self.txtState])
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        
        return newLength <= 2;
    }
    if([textField isEqual:self.txtPassword])
    {
        if (![textField.text isEqualToString:@""]) {
            self.btnRegister.enabled =true;
            
            NSUInteger newLength = [textField.text length] + [string length] - range.length;
            
            return newLength <= 15;

        }
    }
    
    return YES;
    
}


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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end







/*
 // make user name and password
 PFUser * user = [PFUser user];
 user.username = self.txtEmailID.text;
 user.password = self.txtPassword.text;
 [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
 if (!error)
 {
 */


/*  }
 else
 {
 //Something bad has occurred
 [self displayAlertView:@"Pleast try again"];
 NSLog(@"Cannot set username and password");
 }
 }];
 */

