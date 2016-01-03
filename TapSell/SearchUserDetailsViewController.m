//
//  SearchUserDetailsViewController.m
//  TapSell
//
//  Created by Thanapat Tangsittiprasert on 1/2/16.
//  Copyright © 2016 Shu Zhang. All rights reserved.
//

#import "SearchUserDetailsViewController.h"
#import <Parse.h>
@interface SearchUserDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblEmailID;

@end

@implementation SearchUserDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self imageViewDisplay];
    [self reloadUserProfile];
     NSLog(@"Here is user ID in SearchDetailViewCOntroller %@", self.postListDataSUDV.userID);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)imageViewDisplay
{
    self.userProfileImageView.layer.cornerRadius = self.userProfileImageView.frame.size.width/2;
    self.userProfileImageView.clipsToBounds = YES;
    self.userProfileImageView.layer.masksToBounds = self.userProfileImageView.layer.borderWidth = 8.0f;
    self.userProfileImageView.layer.borderColor = [UIColor colorWithRed:0.168f green:0.200f blue: 0.219f alpha:0.3f].CGColor;
}
-(void)reloadUserProfile
{
    NSString * objectID= self.postListDataSUDV.userID;
    PFQuery * query = [PFQuery queryWithClassName:@"User"];
    [query whereKey:@"objectId" equalTo: objectID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *  objects, NSError *  error) {
        if (!error) {
            NSLog(@"ObjectID is %lu", (unsigned long)objects.count);
            if ([objects count]==0) {
                NSLog(@"Data not found");
                UIAlertController * alcont = [UIAlertController alertControllerWithTitle:@"Sorry!!" message:@"User is no longer exist in the system" preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction * ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } ];
                [alcont addAction:ok];
                [self presentViewController:alcont animated:YES completion:nil];
                NSLog(@"NO object in array");
            }
            else
                
            {

            for (PFObject * object in objects)
            {
                // retreive data
                NSString * firstName = [object objectForKey:@"UserFirstName"];
                NSString * lastname = [object objectForKey:@"UserLastName"];
                NSString * emailID = [object objectForKey:@"EmailID"];
               
                NSString * city = [object objectForKey:@"City"];
                               NSString * phone = [object objectForKey:@"Phone"];
                PFFile *pictureFile = [object objectForKey:@"UserProfileImage"];
                [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (!error){
                        [self.userProfileImageView setImage:[UIImage imageWithData:data]];
                    }}];
                
                _lblName.text = [NSString stringWithFormat:@"%@  %@",firstName,lastname];
                _lblLocation.text = city;
                _lblPhone.text=phone;
                _lblEmailID.text = emailID;
            }
        }
        }
        else
            NSLog(@"Canno load data");
    }];
}

@end
