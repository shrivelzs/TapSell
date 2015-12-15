//
//  PostDetailsViewController.m
//  TapSell
//
//  Created by Thanapat Tangsittiprasert on 12/15/15.
//  Copyright © 2015 Shu Zhang. All rights reserved.
//

#import "PostDetailsViewController.h"

@interface PostDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageViewProduct;
@property (weak, nonatomic) IBOutlet UILabel *lblProdTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblProdPrice;
@property (weak, nonatomic) IBOutlet UITextView *txtViewProdDes;

@end

@implementation PostDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)ShowProductDetail
{
    _lblProdPrice.text = self.postListDataObjPD.price;
    _lblProdTitle.text = self.postListDataObjPD.title;
    _txtViewProdDes.text = self.postListDataObjPD.productDescription;
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
