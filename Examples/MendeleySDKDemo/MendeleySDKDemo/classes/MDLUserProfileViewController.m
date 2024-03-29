//
// MDLUserProfileViewController.m
//
// Copyright (c) 2012-2013 shazino (shazino SAS), http://www.shazino.com/
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "MDLUserProfileViewController.h"
#import "MDLUser.h"
#import "MDLCategory.h"
#import "AFNetworking.h"

@interface MDLUserProfileViewController ()

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *locationLabel;
@property (nonatomic, weak) IBOutlet UILabel *categoryLabel;
@property (nonatomic, weak) IBOutlet UILabel *interestsLabel;
@property (nonatomic, weak) IBOutlet UIImageView *profileImageView;

- (IBAction)openWebUserProfile:(id)sender;

@end

@implementation MDLUserProfileViewController

- (void)setUser:(MDLUser *)user
{
    _user = user;
    self.nameLabel.text = user.name;
    self.locationLabel.text = user.location;
    self.categoryLabel.text = user.category.name;
    self.interestsLabel.text = user.researchInterests;
    [self.profileImageView setImageWithURL:user.photoURL placeholderImage:nil];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.user)
    {
        [self.user fetchProfileSuccess:^(MDLUser *user) {
            self.user = user;
        } failure:^(NSError *error) {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }];
    }
    else
    {
        [MDLUser fetchMyUserProfileSuccess:^(MDLUser *user) {
            self.user = user;
        } failure:^(NSError *error) {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }];
    }
}

#pragma mark - Actions

- (IBAction)openWebUserProfile:(id)sender
{
    [[UIApplication sharedApplication] openURL:self.user.mendeleyURL];
}

@end
