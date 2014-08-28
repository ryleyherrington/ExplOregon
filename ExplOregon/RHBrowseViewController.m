//
//  RHFirstViewController.m
//  ExplOregon
//
//  Created by Herrington, Ryley on 8/25/14.
//  Copyright (c) 2014 Ryley Herrington. All rights reserved.
//

#import "RHBrowseViewController.h"
#import "TLSpringFlowLayout.h"
#import "RHPullDownView.h"
#import "RHDetailCell.h"

NSString* const flickrKey =  @"11508423f4de41f1aa821c2a53ae5864";
NSString* const flickrSecret =  @"77356c160129b99f";
NSString* const trailKey =  @"3aca8ecddb41abb552e2d8843cc34614";

@interface RHBrowseViewController ()

@property (nonatomic, assign) CGFloat lastContentOffset;
@property (nonatomic, strong) NSMutableData* responseData;
@property (nonatomic, strong) NSArray* results;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) RHPullDownView *pullDownView;

@end

@implementation RHBrowseViewController

static NSString * CellIdentifier = @"cellIdentifier";

typedef enum ScrollDirection {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} ScrollDirection;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"Hikes"];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.opaque = NO;
    
    /* self.pullDownView = [[[NSBundle mainBundle] loadNibNamed:@"RHPullDownView" owner:self options:nil] firstObject];
     self.pullDownView.frame = CGRectMake(0, -44, 320, 44);
     
     self.pullDownView.backgroundColor = [UIColor redColor];
     
     [self.collectionView addSubview:self.pullDownView];
     */
    
    NSString *location = [self getLocation];
    [self searchHikes:location];
    self.responseData = [NSMutableData data];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

-(void)viewDidLayoutSubviews{
    NSLog(@"Pull Down Frame: %@", NSStringFromCGRect(self.pullDownView.frame));
    NSLog(@"Collection View Frame: %@", NSStringFromCGRect(self.collectionView.frame));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - CollectionView

-(NSString*)getLocation{
    return @"Portland";
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%@",[NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    self.results= [res objectForKey:@"places"];
    /*
     NSLog(@"results: %@", [self.results objectAtIndex:0]);
     NSDictionary *places = [self.results objectAtIndex:0];
     NSLog(@"activities: %@", [places objectForKey:@"activities"]);
     NSArray* activitiesArr = [places objectForKey:@"activities"];
     NSDictionary* actDict = activitiesArr[0];
     NSLog(@"name: %@", [places objectForKey:@"name"]);
     NSLog(@"city: %@", [places objectForKey:@"city"]);
     NSLog(@"number of entries: %d", [self.results count]);
     */
    [self.collectionView reloadData];
}

-(void)searchHikes:(NSString*)location
{
    NSString* urlString = [NSString stringWithFormat:@"https://outdoor-data-api.herokuapp.com/api.json?api_key=%@&limit=42&q[activities_activity_type_name_eq]=hiking&q[city_cont]=Portland&q[country_cont]=United+States&q[state_cont]=Oregon&radius=25", trailKey];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:20];
    NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    [conn start];
}

#pragma mark - UICollectionView Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.results.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RHDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *places = [self.results objectAtIndex:indexPath.row];
    NSArray* activitiesArr = [places objectForKey:@"activities"];
    NSDictionary* actDict = activitiesArr[0];
    
    cell.titleLabel.text = [actDict objectForKey:@"name"];
    cell.cityLabel.text = [places objectForKey:@"city"];
   
    /*
    NSData *data = [NSData dataWithContentsOfURL:flickrURL];
    UIImage *img = [[UIImage alloc] initWithData:data cache:NO];
    CGSize size = img.size;
    cell.thumbnail.image = [UIImage alloc] initWith
     */
    
    return cell;
}

#pragma mark - UIScrollView Methods
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    NSLog(@"Content Offset:%f", self.collectionView.contentOffset.y);
    //    NSLog(@"Last Pos: %f", self.lastContentOffset);
    ScrollDirection scrollDirection=ScrollDirectionNone;
    if (self.lastContentOffset > self.collectionView.contentOffset.y){
        scrollDirection = ScrollDirectionUp;
    } else if (self.lastContentOffset < self.collectionView.contentOffset.y) {
        scrollDirection = ScrollDirectionDown;
    }
    
    self.lastContentOffset = self.collectionView.contentOffset.y;
    if (self.collectionView.contentOffset.y < 4 || self.collectionView.contentOffset.y > self.collectionView.frame.size.height - 44){
        return;
    }

    if (scrollDirection == ScrollDirectionUp){
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.navigationController.navigationBar.backgroundColor = [UIColor greenColor];
                             [self.navigationController setNavigationBarHidden:NO animated:YES];
                             self.tabBarController.tabBar.frame = CGRectMake(0,
                                                                             self.view.frame.size.height -self.tabBarController.tabBar.frame.size.height,
                                                                             self.tabBarController.tabBar.frame.size.width,
                                                                             self.tabBarController.tabBar.frame.size.height);
                         }
                         completion:^(BOOL finished){
                         }];
        
    }
    if (scrollDirection == ScrollDirectionDown){
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
                             [self.navigationController setNavigationBarHidden:YES animated:YES];
//                             self.pullDownView.frame = CGRectMake(0, 0, self.pullDownView.frame.size.width, self.pullDownView.frame.size.height);
                             self.tabBarController.tabBar.frame = CGRectMake(0,
                                                                             self.view.frame.size.height,
                                                                             self.tabBarController.tabBar.frame.size.width,
                                                                             self.tabBarController.tabBar.frame.size.height);
                         }
                         completion:^(BOOL finished){
                         }];
    }
}


@end
