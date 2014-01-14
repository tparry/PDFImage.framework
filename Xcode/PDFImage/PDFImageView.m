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
{
	BOOL hasInited;
	
	PDFImageOptions* options;	//	Bridged options from our properties
	UIImageView* imageView;
}

- (void) initPDFImageView;

@end

@implementation PDFImageView

@synthesize image;
@dynamic tintColor;

- (id) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	
	if(self != nil)
	{
		[self setBackgroundColor:[UIColor clearColor]];
		
		[self initPDFImageView];
	}
	
	return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	
	if(self != nil)
	{
		[self initPDFImageView];
	}
	
	return self;
}

- (void) initPDFImageView
{
	if(hasInited)
		return;
	hasInited = YES;
	
	options = [[PDFImageOptions alloc] init];
	[options setContentMode:self.contentMode];
	
	imageView = [[UIImageView alloc] init];
	[imageView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
	[self addSubview:imageView];
}

#pragma mark -
#pragma mark Super

- (void) layoutSubviews
{
	[super layoutSubviews];
	
	CGRect imageViewFrame = self.bounds;
	[imageView setFrame:imageViewFrame];
}

- (void) drawRect:(CGRect)rect
{
	[super drawRect:rect];
	
	[imageView setImage:self.currentUIImage];
}

- (void) setContentMode:(UIViewContentMode)contentMode
{
	[super setContentMode:contentMode];
	
	[options setContentMode:contentMode];
	
	[self setNeedsDisplay];
}

+ (Class) layerClass
{
	return [PDFImageViewLayer class];
}

#pragma mark -
#pragma mark Self

- (void) setImage:(PDFImage *)_image
{
	image = _image;
	
	[self setNeedsDisplay];
}

- (UIColor*) tintColor
{
	return options.tintColor;
}

- (void) setTintColor:(UIColor *)tintColor
{
	[options setTintColor:tintColor];
	
	[self setNeedsDisplay];
}

- (UIImage*) currentUIImage
{
	[options setSize:self.frame.size];
	
	if(!CGSizeEqualToSize(options.size, CGSizeZero))
	{
		UIImage* currentUIImage = [image imageWithOptions:options];
		return currentUIImage;
	}
	
	return nil;
}

@end
