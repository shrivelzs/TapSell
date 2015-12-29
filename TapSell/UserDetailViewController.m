//
//  UserDetailViewController.m
//  TapSell
//
//  Created by Shu Zhang on 12/24/15.
//  Copyright © 2015 Shu Zhang. All rights reserved.
//

#import "UserDetailViewController.h"
#import "UserItemsViewController.h"
#import <Parse.h>

@interface UserDetailViewController ()


@end

@implementation UserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self imageViewDisplay];
    [self reloadUserProfile];
    _userDataUserDetailVCObj=[[UserData alloc]init];
    
//    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Items Selling" style:UIBarButtonItemStylePlain target:self action:@selector(toUserItemsSelling)];
//    self.navigationItem.rightBarButtonItem = anotherButton;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(void)toUserItemsSelling{
//    [self performSegueWithIdentifier:@"ItemsSelling" sender:self];
//    
//}
//


-(void)imageViewDisplay
{
    self.UserPortrait.layer.cornerRadius = self.UserPortrait.frame.size.width/2;
    self.UserPortrait.clipsToBounds = YES;
    self.UserPortrait.layer.masksToBounds = self.UserPortrait.layer.borderWidth = 8.0f;
    self.UserPortrait.layer.borderColor = [UIColor colorWithRed:0.168f green:0.200f blue: 0.219f alpha:0.3f].CGColor;
}


-(void)reloadUserProfile
{
    NSString*userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserNum"];
    
    PFQuery * query = [PFQuery queryWithClassName:@"User"];
    [query whereKey:@"objectId" equalTo:userID];

    [query findObjectsInBackgroundWithBlock:^(NSArray *  objects, NSError *  error) {
        if (!error) {
            for (PFObject * object in objects)
            {
                // retreive data
                NSString * objectID = [object objectId];
                
                NSLog(@"Here is user ID %@ in UserDetailViewController", objectID);
                NSString * firstName = [object objectForKey:@"UserFirstName"];
                NSString * lastname = [object objectForKey:@"UserLastName"];
                NSString * emailID = [object objectForKey:@"EmailID"];
                PFFile *pictureFile = [object objectForKey:@"UserProfileImage"];
                [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (!error){
                        [self.UserPortrait setImage:[UIImage imageWithData:data]];
                        //_userDataObjectUP.userProfileImage = data;
                    }}];
                
                _userDataUserDetailVCObj.objectID = objectID;
                self.UserName.text = [NSString stringWithFormat:@"%@  %@",firstName,lastname];
                self.UserEmail.text = emailID;
            }
        }
        else
            NSLog(@"Canno load data");
    }];
}
- (IBAction)btnAction_PostList:(id)sender {
    if ([self.userDataUserDetailVCObj.objectID isEqualToString:@""]) {
    UIAlertController * alcont = [UIAlertController alertControllerWithTitle:@"Alert" message:@"No post for the user" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction * ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        } ];
        [alcont addAction:ok];
        [self presentViewController:alcont animated:YES completion:nil];
    }
    else{
    [self performSegueWithIdentifier:@"ItemsSelling" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ItemsSelling"])
    {
        UserItemsViewController * userItemObj = [[UserItemsViewController alloc]init];
        userItemObj = [segue destinationViewController];
        
        userItemObj.userDataUserItemObj = self.userDataUserDetailVCObj;
        NSLog(@"User ID userDataUserItemObj %@  User ID userDataUserDetailVCObj %@", userItemObj.userDataUserItemObj.objectID, self.userDataUserDetailVCObj.objectID);
    }
}

@end

