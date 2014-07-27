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

#import "PDFImage.h"

#import "PDFImageOptions.h"

static NSCache* sharedPDFImageCache = nil;

@interface PDFImage ()
{
	CGPDFDocumentRef document;
	CGPDFPageRef page;
	
	NSCache* imageCache;
	dispatch_once_t imageCacheOnceToken;
}

@end

@implementation PDFImage

@synthesize size;

+ (PDFImage*) imageNamed:(NSString*) name
{
	return [self imageNamed:name inBundle:[NSBundle mainBundle]];
}

+ (PDFImage*) imageNamed:(NSString*) name inBundle:(NSBundle*) bundle
{
	//	Defaults
	NSString* pathName = name;
	NSString* pathType = @"pdf";
	
	NSString* suffix = @".pdf";
	const NSUInteger suffixLength = suffix.length;
	
	//	Enough room for the suffix
	if(name.length >= suffix.length)
	{
		const NSRange suffixRange = NSMakeRange(name.length - suffixLength, suffixLength);
		
		//	It has it's own suffix provided in the name, split the extension (type) from the name
		if([name rangeOfString:suffix options:(NSCaseInsensitiveSearch) range:suffixRange].location != NSNotFound)
		{
			NSString* extensionSeparator = @".";
			const NSUInteger extensionSeparatorLength = extensionSeparator.length;
			
			const NSRange extensionRange = NSMakeRange(suffixRange.location + extensionSeparatorLength, suffixRange.length - extensionSeparatorLength);
			NSString* extension = [name substringWithRange:extensionRange];
			
			//	Make sure we use what's provided in case it's not the same (lower)case as we expect
			pathName = [name substringToIndex:suffixRange.location];
			pathType = extension;
		}
	}
	
	return [self imageResource:pathName ofType:pathType inBundle:bundle];
}

+ (PDFImage*) imageResource:(NSString*) name ofType:(NSString*) type inBundle:(NSBundle*) bundle
{
	NSString* filepath = [bundle pathForResource:name ofType:type];
	NSString* cacheKey = filepath;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedPDFImageCache = [[NSCache alloc] init];
	});
	
	PDFImage* result = [sharedPDFImageCache objectForKey:cacheKey];
	
	if(result == nil)
	{
		//	Done in two parts to keep the type strict...
		PDFImage* alloced = [self alloc];
		result = [alloced initWithContentsOfFile:filepath];
		
		if(result != nil)
			[sharedPDFImageCache setObject:result forKey:cacheKey];
	}
	
	return result;
}

+ (PDFImage*) imageWithContentsOfFile:(NSString*) path
{
	PDFImage* alloced = [self alloc];
	return [alloced initWithContentsOfFile:path];
}

+ (PDFImage*) imageWithData:(NSData*) data
{
	PDFImage* alloced = [self alloc];
	return [alloced initWithData:data];
}

+ (NSArray*) imagesWithContentsOfFile:(NSString*) path
{
    NSData* data = [[NSData alloc] initWithContentsOfFile:path];
    return [self imagesWithData:data];
}

+ (NSArray*) imagesWithData:(NSData*) data
{
    NSMutableArray *pages;
    
    CGPDFDocumentRef document = [PDFImage createPDFDocumentFromData:data];
    if (document != NULL)
    {
        pages = [NSMutableArray array];
        
        size_t numPages = CGPDFDocumentGetNumberOfPages(document);
        for (int page = 1; page <= numPages; page++)
        {
            PDFImage *alloced = [self alloc];
            [pages addObject:[alloced initWithDocument:document page:page]];
        }
        
        CGPDFDocumentRelease(document);
    }
    return pages;
}

+ (CGPDFDocumentRef)createPDFDocumentFromData:(NSData*) data
{
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    CGPDFDocumentRef document = CGPDFDocumentCreateWithProvider(provider);
    CGDataProviderRelease(provider);
    
    return document;
}

#pragma mark -
#pragma mark Initialization

- (id) initWithContentsOfFile:(NSString*) path
{
    NSData* data = [[NSData alloc] initWithContentsOfFile:path];
    return [self initWithData:data];
}

- (id) initWithData:(NSData*) data
{
    CGPDFDocumentRef _document = [PDFImage createPDFDocumentFromData:data];
	id result = [self initWithDocument:_document];
	
	if(_document != nil)
		CGPDFDocumentRelease(_document);
	
	return result;
}

- (id) initWithDocument:(CGPDFDocumentRef) _document
{
    return [self initWithDocument:_document page:1];
}

- (id) initWithDocument:(CGPDFDocumentRef) _document page:(NSInteger) _page
{
	if(_document == nil)
		return nil;
	
	self = [super init];
	
	if(self != nil)
	{
		document = CGPDFDocumentRetain(_document);
		page = CGPDFDocumentGetPage(document, _page);
		
		size = CGPDFPageGetBoxRect(page, kCGPDFMediaBox).size;
	}
	
	return self;
}

#pragma mark -
#pragma mark Self

- (UIImage*) imageWithOptions:(PDFImageOptions*) options
{
	//	Where to draw the image
	const CGRect rect = [options contentBoundsForContentSize:size];
	
	const CGFloat scale = options.scale;
	UIColor* tintColor = [options.tintColor copy];
	const CGSize containerSize = options.size;
	
	NSString* cacheKey = [NSString stringWithFormat:@"%@-%0.2f-%@-%@", NSStringFromCGRect(rect), options.scale, tintColor.description, NSStringFromCGSize(containerSize)];
	
	dispatch_once(&imageCacheOnceToken, ^{
		imageCache = [[NSCache alloc] init];
	});
	
	UIImage* image = [imageCache objectForKey:cacheKey];
	
	if(image == nil)
	{
		UIGraphicsBeginImageContextWithOptions(containerSize, NO, scale);
		
		CGContextRef ctx = UIGraphicsGetCurrentContext();
		
		[self drawInRect:rect];
		
		if(tintColor != nil)
		{
			CGContextSaveGState(ctx);
			
			//	Color the image
			CGContextSetBlendMode(ctx, kCGBlendModeSourceIn);
			CGContextSetFillColorWithColor(ctx, tintColor.CGColor);
			CGContextFillRect(ctx, CGRectMake(0, 0, containerSize.width, containerSize.height));
			
			CGContextRestoreGState(ctx);
		}
		
		image = UIGraphicsGetImageFromCurrentImageContext();
		
		UIGraphicsEndImageContext();
		
		if(image != nil)
			[imageCache setObject:image forKey:cacheKey];
	}
	
	return image;
}

- (void) drawInRect:(CGRect) rect
{
	const CGSize drawSize = rect.size;
	const CGSize sizeRatio = CGSizeMake(size.width / drawSize.width, size.height / drawSize.height);
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	CGContextSaveGState(ctx);
	
	//	Flip and crop to the correct position and size
	CGContextScaleCTM(ctx, 1 / sizeRatio.width, 1 / -sizeRatio.height);
	CGContextTranslateCTM(ctx, rect.origin.x * sizeRatio.width, (-drawSize.height - rect.origin.y) * sizeRatio.height);
	
	CGContextDrawPDFPage(ctx, page);
	
	CGContextRestoreGState(ctx);
}

#pragma mark -
#pragma mark Cleanup

- (void) dealloc
{
	if(document != nil)
	{
		CGPDFDocumentRelease(document);
		document = nil;
	}
}

@end
