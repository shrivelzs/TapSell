//
//  EditUserProfileViewController.m
//  TapSell
//
//  Created by Thanapat Tangsittiprasert on 12/9/15.
//  Copyright © 2015 Shu Zhang. All rights reserved.
//

#import "EditUserProfileViewController.h"
#import <Parse.h>


@interface EditUserProfileViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *editUserProfileImageView;
@property (weak, nonatomic) IBOutlet UITextField *txtEditFname;
@property (weak, nonatomic) IBOutlet UITextField *txtEditLname;
@property (weak, nonatomic) IBOutlet UITextField *txtEdtiAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtEdtiApt;
@property (weak, nonatomic) IBOutlet UITextField *txtEditCity;
@property (weak, nonatomic) IBOutlet UITextField *txtEdtiState;
@property (weak, nonatomic) IBOutlet UITextField *txtEditZipcode;
@property (weak, nonatomic) IBOutlet UITextField *txtEditPhone;
@property(strong,nonatomic)NSString *objectID;
@end

@implementation EditUserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self imageViewDisplay];
    [self retrieveUserDataFromUserProfile];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)retrieveUserDataFromUserProfile
{
    //self.editUserProfileImageView.image = self.userDataObjEUP.userProfileImage;
    self.txtEditFname.text = self.userDataObjEUP.fname;
    self.txtEditLname.text = self.userDataObjEUP.lname;
    self.txtEdtiAddress.text = self.userDataObjEUP.address;
    self.txtEdtiApt.text = self.userDataObjEUP.aptNo;
    self.txtEditCity.text = self.userDataObjEUP.city;
    self.txtEdtiState.text = self.userDataObjEUP.state;
    self.txtEditZipcode.text = self.userDataObjEUP.zipcode;
    self.txtEditPhone.text = self.userDataObjEUP.phone;
    self.objectID = self.userDataObjEUP.objectID;
    NSLog(@"%@",self.userDataObjEUP.objectID);
}
- (IBAction)btnSave:(id)sender {
    
    PFObject *point = [PFObject objectWithoutDataWithClassName:@"User" objectId:self.objectID];
   // NSData *imageData = UIImagePNGRepresentation(self.editUserProfileImageView.image);
    //PFFile *file = [PFFile fileWithData:imageData];
    
    // Set a new value on quantity
    //[point setObject:file forKey:@"UserProfileImage"];
    [point setObject:self.txtEditFname.text forKey:@"UserFirstName"];
    [point setObject: self.txtEditLname.text forKey:@"UserLastName"];
    [point setObject:self.txtEdtiAddress.text forKey:@"Address"];
    [point setObject:self.txtEdtiApt.text forKey:@"AptNo"];
    [point setObject: self.txtEditCity.text forKey:@"City"];
    [point setObject: self.txtEdtiState.text forKey:@"State"];
    [point setObject: self.txtEditZipcode.text forKey:@"Zipcode"];
    [point setObject: self.txtEditPhone.text forKey:@"Phone"];
    [point saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!error) {
            UIAlertController *alcont =[UIAlertController alertControllerWithTitle:@"Completed!" message:@"User profile has been updated" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                       {
                                           [self.navigationController popToRootViewControllerAnimated:YES];
                                           
                                       }];
            
            [alcont addAction:okButton];
            [self presentViewController:alcont animated:YES completion:nil];

        }
        else
        {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
            NSLog(@"Cannot update data");
            [self displayAlertView:errorString];
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

#pragma mark UserProfilePhoto
- (IBAction)btnAction_UploadProfileImage:(id)sender{
    UIImagePickerController *picker =[[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    [self presentViewController:picker animated:YES completion:nil];

}
- (IBAction)btnAction_TakePhoto:(id)sender {
    
    UIImagePickerController *picker =[[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:nil];

}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *chooseimage = info[UIImagePickerControllerEditedImage];
    self.editUserProfileImageView.image = chooseimage;
    UIImageWriteToSavedPhotosAlbum(chooseimage, nil, nil, nil);
    [picker dismissViewControllerAnimated:YES completion:nil];
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

@end
