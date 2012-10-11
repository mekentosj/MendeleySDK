//
//  MDLDocumentSearchResultsViewController.h
//  MendeleySDKDemo
//
//  Created by Vincent Tourraine on 11/10/12.
//  Copyright (c) 2012 shazino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDLDocumentSearchResultsViewController : UITableViewController <UISearchBarDelegate>

@property (nonatomic, copy) NSString *searchGenericTerms;
@property (nonatomic, copy) NSString *searchAuthors;
@property (nonatomic, copy) NSString *searchTitle;

@end