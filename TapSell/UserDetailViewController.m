//
//  UserDetailViewController.m
//  TapSell
//
//  Created by Shu Zhang on 12/24/15.
//  Copyright © 2015 Shu Zhang. All rights reserved.
//

#import "UserDetailViewController.h"
//#import "UserData.h"
#import <Parse.h>

@interface UserDetailViewController ()


@end

@implementation UserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self imageViewDisplay];
    [self reloadUserProfile];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Items Selling" style:UIBarButtonItemStylePlain target:self action:@selector(toUserItemsSelling)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)toUserItemsSelling{
    [self performSegueWithIdentifier:@"ItemsSelling" sender:self];
    
}



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
            //self.userDataObjectUP = [[UserData alloc]init];
            for (PFObject * object in objects)
            {
                // retreive data
                // NSString * objectID = [object objectId];
                NSString * firstName = [object objectForKey:@"UserFirstName"];
                NSString * lastname = [object objectForKey:@"UserLastName"];
                NSString * emailID = [object objectForKey:@"EmailID"];
                //NSString * address = [object objectForKey:@"Address"];
                //NSString * aptNo = [object objectForKey:@"AptNo"];
                //NSString * city = [object objectForKey:@"City"];
                //NSString * state = [object objectForKey:@"State"];
                //NSString * zipcode = [object objectForKey:@"Zipcode"];
                //NSString * phone = [object objectForKey:@"Phone"];
                PFFile *pictureFile = [object objectForKey:@"UserProfileImage"];
                [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (!error){
                        [self.UserPortrait setImage:[UIImage imageWithData:data]];
                        //_userDataObjectUP.userProfileImage = data;
                    }}];
                self.UserName.text = [NSString stringWithFormat:@"%@  %@",firstName,lastname];
                self.UserEmail.text = emailID;
                
            }
        }
        else
            NSLog(@"Canno load data");
    }];
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
