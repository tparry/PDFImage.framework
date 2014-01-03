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

#import <XCTest/XCTest.h>

#import <PDFImage/PDFImage.h>

@interface PDFImageDemoTests : XCTestCase
{
	NSBundle* bundle;
	UIWindow* keyWindow;
}

- (void) pause:(NSTimeInterval) seconds;

@end

@implementation PDFImageDemoTests

- (void)setUp
{
	[super setUp];
	
	bundle = [NSBundle bundleForClass:[self class]];
	keyWindow = [UIApplication sharedApplication].keyWindow;
}

- (void) testPDFImage
{
	PDFImage* image = [PDFImage imageNamed:@"0" inBundle:bundle];
	
	XCTAssertNotNil(image, @"Failed loading pdf image");
	XCTAssertEqual(image.size.width, 15.0f, @"Size not as expected");
	XCTAssertEqual(image.size.height, 15.0f, @"Size not as expected");
	
	PDFImage* missing = [PDFImage imageNamed:@"non-existant" inBundle:bundle];
	
	XCTAssertNil(missing, @"Should not load missing files");
	
	PDFImageOptions* options = [PDFImageOptions optionsWithSize:image.size];
	
	UIImage* result = [image imageWithOptions:options];
	
	XCTAssertNotNil(result, @"Failed generating image");
}

- (void) testPDFImageCache
{
	PDFImage* same1 = [PDFImage imageNamed:@"5" inBundle:bundle];
	PDFImage* same2 = [PDFImage imageNamed:@"5" inBundle:bundle];
	PDFImage* diff1 = [PDFImage imageNamed:@"6" inBundle:bundle];
	
	XCTAssertEqual(same1, same2, @"Bundle caching should result in equal pointers");
	XCTAssertNotEqual(same1, diff1, @"Different files should result in different pointers");
}

- (void) testPDFImageResultCache
{
	PDFImage* image = [PDFImage imageNamed:@"5" inBundle:bundle];
	
	PDFImageOptions* options = [PDFImageOptions optionsWithSize:CGSizeMake(40, 40)];
	
	UIImage* same1 = [image imageWithOptions:options];
	UIImage* same2 = [image imageWithOptions:options];
	
	[options setTintColor:[UIColor redColor]];
	
	UIImage* diff1 = [image imageWithOptions:options];
	
	[options setTintColor:nil];
	[options setContentMode:UIViewContentModeTopLeft];
	
	UIImage* diff2 = [image imageWithOptions:options];
	
	XCTAssertEqual(same1, same2, @"Image caching should result in equal pointers");
	XCTAssertNotEqual(same1, diff1, @"Different images should result in different pointers");
	XCTAssertNotEqual(same1, diff2, @"Different images should result in different pointers");
	XCTAssertNotEqual(diff1, diff2, @"Different images should result in different pointers");
}

- (void) testPDFImageOptionsContentMode
{
	const CGSize containerSize = CGSizeMake(20, 20);
	const CGSize contentSize = CGSizeMake(5, 10);
	
	PDFImageOptions* options = [[PDFImageOptions alloc] init];
	[options setSize:containerSize];
	
	[options setContentMode:UIViewContentModeScaleToFill];
	XCTAssertEqual(CGRectMake(0, 0, 20, 20), [options contentBoundsForContentSize:contentSize], @"Wrong content mode bounds");
	
	[options setContentMode:UIViewContentModeScaleAspectFit];
	XCTAssertEqual(CGRectMake(5, 0, 10, 20), [options contentBoundsForContentSize:contentSize], @"Wrong content mode bounds");
	
	[options setContentMode:UIViewContentModeScaleAspectFill];
	XCTAssertEqual(CGRectMake(0, -10, 20, 40), [options contentBoundsForContentSize:contentSize], @"Wrong content mode bounds");
	
	[options setContentMode:UIViewContentModeRedraw];
	XCTAssertEqual(CGRectMake(0, 0, 20, 20), [options contentBoundsForContentSize:contentSize], @"Wrong content mode bounds");
	
	[options setContentMode:UIViewContentModeCenter];
	XCTAssertEqual(CGRectMake(7, 5, 5, 10), [options contentBoundsForContentSize:contentSize], @"Wrong content mode bounds");
	
	[options setContentMode:UIViewContentModeTop];
	XCTAssertEqual(CGRectMake(7, 0, 5, 10), [options contentBoundsForContentSize:contentSize], @"Wrong content mode bounds");
	
	[options setContentMode:UIViewContentModeBottom];
	XCTAssertEqual(CGRectMake(7, 10, 5, 10), [options contentBoundsForContentSize:contentSize], @"Wrong content mode bounds");
	
	[options setContentMode:UIViewContentModeLeft];
	XCTAssertEqual(CGRectMake(0, 5, 5, 10), [options contentBoundsForContentSize:contentSize], @"Wrong content mode bounds");
	
	[options setContentMode:UIViewContentModeRight];
	XCTAssertEqual(CGRectMake(15, 5, 5, 10), [options contentBoundsForContentSize:contentSize], @"Wrong content mode bounds");
	
	[options setContentMode:UIViewContentModeTopLeft];
	XCTAssertEqual(CGRectMake(0, 0, 5, 10), [options contentBoundsForContentSize:contentSize], @"Wrong content mode bounds");
	
	[options setContentMode:UIViewContentModeTopRight];
	XCTAssertEqual(CGRectMake(15, 0, 5, 10), [options contentBoundsForContentSize:contentSize], @"Wrong content mode bounds");
	
	[options setContentMode:UIViewContentModeBottomLeft];
	XCTAssertEqual(CGRectMake(0, 10, 5, 10), [options contentBoundsForContentSize:contentSize], @"Wrong content mode bounds");
	
	[options setContentMode:UIViewContentModeBottomRight];
	XCTAssertEqual(CGRectMake(15, 10, 5, 10), [options contentBoundsForContentSize:contentSize], @"Wrong content mode bounds");
}

- (void) testPDFImageView
{
	PDFImage* image = [PDFImage imageNamed:@"3" inBundle:bundle];
	
	PDFImageView* imageView = [[PDFImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
	[imageView setTintColor:[UIColor redColor]];
	[imageView setImage:image];
	[keyWindow addSubview:imageView];
	
	UIImageView* privateImageView = [imageView.subviews objectAtIndex:0];
	
	XCTAssertNotNil(privateImageView, @"Couldn't find the private image view");
	XCTAssertTrue([privateImageView isKindOfClass:[UIImageView class]], @"Couldn't find the private image view");
	
	//	Advance to the next run loop to allow the image view to draw it's content
	[self pause:0];
	
	XCTAssertNotNil(privateImageView.image, @"Private image view did not load an image");
	
	[imageView removeFromSuperview];
}

- (void) testPDFExtensionHandling
{
	XCTAssertNotNil([PDFImage imageNamed:@"extension1" inBundle:bundle], @"Failed loading pdf image");
	XCTAssertNotNil([PDFImage imageNamed:@"extension1.pdf" inBundle:bundle], @"Failed loading pdf image");
	XCTAssertNotNil([PDFImage imageNamed:@"extension2.PDF" inBundle:bundle], @"Failed loading pdf image");
	XCTAssertNotNil([PDFImage imageNamed:@"extension3.PdF" inBundle:bundle], @"Failed loading pdf image");
}

#pragma mark -
#pragma mark Private

- (void) pause:(NSTimeInterval) seconds
{
	[[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:seconds]];
}

@end
