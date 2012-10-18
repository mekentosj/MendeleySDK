//
// MDLUser.m
//
// Copyright (c) 2012 shazino (shazino SAS), http://www.shazino.com/
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

#import "MDLUser.h"
#import "MDLCategory.h"
#import "MDLMendeleyAPIClient.h"

@implementation MDLUser

+ (void)fetchMyUserProfileSuccess:(void (^)(MDLUser *))success failure:(void (^)(NSError *))failure
{
    MDLMendeleyAPIClient *client = [MDLMendeleyAPIClient sharedClient];
    
    [client getPrivatePath:@"oapi/profiles/info/me/"
                   success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDictionary) {
                       MDLUser *user = [MDLUser new];
                       NSDictionary *profileMain = responseDictionary[@"main"];
                       user.name = profileMain[@"name"];
                       user.academicStatus = profileMain[@"academic_status"];
                       user.academicStatusIdentifier = profileMain[@"academic_status_id"];
                       user.bio = profileMain[@"bio"];
                       user.category = [MDLCategory categoryWithIdentifier:profileMain[@"discipline_id"] name:profileMain[@"discipline_name"] slug:nil];
                       user.location = profileMain[@"location"];
                       user.photoURL = [NSURL URLWithString:profileMain[@"photo"]];
                       user.identifier = profileMain[@"profile_id"];
                       user.researchInterests = profileMain[@"research_interests"];
                       user.mendeleyURL = [NSURL URLWithString:profileMain[@"url"]];
                       if (success)
                           success(user);
                   } failure:^(AFHTTPRequestOperation *requestOperation, NSError *error) {
                       if (failure)
                           failure(error);
                   }];
}

@end
