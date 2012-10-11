//
//  MDLDocument.m
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

#import "MDLDocument.h"

#import "MDLMendeleyAPIClient.h"
#import "AFNetworking.h"

NSString * const kMDLDocumentTypeGeneric = @"Generic";

@implementation MDLDocument

+ (MDLDocument *)createNewDocumentWithTitle:(NSString *)title success:(void (^)(MDLDocument *))success failure:(void (^)(NSError *))failure
{
    MDLDocument *newDocument = [MDLDocument new];
    newDocument.title = title;
    newDocument.type =  kMDLDocumentTypeGeneric;
    
    MDLMendeleyAPIClient *client = [MDLMendeleyAPIClient sharedClient];
    
    [client postPath:@"oapi/library/documents/"
             bodyKey:@"document"
         bodyContent:@{@"type" : newDocument.type, @"title" : newDocument.title}
             success:^(AFHTTPRequestOperation *operation, id responseDictionary) {
                 newDocument.documentIdentifier = responseDictionary[@"document_id"];
                 if (success)
                     success(newDocument);
             } failure:^(AFHTTPRequestOperation *requestOperation, NSError *error) {
                 if (failure)
                     failure(error);
             }];
    
    return newDocument;
}

+ (void)searchWithTerms:(NSString *)terms success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    MDLMendeleyAPIClient *client = [MDLMendeleyAPIClient sharedClient];
    
    [client getPath:[NSString stringWithFormat:@"/oapi/documents/search/%@/", [terms stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (success)
                {
                    NSArray *rawDocuments = responseObject[@"documents"];
                    NSMutableArray *documents = [NSMutableArray array];
                    [rawDocuments enumerateObjectsUsingBlock:^(NSDictionary *rawDocument, NSUInteger idx, BOOL *stop) {
                        MDLDocument *document = [MDLDocument new];
                        document.documentIdentifier = rawDocument[@"uuid"];
                        document.title = rawDocument[@"title"];
                        document.type = rawDocument[@"type"];
                        document.DOI = rawDocument[@"doi"];
                        [documents addObject:document];
                    }];
                    success(documents);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (failure)
                    failure(error);
            }];
}

- (void)uploadFileAtURL:(NSURL *)fileURL success:(void (^)())success failure:(void (^)(NSError *))failure
{
    if (!self.documentIdentifier)
    {
        failure([NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCancelled userInfo:nil]);
        return;
    }
    
    MDLMendeleyAPIClient *client = [MDLMendeleyAPIClient sharedClient];
    
    [client putPath:[NSString stringWithFormat:@"oapi/library/documents/%@/", self.documentIdentifier]
          fileAtURL:fileURL success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if (success)
                  success();
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (failure)
                  failure(error);
          }];
}

@end
