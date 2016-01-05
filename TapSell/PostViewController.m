//
//  PostViewController.m
//  TapSell
//
//  Created by Thanapat Tangsittiprasert on 12/14/15.
//  Copyright © 2015 Shu Zhang. All rights reserved.
//

#import "PostViewController.h"
#import "PostListViewController.h"
#import "MBProgressHUD.h"
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
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)SavePost:(id)sender {
    if ([_txtDiscription.text isEqualToString:@""]||[_txtPrice.text isEqualToString:@""]||[_txtTitle.text isEqualToString:@""]) {
        UIAlertController * alcont = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Please enter details" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        
        [alcont addAction:ok];
        [self presentViewController:alcont animated:YES completion:nil];
    }
    else if (_postImageView.image == nil) {
        UIAlertController * alcont = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Please upload image" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        
        [alcont addAction:ok];
        [self presentViewController:alcont animated:YES completion:nil];
    }
    else
        [self saveData];
    NSLog(@"This is txtTitle file %@", _txtTitle.text);
    NSLog(@"This is txtPrice file %@", _txtPrice.text);
    NSLog(@"This is txtDiscription file %@", _txtDiscription.text);
    NSLog(@"This is userDataObjAP.objectID file %@", _userDataObjAP.objectID);
    NSLog(@"This is userDataObjAP.city file %@", _userDataObjAP.city);

}

-(void)saveData
{
    MBProgressHUD * ac = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    ac.labelText=@"Saving";
    ac.mode = MBProgressHUDModeAnnularDeterminate;

    PFObject * addPost = [PFObject objectWithClassName:@"PostList"];
    //add data to parse
    NSData *imageData = UIImagePNGRepresentation(self.postImageView.image);
    PFFile *file = [PFFile fileWithData:imageData];
    // Set a new value on quantity
    [addPost setObject:file forKey:@"ProductImage"];
    [addPost setObject:self.txtTitle.text forKey:@"ProductTitle"];
    [addPost setObject:self.txtPrice.text forKey:@"ProductPrice"];
    [addPost setObject:self.txtDiscription.text forKey:@"Discription"];
    [addPost setObject:self.userDataObjAP.objectID forKey:@"UserID"];
    [addPost setObject:self.userDataObjAP.city forKey:@"Location"];
    
       // save data back to parse
    [addPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];

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
            UIAlertController *alcont =[UIAlertController alertControllerWithTitle:@"Alert!" message:@"Please try again" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                       {
                                           [self.navigationController popToRootViewControllerAnimated:YES];
                                           
                                       }];
            
            [alcont addAction:okButton];
            [self presentViewController:alcont animated:YES completion:nil];
        }
    }];

}

#pragma mark Camera

- (IBAction)btnAction_UploadProductImage:(id)sender{
    UIImagePickerController *picker =[[UIImagePickerController alloc]init];
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

@end
