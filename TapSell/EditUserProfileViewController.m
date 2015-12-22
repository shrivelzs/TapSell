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
    [self reloadUserProfile];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)reloadUserProfile
{
    NSString*username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString*password = [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
    NSLog(@"Username is %@", username);
    NSLog(@"Password is %@", password);
    PFQuery * query = [PFQuery queryWithClassName:@"User"];
    [query whereKey:@"EmailID" equalTo:username];
    [query whereKey:@"Password" equalTo:password];
    [query findObjectsInBackgroundWithBlock:^(NSArray *  objects, NSError *  error) {
        if (!error) {
            for (PFObject * object in objects)
            {
                // retreive data
                // NSString * objectID = [object objectId];
                NSString * firstName = [object objectForKey:@"UserFirstName"];
                NSString * lastname = [object objectForKey:@"UserLastName"];
                NSString * address = [object objectForKey:@"Address"];
                NSString * aptNo = [object objectForKey:@"AptNo"];
                NSString * city = [object objectForKey:@"City"];
                NSString * state = [object objectForKey:@"State"];
                NSString * zipcode = [object objectForKey:@"Zipcode"];
                NSString * phone = [object objectForKey:@"Phone"];
                PFFile *pictureFile = [object objectForKey:@"UserProfileImage"];
                [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (!error){
                        [self.editUserProfileImageView setImage:[UIImage imageWithData:data]];
                    }}];
                
                self.txtEditFname.text = firstName;
                self.txtEditLname.text = lastname;
                self.txtEdtiAddress.text = address;
                self.txtEdtiApt.text = aptNo;
                self.txtEditCity.text = city;
                self.txtEdtiState.text = state;
                self.txtEditZipcode.text = zipcode;
                self.txtEditPhone.text = phone;
            }
        }
        else
            NSLog(@"Canno load data");
    }];
}
- (IBAction)btnSave:(id)sender {
    if (_editUserProfileImageView.image == nil) {
        [self displayAlert:@"Please upload image"];
    }
    else if ([_txtEditCity.text isEqualToString:@" "])
    {
        [self displayAlert:@"Please enter city"];
    }
    else if ([_txtEditFname.text isEqualToString:@" "])
    {
        [self displayAlert:@"Please enter first name"];
    }
    
    else if ([_txtEditLname.text isEqualToString:@" "])
    {
        [self displayAlert:@"Please enter last name"];
    }
    
    else if ([_txtEditPhone.text isEqualToString:@" "])
    {
        [self displayAlert:@"Please enter phone number"];
    }
    
    else if ([_txtEditZipcode.text isEqualToString:@" "])
    {
        [self displayAlert:@"Please enter zipcode"];
    }
    
    else if ([_txtEdtiAddress.text isEqualToString:@" "])
    {
        [self displayAlert:@"Please enter address"];
    }
    
    else if ([_txtEdtiApt.text isEqualToString:@" "])
    {
        [self displayAlert:@"Please enter aprtment number"];
    }
    else if ([_txtEdtiState.text isEqualToString:@" "])
    {
        [self displayAlert:@"Please enter state"];
    }
    else
    {
        [self saveData];
    }
    
    
}

-(void)saveData
{
    NSString * objectID = [[NSUserDefaults standardUserDefaults] objectForKey:@"objectID"];
    PFObject *point = [PFObject objectWithoutDataWithClassName:@"User" objectId:objectID];
    NSLog(@"USID1:%@",objectID);
    
    NSData *imageData = UIImagePNGRepresentation(self.editUserProfileImageView.image);
    PFFile *file = [PFFile fileWithData:imageData];
    
    // Set a new value on quantity
    [point setObject:file forKey:@"UserProfileImage"];
    [point setObject:self.txtEditFname.text forKey:@"UserFirstName"];
    [point setObject: self.txtEditLname.text forKey:@"UserLastName"];
    [point setObject:self.txtEdtiAddress.text forKey:@"Address"];
    [point setObject:self.txtEdtiApt.text forKey:@"AptNo"];
    [point setObject: self.txtEditCity.text forKey:@"City"];
    [point setObject: self.txtEdtiState.text forKey:@"State"];
    [point setObject: self.txtEditZipcode.text forKey:@"Zipcode"];
    [point setObject: self.txtEditPhone.text forKey:@"Phone"];
    [point setObject: self.userLocation forKey:@"currentLocation"];
    
    //     NSLog(@"userLLLLNNNNew:%@",self.userLocation);
    //
    
    
    
    
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
- (IBAction)btnAction_UploadUserProfileImage:(id)sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    [self.tabBarController presentViewController:picker animated:YES completion:nil];
}

- (IBAction)btnAction_TakePhoto:(id)sender {
    
    UIImagePickerController *picker =[[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = YES;
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

#pragma mark Dismiss keyboard
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_txtEditCity resignFirstResponder];
    [_txtEditFname resignFirstResponder];
    [_txtEditLname resignFirstResponder];
    [_txtEditPhone resignFirstResponder];
    [_txtEditZipcode resignFirstResponder];
    [_txtEdtiAddress resignFirstResponder];
    [_txtEdtiApt resignFirstResponder];
    [_txtEdtiState resignFirstResponder];
}

#pragma mark TextField delegate
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

-(void)displayAlert:(NSString *)message
{
    UIAlertController * alcont = [UIAlertController alertControllerWithTitle:@"Alert" message:message preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    
    [alcont addAction:ok];
    [self presentViewController:alcont animated:YES completion:nil];
    
}

- (IBAction)updateLocation:(id)sender {
    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            NSLog(@"User is currently at %f, %f", geoPoint.latitude, geoPoint.longitude);
            
            [[PFUser currentUser] setObject:geoPoint forKey:@"currentLocation"];
            NSLog(@"User is %@", [PFUser currentUser]);
            [[PFUser currentUser] saveInBackground];
            
            self.userLocation = geoPoint;
            NSLog(@"GEO:%@",geoPoint);
            NSLog(@"userLLLL111111:%@",self.userLocation);
            //UIAlert
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Completed!"
                                                                           message:@"Your Location has been updated! Please press Save button to continue"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        else
        {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Failed!"
                                                                           message:@"Your locatio cannot be update now."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    }];
    
    
}




@end
