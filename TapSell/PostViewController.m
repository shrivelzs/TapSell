//
//  PostViewController.m
//  TapSell
//
//  Created by Thanapat Tangsittiprasert on 12/14/15.
//  Copyright © 2015 Shu Zhang. All rights reserved.
//

#import "PostViewController.h"
#import "PostListViewController.h"
#import <Parse.h>
@interface PostViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtPrice;
@property (strong, nonatomic) IBOutlet UITextField *txtDiscription;

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.txtTitle becomeFirstResponder];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)SavePost:(id)sender {
    PFObject * addPost = [PFObject objectWithClassName:@"PostList"];
    
    //add data to parse
    // NSData *imageData = UIImagePNGRepresentation(self.editUserProfileImageView.image);
    //PFFile *file = [PFFile fileWithData:imageData];
    
    // Set a new value on quantity
    //[point setObject:file forKey:@"ProductImage"];
    [addPost setObject:self.txtTitle.text forKey:@"ProductTitle"];
    [addPost setObject:self.txtPrice.text forKey:@"ProductPrice"];
    [addPost setObject:self.txtDiscription.text forKey:@"Discription"];
    [addPost setObject:self.userDataObjAP.objectID forKey:@"UserID"];
    [addPost setObject:self.userDataObjAP.city forKey:@"Location"];
   
    
    // save data back to parse
    [addPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded)
        {
            
            UIAlertController *alcont =[UIAlertController alertControllerWithTitle:@"Congrats!" message:@"You are successfully created new post" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                       {
                                           [self.navigationController popToRootViewControllerAnimated:YES];
                                           
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

#pragma mark Camera

- (IBAction)btnAction_UploadProductImage:(id)sender{
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
    self.postImageView.image = chooseimage;
    UIImageWriteToSavedPhotosAlbum(chooseimage, nil, nil, nil);
    [picker dismissViewControllerAnimated:YES completion:nil];

}
#pragma mark UITextField Delegate Methods

//dismiss keyboard
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_txtDiscription resignFirstResponder];
    [_txtPrice resignFirstResponder];
    [_txtTitle resignFirstResponder];
}



#pragma mark Validation
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    if ([textField isEqual:self.txtTitle])
    {
        if ([self.txtTitle.text isEqualToString:@" "]) {
            [self displayAlertView:@"Please enter title"];
            return NO;
        }

    }
    
    if ([textField isEqual:self.txtPrice])
    {
        if ([self.txtPrice.text isEqualToString:@" "]) {
            [self displayAlertView:@"Please enter price"];
            return NO;
        }
        
    }
    
    if ([textField isEqual:self.txtDiscription])
    {
        if ([self.txtPrice.text isEqualToString:@" "]) {
            [self displayAlertView:@"Please enter description"];
            return NO;
        }
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
