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

#import "PDFImageViewCell.h"

#import <PDFImage/PDFImage.h>

static const NSUInteger kImageViewCount = 2;

@implementation PDFImageViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

	if (self != nil)
	{
		NSMutableArray *mutablePDFImageViews = [NSMutableArray new];

		for (NSUInteger i = 0; i < kImageViewCount; i++)
		{
			PDFImageView *pdfImageView = [PDFImageView new];
			[mutablePDFImageViews addObject:pdfImageView];
			[self.contentView addSubview:pdfImageView];
		}

		_pdfImageViews = [mutablePDFImageViews copy];
	}

	return self;
}

#pragma mark -
#pragma mark Super

- (void)layoutSubviews
{
	[super layoutSubviews];

	const CGFloat imageViewDimension = self.contentView.frame.size.height;

	NSArray *pdfImageViews = self.pdfImageViews;

	for (NSUInteger i = 0; i < pdfImageViews.count; i++)
	{
		PDFImageView *pdfImageView = pdfImageViews[i];

		pdfImageView.frame = CGRectMake(imageViewDimension * (i + 1) + imageViewDimension * i,
										0,
										imageViewDimension,
										imageViewDimension);
	}
}

@end
