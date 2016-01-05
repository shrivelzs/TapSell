//
//  SearchViewController.m
//  TapSell
//
//  Created by Thanapat Tangsittiprasert on 1/2/16.
//  Copyright © 2016 Shu Zhang. All rights reserved.
//

#import "SearchViewController.h"
#import <Parse/Parse.h>
#import "PostListData.h"
#import "CustomCell.h"
#import "SearchDetailsViewController.h"
#import "MBProgressHUD.h"

@interface SearchViewController ()
@property(nonatomic,strong)NSMutableArray *array_SeachData;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;

@property (strong,nonatomic)NSMutableArray *searchResult;
@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self RetriveData];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.array_SeachData = [[NSMutableArray alloc]init];
    self.searchResult = [[NSMutableArray alloc]init];
   
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.dimsBackgroundDuringPresentation = false;
    _searchController.searchResultsUpdater = self;
    self.searchTableView.tableHeaderView = self.searchController.searchBar;
    MBProgressHUD * HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    // Set determinate mode
    HUD.mode = MBProgressHUDModeAnnularDeterminate;
    
    [HUD.delegate self];
    HUD.labelText = @"Loading";
    
    [HUD showWhileExecuting:@selector(RetriveData) onTarget:self withObject:nil animated:YES];
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)RetriveData
{
    PFQuery * query =[PFQuery queryWithClassName:@"PostList"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            for (PFObject * object in objects)
            {
                // retreive data
                PostListData * SearchPostList = [[PostListData alloc]init];
                NSString * title = [object objectForKey:@"ProductTitle"];
                NSString * location = [object objectForKey:@"Location"];
                NSString * price = [object objectForKey:@"ProductPrice"];
                NSString * productDescription = [object objectForKey:@"Discription"];
                NSString * userID = [object objectForKey:@"UserID"];
                PFFile *pictureFile = [object objectForKey:@"ProductImage"];
                
                [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (!error){
                        SearchPostList.productImage = data;
                    }}];
                
                SearchPostList.title =title;
                SearchPostList.location = location;
                SearchPostList.price = price;
                SearchPostList.productDescription = productDescription;
                SearchPostList.userID = userID;
                [self.array_SeachData addObject:SearchPostList];
                
            }
            if (![objects count]==0) {
                NSLog(@"Successfully retrieved: %@", objects);
                [self.searchTableView reloadData];
            }
        }
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.active) {
        return [self.searchResult count];
    }
    else
    {
        return [self.array_SeachData count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    PostListData * SearchListData = [[PostListData alloc]init];
    if (cell==nil) {
        cell=[[CustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.imageViewProduct.image = [UIImage imageNamed:@"placeholder.png"];
    
    if (self.searchController.active) {
        SearchListData = [self.searchResult objectAtIndex:indexPath.row];
    }
    else {
        SearchListData = [self.array_SeachData objectAtIndex:indexPath.row];
    }
    cell.lblProductTitle.text = SearchListData.title;
    cell.lblProductLocation.text = SearchListData.location;
    cell.lblProductPrice.text = [NSString stringWithFormat:@"$ %@",SearchListData.price];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell.imageViewProduct setImage:[UIImage imageWithData:SearchListData.productImage]];
            
        });
        
    });
    //[MBProgressHUD hideHUDForView:self.view animated:YES];
    
    return cell;
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchString = [self.searchController.searchBar text];
    
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF.title CONTAINS[c] %@", searchString];
    
    if (self.searchResult!= nil) {
        [self.searchResult removeAllObjects];
    }
    
    self.searchResult= [NSMutableArray arrayWithArray:[_array_SeachData filteredArrayUsingPredicate:preicate]];
    
    [self.searchTableView reloadData];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SearchDetail"]) {
        
        if (self.searchController.active) {
            SearchDetailsViewController *objSDVC = [segue destinationViewController];
            NSIndexPath *selectedIndexPath = [self.searchTableView indexPathForSelectedRow];
            PostListData *objPLD = [self.searchResult objectAtIndex:selectedIndexPath.row];
            objSDVC.postListDataSDV = objPLD;
        }
        else
        {
            SearchDetailsViewController *objSDVC = [segue destinationViewController];
            NSIndexPath *selectedIndexPath = [self.searchTableView indexPathForSelectedRow];
            PostListData *objPLD = [self.array_SeachData objectAtIndex:selectedIndexPath.row];
            objSDVC.postListDataSDV = objPLD;
            
        }
    }
}


@end
