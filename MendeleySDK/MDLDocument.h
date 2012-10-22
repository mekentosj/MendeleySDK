//
// MDLDocument.h
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

#import <Foundation/Foundation.h>

extern NSString * const kMDLDocumentTypeGeneric;

@class MDLPublication;
@class MDLMendeleyAPIClient;

/**
 `MDLDocument` represents a user’s document, as described by Mendeley.
 */

@interface MDLDocument : NSObject

/**
 The document identifier, as generated by Mendeley.
 */
@property (copy, nonatomic) NSString *identifier;

/**
 The document DOI (Digital Object Identifier).
 */
@property (copy, nonatomic) NSString *DOI;

/**
 The type of the document. This is `@"Generic"` by default.
 */
@property (copy, nonatomic) NSString *type;

/**
 The title of the document.
 */
@property (copy, nonatomic) NSString *title;

/**
 The abstract of the document.
 */
@property (copy, nonatomic) NSString *abstract;

/**
 The Mendeley URL of the document.
 */
@property (strong, nonatomic) NSURL *mendeleyURL;

/**
 The authors of the document stored as MDLAuthor.
 */
@property (strong, nonatomic) NSArray *authors;

/**
 The publication of the document.
 */
@property (strong, nonatomic) MDLPublication *publication;

/**
 The year of the document.
 */
@property (strong, nonatomic) NSNumber *year;

/**
 Creates a `MDLDocument` and sends an API creation request using the shared client.
 
 @param title The title of the document.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes one argument: the created document with its newly assigned document identifier.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the resonse data. This block has no return value and takes one argument: the `NSError` object describing the network or parsing error that occurred.
 
 @return  The newly-initialized document, with document identifier = `nil`.
 
 @see [API documentation: User Library Create Document](http://apidocs.mendeley.com/home/user-specific-methods/user-library-create-document)
 */
+ (MDLDocument *)documentWithTitle:(NSString *)title success:(void (^)(MDLDocument *))success failure:(void (^)(NSError *))failure;

/**
 Sends an API search request with generic terms using the shared client.
 
 @param terms The terms for the search query
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes one argument: an array of `MDLDocument` objects for the match.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the resonse data. This block has no return value and takes one argument: the `NSError` object describing the network or parsing error that occurred.
 
 @see [API documentation: Search Terms](http://apidocs.mendeley.com/home/public-resources/search-terms)
 */
+ (void)searchWithTerms:(NSString *)terms success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure;

/**
 Sends an API search request with specific terms using the shared client.
 
 @param genericTerms The terms for the search query
 @param authors The authors for the search query
 @param title The title for the search query
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes one argument: an array of `MDLDocument` objects for the match.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the resonse data. This block has no return value and takes one argument: the `NSError` object describing the network or parsing error that occurred.
 
 @see [API documentation: Search Terms](http://apidocs.mendeley.com/home/public-resources/search-terms)
 */
+ (void)searchWithGenericTerms:(NSString *)genericTerms authors:(NSString *)authors title:(NSString *)title success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure;

/**
 Sends a top documents (papers) API request using the shared client and fetches the response as an array of `MDLDocument`.
 
 @param categoryIdentifier If not `nil`, the identifier of the category, otherwise across all categories.
 @param upAndComing If true, results apply to ‘trending’ documents.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes one argument: an array of `MDLDocument` objects.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the resonse data. This block has no return value and takes one argument: the `NSError` object describing the network or parsing error that occurred.
 
 @see [API documentation: Stats Papers](http://apidocs.mendeley.com/home/public-resources/stats-papers)
 */
+ (void)topDocumentsInPublicLibraryForCategory:(NSString *)categoryIdentifier upAndComing:(BOOL)upAndComing success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure;

/**
 Sends an API upload request using the shared client.
 
 Keep in mind that Mendeley only handles a limited number of file formats (.pdf, etc).
 
 @param fileURL The local URL for the file to upload.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes no argument.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the resonse data. This block has no return value and takes one argument: the `NSError` object describing the network or parsing error that occurred.
 
 @see [API documentation: File Upload](http://apidocs.mendeley.com/home/user-specific-methods/file-upload)
 */
- (void)uploadFileAtURL:(NSURL *)fileURL success:(void (^)())success failure:(void (^)(NSError *))failure;

/**
 Sends an API details request for the current document using the shared client.
 
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes one argument: the current document with its newly assigned details.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the resonse data. This block has no return value and takes one argument: the `NSError` object describing the network or parsing error that occurred.
 
 @see [API documentation: Search details](http://apidocs.mendeley.com/home/public-resources/search-details)
 */
- (void)fetchDetailsSuccess:(void (^)(MDLDocument *))success failure:(void (^)(NSError *))failure;

/**
 Sends a related documents API request using the shared client.
 
 @param pageIndex The page index. `O` is first page.
 @param count The number of items returned per page.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes one argument: an array of `MDLDocument` objects.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the resonse data. This block has no return value and takes one argument: the `NSError` object describing the network or parsing error that occurred.
 
 @see [API documentation: Search Related](http://apidocs.mendeley.com/home/public-resources/search-related)
 */
- (void)fetchRelatedDocumentsAtPage:(NSUInteger)pageIndex count:(NSUInteger)count success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure;

@end
