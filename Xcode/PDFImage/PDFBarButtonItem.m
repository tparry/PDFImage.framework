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

#import "PDFBarButtonItem.h"

#import "PDFImage.h"
#import "PDFImageOptions.h"

static BOOL isiOS7OrGreater = YES;

@interface PDFBarButtonItem ()

@property (nonatomic, readonly) PDFImage* originalImage;
@property (nonatomic, readonly) CGSize targetSize;

@end

@implementation PDFBarButtonItem

+ (void) initialize
{
	if(self == [PDFBarButtonItem class])
	{
		isiOS7OrGreater = ([UIDevice currentDevice].systemVersion.integerValue >= 7);
	}
}

#pragma mark -

- (instancetype) initWithImage:(PDFImage*) image style:(UIBarButtonItemStyle) style target:(id) target action:(SEL) action
{
	return [self initWithImage:image style:style target:target action:action targetSize:CGSizeMake(28, 28)];
}

- (instancetype) initWithImage:(PDFImage*) image style:(UIBarButtonItemStyle) style target:(id) target action:(SEL) action targetSize:(CGSize) targetSize
{
	self = [super initWithImage:nil style:style target:target action:action];
	
	if(self != nil)
	{
		_originalImage = image;
		_targetSize = targetSize;
		
		[self updateBarButtonImage];
	}
	
	return self;
}

#pragma mark -
#pragma mark Super

- (void) setTintColor:(UIColor *)tintColor
{
	[super setTintColor:tintColor];
	
	[self updateBarButtonImage];
}

#pragma mark -
#pragma mark Private

- (void) updateBarButtonImage
{
	PDFImage* originalImage = self.originalImage;
	const CGSize imageSize = [[PDFImageOptions optionsWithSize:self.targetSize] wholeProportionalFitForContentSize:originalImage.size];
	
	//	The color of the image,
	//	on iOS6 we colorize it only if we're using a bordered style (not plain),
	//	on iOS7+ white is used, as the UIBarButtonItem tint color will colorize our image anyway
	UIColor* tintColor = self.tintColor;
	if(tintColor == nil || (self.style != UIBarButtonItemStylePlain && !isiOS7OrGreater) || isiOS7OrGreater)
		tintColor = [UIColor whiteColor];
	
	PDFImageOptions* options = [PDFImageOptions optionsWithSize:imageSize];
	[options setTintColor:tintColor];
	
	UIImage* image = [originalImage imageWithOptions:options];
	[self setImage:image];
}

@end
