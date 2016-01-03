//
//  SearchDetailsViewController.m
//  TapSell
//
//  Created by Thanapat Tangsittiprasert on 1/2/16.
//  Copyright © 2016 Shu Zhang. All rights reserved.
//

#import "SearchDetailsViewController.h"
#import "SearchUserDetailsViewController.h"

@interface SearchDetailsViewController ()
@property (strong, nonatomic) IBOutlet UILabel *Title;
@property (strong, nonatomic) IBOutlet UILabel *Price;
@property (strong, nonatomic) IBOutlet UITextView *Description;
@property (strong, nonatomic) IBOutlet UIImageView *ImageView;
@end

@implementation SearchDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"Here is user ID in SearchDetailViewCOntroller %@", self.postListDataSDV.userID);
    [self.navigationController setNavigationBarHidden:NO];
    self.Title.text = self.postListDataSDV.title;
       self.Price.text = self.postListDataSDV.price;
    self.Description.text = self.postListDataSDV.productDescription;
    [self.ImageView setImage:[UIImage imageWithData:self.postListDataSDV.productImage]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"userDetails"]) {
        SearchUserDetailsViewController * searchUser= [[ SearchUserDetailsViewController alloc]init];
        searchUser = [segue destinationViewController];
        searchUser.postListDataSUDV = self.postListDataSDV;
        
         NSLog(@"Here is user ID in SearchDetailViewCOntroller in Segue %@ here is SearchUserDetailViewCOntroller ID in %@", self.postListDataSDV.userID, searchUser.postListDataSUDV.userID);

    }
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
