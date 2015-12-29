//
//  UserItemsViewController.m
//  TapSell
//
//  Created by Shu Zhang on 12/27/15.
//  Copyright © 2015 Shu Zhang. All rights reserved.
//

#import "UserItemsViewController.h"
#import "ItemCustomTableViewCell.h"
#import "UserPostItemDetailsViewController.h"
#import "MapViewController.h"
#import <Parse.h>
@interface UserItemsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableViewPostList;
@property(nonatomic,strong)NSMutableArray * array_PostList;
@end

@implementation UserItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadData
{
    PFQuery * query =[PFQuery queryWithClassName:@"PostList"];
    [query whereKey:@"UserID" equalTo:self.userDataUserItemObj.objectID];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            NSLog(@"ObjectID is %lu", (unsigned long)objects.count);
            if ([objects count]==0) {
                NSLog(@"There is no post for this user");
                UIAlertController * alcont = [UIAlertController alertControllerWithTitle:@"Sorry!!" message:@"There is no post for this user" preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction * ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                   [self.navigationController popToRootViewControllerAnimated:YES];
                } ];
                [alcont addAction:ok];
                [self presentViewController:alcont animated:YES completion:nil];
                NSLog(@"NO object in array");
            }
            else
                
            {

            _array_PostList = [[NSMutableArray alloc]init];
            for (PFObject * object in objects)
            {
                // retreive data
                PostListData * postListData = [[PostListData alloc]init];
                NSString * postID = [object objectId];
                NSString * title = [object objectForKey:@"ProductTitle"];
                NSString * location = [object objectForKey:@"Location"];
                NSString * price = [object objectForKey:@"ProductPrice"];
                NSString * productDescription = [object objectForKey:@"Discription"];
                NSString * userID = [object objectForKey:@"UserID"];
                PFFile *pictureFile = [object objectForKey:@"ProductImage"];
                [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (!error){
                        postListData.productImage = data;
                    }}];
                postListData.postID = postID;
                postListData.title =title;
                postListData.location = location;
                postListData.price = price;
                postListData.productDescription = productDescription;
                postListData.userID = userID;
                [self.array_PostList addObject:postListData];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableViewPostList reloadData];
            });
            }
            
        }
        else
        {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
    }];
}

#pragma mark TableView Method
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array_PostList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Dequeue the cell.
    ItemCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"postListCell"];
    PostListData * postListData = [[PostListData alloc]init];
    postListData = [self.array_PostList objectAtIndex:indexPath.row];
    // make image load faster
    dispatch_queue_t que = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(que, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell.imageViewProduct setImage:[UIImage imageWithData:postListData.productImage]];
            
        });
        
    });
    cell.lblProductTitle.text =postListData.title;
    cell.lblProductLocation.text = postListData.location;
    cell.lblProductPrice.text = [NSString stringWithFormat:@"$ %@",postListData.price];
    
    return cell;
}


#pragma mark Alert method
-(void)displayAlertView:(NSString *)message
{
    UIAlertController *alertCont =[UIAlertController alertControllerWithTitle:@"Alert" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertCont addAction:okAction];
    [self presentViewController:alertCont animated:YES completion:nil];
    
}

#pragma mark Segue method
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
       if ([segue.identifier isEqualToString:@"itemDetail"]) {
        UserPostItemDetailsViewController * postDetail = [segue destinationViewController];
        NSIndexPath * selectedIndexPath = [self.tableViewPostList indexPathForSelectedRow];
        PostListData * postdata = [self.array_PostList objectAtIndex:selectedIndexPath.row];
        postDetail.postListDataObjUIPD = postdata;
    }
}
@end
