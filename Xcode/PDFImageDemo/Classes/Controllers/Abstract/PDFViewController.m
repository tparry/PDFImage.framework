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

#import "PDFViewController.h"

@interface PDFViewController ()

@property (nonatomic, readonly) UILabel *infoLabel;

@end

@implementation PDFViewController

@dynamic info;
@synthesize infoLabel = _infoLabel;

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];

	if (_infoLabel != nil)
	{
		UILabel *infoLabel = _infoLabel;

		CGRect infoLabelFrame = CGRectZero;
		infoLabelFrame.origin.x = 10;
		infoLabelFrame.size.width = self.view.frame.size.width - infoLabelFrame.origin.x * 2;
		infoLabelFrame.size.height = [infoLabel sizeThatFits:CGSizeMake(infoLabelFrame.size.width, CGFLOAT_MAX)].height;
		infoLabelFrame.origin.y = self.view.frame.size.height - infoLabelFrame.size.height - 10;

		infoLabel.frame = infoLabelFrame;
	}
}

#pragma mark -
#pragma mark Self

- (void)setInfo:(NSString *)info
{
	self.infoLabel.text = info;

	[self.view setNeedsLayout];
}

- (NSString *)info
{
	return _infoLabel.text;
}

#pragma mark -
#pragma mark Private

- (UILabel *)infoLabel
{
	if (_infoLabel == nil)
	{
		_infoLabel = [UILabel new];
		_infoLabel.numberOfLines = 0;
		_infoLabel.font = [UIFont systemFontOfSize:17];
		_infoLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1];
		[self.view addSubview:_infoLabel];

		[self.view setNeedsLayout];
	}

	return _infoLabel;
}

@end
