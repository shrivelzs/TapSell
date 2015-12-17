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
    [self ShowProductDetail];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)ShowProductDetail
{
    [self.imageViewProduct setImage:[UIImage imageWithData:self.postListDataObjPD.productImage]];
    _lblProdPrice.text = [NSString stringWithFormat:@"$  %@",self.postListDataObjPD.price];
    _lblProdTitle.text = self.postListDataObjPD.title;
    _txtViewProdDes.text = [NSString stringWithFormat:@"%@ ", self.postListDataObjPD.productDescription];
}

@end
