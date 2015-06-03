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

#import "PDFImageView.h"

#import "PDFImage.h"
#import "PDFImageViewLayer.h"
#import "PDFImageOptions.h"

@interface PDFImageView ()

//	Bridged options from our properties
@property (nonatomic, readonly) PDFImageOptions *options;

@property (nonatomic, readonly) UIImageView *imageView;

@end

@implementation PDFImageView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];

	if (self != nil)
	{
		self.backgroundColor = [UIColor clearColor];

		_options = [PDFImageOptions new];
		_options.contentMode = self.contentMode;

		_imageView = [UIImageView new];
		_imageView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		[self addSubview:_imageView];
	}

	return self;
}

#pragma mark -
#pragma mark Super

- (void)layoutSubviews
{
	[super layoutSubviews];

	const CGRect imageViewFrame = self.bounds;
	self.imageView.frame = imageViewFrame;
}

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];

	self.imageView.image = self.currentUIImage;
}

- (void)setContentMode:(UIViewContentMode)contentMode
{
	[super setContentMode:contentMode];

	self.options.contentMode = contentMode;

	[self setNeedsDisplay];
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
	[super willMoveToWindow:newWindow];

	//	Set the scale to that of the window's screen
	//	The scale would only change if the image view is added to an external UIScreen
	self.options.scale = newWindow.screen.scale;
}

+ (Class)layerClass
{
	return [PDFImageViewLayer class];
}

#pragma mark -
#pragma mark Self

- (void)setImage:(PDFImage *)image
{
	_image = image;

	[self setNeedsDisplay];
}

- (UIColor *)tintColor
{
	return self.options.tintColor;
}

- (void)setTintColor:(UIColor *)tintColor
{
	self.options.tintColor = tintColor;

	[self setNeedsDisplay];
}

- (UIImage *)currentUIImage
{
	self.options.size = self.frame.size;

	if (!CGSizeEqualToSize(self.options.size, CGSizeZero))
	{
		UIImage *currentUIImage = [self.image imageWithOptions:self.options];
		return currentUIImage;
	}

	return nil;
}

@end
