//
// MDLFile.m
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

#import "MDLFile.h"

#import "MDLMendeleyAPIClient.h"
#import "MDLDocument.h"

@implementation MDLFile

+ (MDLFile *)fileWithDateAdded:(NSDate *)dateAdded extension:(NSString *)extension hash:(NSString *)hash size:(NSNumber *)size document:(MDLDocument *)document
{
    MDLFile *file = [MDLFile new];
    file.dateAdded = dateAdded;
    file.extension = extension;
    file.hash = hash;
    file.size = size;
    file.document = document;
    return file;
}

- (void)downloadToFileAtPath:(NSString *)path success:(void (^)())success failure:(void (^)(NSError *))failure
{
    [[MDLMendeleyAPIClient sharedClient] getPath:[NSString stringWithFormat:@"/oapi/library/documents/%@/file/%@//", self.document.identifier, self.hash]
                          requiresAuthentication:self.document.isInUserLibrary
                                      parameters:nil
                        outputStreamToFileAtPath:path
                                         success:^(AFHTTPRequestOperation *requestOperation, id responseObject) {
                                             if (success) success();
                                         }
                                         failure:^(AFHTTPRequestOperation *requestOperation, NSError *error) {
                                             if (failure) failure(error);
                                         }];
}

@end
