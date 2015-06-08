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

@dynamic imageName;

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];

	if (self != nil)
	{
		[self setupImageView];
	}

	return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];

	if (self != nil)
	{
		self.backgroundColor = [UIColor clearColor];
		[self setupImageView];
	}

	return self;
}

- (void)setupImageView
{
	_options = [PDFImageOptions new];
	_options.contentMode = self.contentMode;

	_imageView = [UIImageView new];
	_imageView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	[self addSubview:_imageView];
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

- (void)setImageName:(NSString *)imageName
{
	PDFImage *image = [PDFImage imageNamed:imageName];

#if TARGET_INTERFACE_BUILDER

	//	When using IBDesignables in Interface Builder
	//	the main NSBundle is not the app's so we can't get resources from it
	if (image == nil)
	{
		//	Instead, search through all NSBundles for the image
		for (NSBundle *bundle in [NSBundle allBundles])
		{
			image = [PDFImage imageNamed:imageName inBundle:bundle];

			if (image != nil)
			{
				break;
			}
		}

		//	Because PDFImage is a framework, if your IB file has no references to the main app source
		//	then it will never load the NSBundle with your resources for the above code to find
		//	This is the worst case scenario, instead look through the source directories for the resource
		if (image == nil)
		{
			const NSUInteger kSearchDepth = 10;
			NSArray *sourceDirectories = [[NSProcessInfo processInfo].environment[@"IB_PROJECT_SOURCE_DIRECTORIES"] componentsSeparatedByString:@":"];

			for (NSString *sourceDirectory in sourceDirectories)
			{
				image = [self recursiveImageNamed:imageName inPath:sourceDirectory searchDepth:kSearchDepth];

				if (image != nil)
				{
					break;
				}
			}
		}
	}

#endif /* TARGET_INTERFACE_BUILDER */

	self.image = image;
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
#pragma mark Private

- (PDFImage *)recursiveImageNamed:(NSString *)imageName inPath:(NSString *)path searchDepth:(NSUInteger)depth
{
	PDFImage *image = nil;

	NSFileManager *fileManager = [NSFileManager defaultManager];

	//	imageName assumed to be extensionless targeting a .pdf file
	NSString *imagePath = [[path stringByAppendingPathComponent:imageName] stringByAppendingPathExtension:@"pdf"];

	if ([fileManager fileExistsAtPath:imagePath])
	{
		image = [PDFImage imageWithContentsOfFile:imagePath];
	}

	//	If we haven't found the image yet, search deeper
	//	(as long as we've still got depth left)
	if (image == nil && depth > 0)
	{
		NSArray *filenames = [fileManager contentsOfDirectoryAtPath:path error:nil];

		for (NSString *filename in filenames)
		{
			NSString *subpath = [path stringByAppendingPathComponent:filename];

			//	Search subdirectories
			BOOL isDirectory;
			if ([fileManager fileExistsAtPath:subpath isDirectory:&isDirectory] && isDirectory)
			{
				const BOOL isImageAssetsDirectory = [filename.pathExtension isEqualToString:@"xcassets"];
				
				//	Currently PDFImage will not work with the compiled xcassets format (Assets.car),
				//	don't include images in this folder
				if (!isImageAssetsDirectory)
				{
					image = [self recursiveImageNamed:imageName inPath:subpath searchDepth:(depth - 1)];
					
					if (image != nil)
					{
						break;
					}
				}
			}
		}
	}

	return image;
}

@end
