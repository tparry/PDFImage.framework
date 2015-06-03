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

#import "PDFAnimationDemoViewController.h"

#import <PDFImage/PDFImage.h>

@interface PDFAnimationDemoViewController ()

@property (nonatomic, readonly) PDFImageView *imageView;

@property (nonatomic, readonly) CGRect frame1;
@property (nonatomic, readonly) CGRect frame2;

@end

@implementation PDFAnimationDemoViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.title = @"PDFImageView Animation";
	self.info = @"When animated, the PDFImageView redraws itself just once, but timed smartly to give the illusion of a smooth image for the entire animation";

	PDFImage *image = [PDFImage imageNamed:@"11"];

	const CGFloat scale1 = 1;
	const CGFloat scale2 = 30;

	CGRect frame1 = CGRectMake(40, 80, image.size.width, image.size.height);
	frame1.size.width *= scale1;
	frame1.size.height *= scale1;
	_frame1 = frame1;

	CGRect frame2 = frame1;
	frame2.size.width *= scale2;
	frame2.size.height *= scale2;
	_frame2 = frame2;

	_imageView = [[PDFImageView alloc] initWithFrame:frame1];
	_imageView.image = image;
	_imageView.tintColor = [UIColor colorWithRed:0 green:0 blue:0.8 alpha:1];
	[self.view addSubview:_imageView];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	[self animate];
}

#pragma mark -
#pragma mark Private

- (void)animate
{
	[self animate:YES];
}

- (void)animate:(BOOL)toFrom
{
	[UIView animateWithDuration:1
		delay:0.5
		options:0
		animations:^{

		  self.imageView.frame = (toFrom ? self.frame2 : self.frame1);

		}
		completion:^(BOOL finished) {

		  if (finished)
			  [self animate:!toFrom];
		}];
}

@end
