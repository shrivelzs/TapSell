//
//  ItemCustomTableViewCell.h
//  TapSell
//
//  Created by Shu Zhang on 12/28/15.
//  Copyright © 2015 Shu Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemCustomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblProductTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblProductLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblProductPrice;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewProduct;
@end
