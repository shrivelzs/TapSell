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



-(void)loadData
{
    PFQuery * query =[PFQuery queryWithClassName:@"PostList"];
    [query whereKey:@"UserID" equalTo:self.userDataObjPL.objectID];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
             _array_PostList = [[NSMutableArray alloc]init];
            for (PFObject * object in objects)
            {
                // retreive data
                NSString * title = [object objectForKey:@"ProductTitle"];
                NSString * location = [object objectForKey:@"Location"];
                NSString * price = [object objectForKey:@"ProductPrice"];
                NSString * productDescription = [object objectForKey:@"Address"];
                NSString * userID = [object objectForKey:@"UserID"];
                
                PostListData * postListData = [[PostListData alloc]init];
                postListData.title =title;
                postListData.location = location;
                postListData.price = price;
                postListData.productDescription = productDescription;
                postListData.userID = userID;
                [self.array_PostList addObject:postListData];
            }
            if (![objects count]==0) {
            NSLog(@"Successfully retrieved: %@", objects);
                [self.tableViewPostList reloadData];
                          }
            else
            {
                [self displayAlertView:@"Please enter valid emailID and password"];
            }
        }
        else
        {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
            [self displayAlertView:errorString];
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
    PostListData * postLoistData = [[PostListData alloc]init];
    postLoistData = [self.array_PostList objectAtIndex:indexPath.row];
    cell.lblProductTitle.text =postLoistData.title;
    cell.lblProductLocation.text = postLoistData.location;
    cell.lblProductPrice.text = [NSString stringWithFormat:@"$ %@",postLoistData.price];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
    }
}


#pragma mark Alsert method
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
