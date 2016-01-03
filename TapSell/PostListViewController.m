//
//  PostListViewController.m
//  TapSell
//
//  Created by Thanapat Tangsittiprasert on 12/14/15.
//  Copyright © 2015 Shu Zhang. All rights reserved.
//

#import "PostListViewController.h"
#import <Parse.h>
#import "CustomCell.h"
#import "PostViewController.h"
#import "PostListData.h"
#import "PostDetailsViewController.h"
@interface PostListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableViewPostList;
@property(nonatomic,strong)NSMutableArray * array_PostList;
@end

@implementation PostListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)refreshAction:(id)sender {
    [self.tableViewPostList performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}
-(void)loadData
{
    NSString * objectID = [[NSUserDefaults standardUserDefaults] objectForKey:@"objectID"];
    PFQuery * query =[PFQuery queryWithClassName:@"PostList"];
    [query whereKey:@"UserID" equalTo:objectID];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
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
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"postListCell"];
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            NSLog(@"Delete cell click");
            PostListData * posListData = [[PostListData alloc]init];
            posListData = [self.array_PostList objectAtIndex:indexPath.row];
            PFObject * delete = [PFObject objectWithoutDataWithClassName:@"PostList" objectId:posListData.postID];
            [delete deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *  error) {
                if (succeeded) {
                    NSLog(@"Delete completed");
                    [self loadData];
                    [self.tableViewPostList reloadData];
                }
                else
                    NSLog(@"Delete incompleted");
            }];
        }
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
    if ([segue.identifier isEqualToString:@"addPost"]) {
        PostViewController * addPost = [segue destinationViewController];
        addPost.userDataObjAP = self.userDataObjPL;
    }
    if ([segue.identifier isEqualToString:@"postDetails"]) {
        PostDetailsViewController * postDetail = [segue destinationViewController];
        
        NSIndexPath * selectedIndexPath = [self.tableViewPostList indexPathForSelectedRow];
        PostListData * postdata = [self.array_PostList objectAtIndex:selectedIndexPath.row];
        postDetail.postListDataObjPD = postdata;
    }
}

@end
