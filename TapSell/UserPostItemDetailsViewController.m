//
//  UserPostItemDetailsViewController.m
//  TapSell
//
//  Created by Thanapat Tangsittiprasert on 12/28/15.
//  Copyright © 2015 Shu Zhang. All rights reserved.
//

#import "UserPostItemDetailsViewController.h"

@interface UserPostItemDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageViewProduct;
@property (weak, nonatomic) IBOutlet UILabel *lblProdTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblProdPrice;
@property (weak, nonatomic) IBOutlet UITextView *txtViewProdDes;
@end

@implementation UserPostItemDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ShowProductDetail];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)ShowProductDetail
{
    [self.imageViewProduct setImage:[UIImage imageWithData:self.postListDataObjUIPD.productImage]];
    _lblProdPrice.text = [NSString stringWithFormat:@"$  %@",self.postListDataObjUIPD.price];
    _lblProdTitle.text = self.postListDataObjUIPD.title;
    _txtViewProdDes.text = [NSString stringWithFormat:@"%@ ", self.postListDataObjUIPD.productDescription];
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
