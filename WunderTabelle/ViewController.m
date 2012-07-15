//
//  ViewController.m
//  WunderTabelle
//
//  Created by Brad Leege on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "Player.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize tableView;
@synthesize tableData;
@synthesize tvCell;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.rowHeight = 100;
    tableView.backgroundColor = [UIColor clearColor];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 60)];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 300, 40)];
    headerLabel.text = @"Die Nationalmannschaft";
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.shadowColor = [UIColor blackColor];
    headerLabel.shadowOffset = CGSizeMake(0, 1);
    headerLabel.font = [UIFont boldSystemFontOfSize:22];
    headerLabel.backgroundColor = [UIColor clearColor];
    containerView.backgroundColor = [UIColor colorWithRed:0.8980 green:0.7373 blue:0.1961 alpha:1.0000];
    [containerView addSubview:headerLabel];
    tableView.tableHeaderView = containerView;
    
    tableData = [[NSMutableArray alloc] init];
    [self loadPlayerData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (void) loadPlayerData
{
    NSManagedObjectContext *managedObjectContext = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Player" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    [request setReturnsObjectsAsFaults:NO];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"kitNumber" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil)
    {
        NSLog(@"Error occurred fetching Players: %@", [error description]);
        return;
    }
    NSLog(@"Players search found '%d' entries.", [mutableFetchResults count]);
    
    [tableData removeAllObjects];
    [tableData addObjectsFromArray:mutableFetchResults];
    
    [self.tableView reloadData];
}


#pragma UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"PlayerTableCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"PlayerTableCell" owner:self options:nil];
        cell = tvCell;
        self.tvCell = nil;
    }
    
	// Configure the cell...
	Player *p = (Player *)[tableData objectAtIndex:indexPath.row];
    UILabel *label;
    label = (UILabel *)[cell viewWithTag:1];
    label.text = [p.kitNumber stringValue];
    
    label = (UILabel *)[cell viewWithTag:2];
    label.text = [p.firstName stringByAppendingFormat:@" %@", p.lastName];

    label = (UILabel *)[cell viewWithTag:3];
    label.text = p.club;

    label = (UILabel *)[cell viewWithTag:4];
    label.text = [p.position substringToIndex:1];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Deselect Selection
	[tv deselectRowAtIndexPath:indexPath animated:NO];
}

@end
