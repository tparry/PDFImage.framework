//
//  This is free and unencumbered software released into the public domain.
//
//  Anyone is free to copy, modify, publish, use, compile, sell, or
//  distribute this software, either in source code form or as a compiled
//  binary, for any purpose, commercial or non-commercial, and by any
//  means.
//
//  In jurisdictions that recognize copyright laws, the author or authors
//  of this software dedicate any and all copyright interest in the
//  software to the public domain. We make this dedication for the benefit
//  of the public at large and to the detriment of our heirs and
//  successors. We intend this dedication to be an overt act of
//  relinquishment in perpetuity of all present and future rights to this
//  software under copyright law.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
//  OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
//  ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//
//  For more information, please refer to <http://unlicense.org/>
//

//	Available from GitHub
//	https://github.com/tparry/PDFImage.framework

//	Make PDF files smaller with PDFShaver.app
//	https://github.com/tparry/PDFShaver.app

#import <UIKit/UIKit.h>

#import <PDFImage/PDFImageView.h>
#import <PDFImage/PDFImageOptions.h>
#import <PDFImage/PDFBarButtonItem.h>

//	PDFImage is thread-safe,
//	however note that opening the same bundled file on
//	two different threads within a short time of each other (microseconds)
//	may result in a new instance and not the version in NSCache, the same applies to imageWithOptions:
@interface PDFImage : NSObject

@property (nonatomic, readonly) CGSize size;	//	original page size

+ (PDFImage*) imageNamed:(NSString*) name;		//	from the main bundle, the .pdf extension can be omitted,
												//	this and +imageNamed:inBundle: are the only methods that will NSCache PDFImages, as bundles are read-only

+ (PDFImage*) imageNamed:(NSString*) name inBundle:(NSBundle*) bundle;

// Single page PDF methods that return a PDFImage
+ (PDFImage*) imageWithContentsOfFile:(NSString*) path;
+ (PDFImage*) imageWithData:(NSData*) data;

// Multi page PDF methods. These return an ordered list of PDFImages
+ (NSArray*) imagesWithContentsOfFile:(NSString*) path;
+ (NSArray*) imagesWithData:(NSData*) data;

- (id) initWithContentsOfFile:(NSString*) path;
- (id) initWithData:(NSData*) data;

- (id) initWithDocument:(CGPDFDocumentRef) document;
- (id) initWithDocument:(CGPDFDocumentRef) document page:(NSInteger) page;

- (UIImage*) imageWithOptions:(PDFImageOptions*) options;	//	will NSCache the image if the same options are used again
- (void) drawInRect:(CGRect) rect;

@end
