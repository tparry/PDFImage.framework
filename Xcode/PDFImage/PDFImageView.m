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

@property (weak) NSTimer *animationTimer;

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

- (instancetype)initWithImage:(PDFImage *)image
{
	self = [self initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];

	if (self != nil)
	{
		self.image = image;
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

- (CGSize)sizeThatFits:(CGSize)size
{
	return self.image.size;
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

#pragma mark -

- (void)setAnimationImages:(NSArray<PDFImage *> *)animationImages
{
	if (self.isAnimating)
	{
		[self stopAnimating];
	}
	
	if (animationImages.count > 0)
	{
		if (self.animationDuration == 0)
		{
			// if animation duration did not set before, then set it to number of images divided by 30
			// same as default UIImageView animationDuration value
			self.animationDuration = animationImages.count / 30.0;
		}
	}
	
	_animationImages = animationImages;
}

- (void)startAnimating
{
	if (self.isAnimating)
	{
		[self stopAnimating];
	}
	
	if (self.animationImages.count > 0)
	{
		__block NSUInteger imageNumber = 0;
		__block NSUInteger repeated = 0;
		
		void (^changeImageBlock)() = ^{
			
			[self setImage:self.animationImages[imageNumber]];
			
			if (++imageNumber == self.animationImages.count)
			{
				imageNumber = 0;
				repeated++;
				
				if (self.animationRepeatCount != 0 && repeated == self.animationRepeatCount)
				{
					[self.animationTimer invalidate];
				}
			}
		};
		
		NSTimeInterval intervalForChangeOneImage = self.animationDuration / self.animationImages.count;
		
		self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:intervalForChangeOneImage target:[NSBlockOperation blockOperationWithBlock:changeImageBlock] selector:@selector(main) userInfo:nil repeats:YES];
	}
}

- (void)stopAnimating
{
	[self.animationTimer invalidate];
}

- (BOOL)isAnimating
{
	if (self.animationTimer.isValid)
		return YES;
	else
		return NO;
}

@end
