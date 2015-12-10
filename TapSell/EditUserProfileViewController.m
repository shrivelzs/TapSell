//
//  EditUserProfileViewController.m
//  TapSell
//
//  Created by Thanapat Tangsittiprasert on 12/9/15.
//  Copyright © 2015 Shu Zhang. All rights reserved.
//

#import "EditUserProfileViewController.h"
#import <Parse.h>


@interface EditUserProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *editUserProfileImageView;
@property (weak, nonatomic) IBOutlet UITextField *txtEditFname;
@property (weak, nonatomic) IBOutlet UITextField *txtEditLname;
@property (weak, nonatomic) IBOutlet UITextField *txtEdtiAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtEdtiApt;
@property (weak, nonatomic) IBOutlet UITextField *txtEditCity;

@property (weak, nonatomic) IBOutlet UITextField *txtEdtiState;
@property (weak, nonatomic) IBOutlet UITextField *txtEditZipcode;
@property (weak, nonatomic) IBOutlet UITextField *txtEditPhone;
@property(nonatomic,strong)NSString*objectiID;

@end

@implementation EditUserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self imageViewDisplay];
    [self retrieveUserDataFromUserProfile];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)retrieveUserDataFromUserProfile
{
    self.editUserProfileImageView.image = self.userDataObjEUP.userProfileImage;
    self.txtEditFname.text = self.userDataObjEUP.fname;
    self.txtEditLname.text = self.userDataObjEUP.lname;
    self.txtEdtiAddress.text = self.userDataObjEUP.address;
    self.txtEdtiApt.text = self.userDataObjEUP.aptNo;
    self.txtEditCity.text = self.userDataObjEUP.city;
    self.txtEdtiState.text = self.userDataObjEUP.state;
    self.txtEditZipcode.text = self.userDataObjEUP.zipcode;
     self.txtEditPhone.text = self.userDataObjEUP.phone;
    self.objectiID  = self.userDataObjEUP.objectID;
}
- (IBAction)btnSave:(id)sender {
    PFQuery * query = [PFQuery queryWithClassName:@"User"];
    [query getObjectInBackgroundWithId:self.objectiID block:^(PFObject *  object, NSError *  error) {
        if (!error)
        {
         object[@"UserProfileImage"]= self.editUserProfileImageView.image;
        object[@"UserFirstName"]=self.txtEditFname.text;
        object[@"UserLastName"]=self.txtEditLname.text;
        object[@"Address"]=self.txtEdtiAddress.text;
        object[@"AptNo"]=self.txtEdtiApt.text;
        object[@"City"]=self.txtEditCity.text;
        object[@"State"]=self.txtEdtiState.text;
        object[@"Zipcode"]=self.txtEditZipcode.text;
        object[@"Phone"]= self.txtEditPhone.text;
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *  error) {
            if (succeeded) {
                [self displayAlertView:@"Data Updated"];
             [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
            else
            {
                [self displayAlertView:@"Cannot updata user data. Please try again"];
                NSLog(@"Cannot updata user data");
            }
        }];
        }
        else
        {
            [self displayAlertView:@"Cannot get data from server. Please try again"];
            NSLog(@"Cannot get data from server");

        }
    }];
}

 -(void)imageViewDisplay
{
    self.editUserProfileImageView.layer.cornerRadius = self.editUserProfileImageView.frame.size.width/2;
    self.editUserProfileImageView.clipsToBounds = YES;
    self.editUserProfileImageView.layer.masksToBounds =YES;
    self.editUserProfileImageView.layer.borderWidth = 8.0f;
    self.editUserProfileImageView.layer.borderColor = [UIColor colorWithRed:0.168f green:0.200f blue: 0.219f alpha:0.3f].CGColor;
    
}



#pragma mark Validation
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
       // check phone number 10 digits
    if ([textField isEqual:self.txtEditPhone])
    {
        if (self.txtEditPhone.text.length<10) {
            [self displayAlertView:@"Enter 10 digit phone number"];
            return NO;
        }
    }
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:self.txtEditPhone])
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
    if ([textField isEqual:self.txtEditZipcode])
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 5;
    }
    
    if ([textField isEqual:self.txtEdtiState])
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        
        return newLength <= 2;
    }
    return YES;
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
