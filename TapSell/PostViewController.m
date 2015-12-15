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
@interface PostViewController ()<UITextFieldDelegate>
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
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
