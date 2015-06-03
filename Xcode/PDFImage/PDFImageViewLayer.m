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

#import "PDFImageViewLayer.h"

@interface PDFImageViewLayer ()

@property (nonatomic, strong) CAAnimation *lastSizeAnimation;

@end

@implementation PDFImageViewLayer

#pragma mark -
#pragma mark Super

- (void)setFrame:(CGRect)frame
{
	const CGRect currentFrame = self.frame;

	const BOOL newFrameIsBigger = (frame.size.width > currentFrame.size.width ||
								   frame.size.height > currentFrame.size.height);

	self.lastSizeAnimation = nil;

	[super setFrame:frame];

	//	Delay a redraw for smooth transition when animating size
	const CGFloat redrawOffset = ((newFrameIsBigger) ? 0 : 0.9);
	const NSTimeInterval delay = self.lastSizeAnimation.duration * redrawOffset + self.lastSizeAnimation.beginTime;

	if (delay > 0)
	{
		[self performSelector:@selector(delayedSetNeedsDisplay) withObject:nil afterDelay:delay];
	}
	else
	{
		[self setNeedsDisplay];
	}

	//	Clear what we found
	self.lastSizeAnimation = nil;
}

- (void)addAnimation:(CAAnimation *)anim forKey:(NSString *)key
{
	[super addAnimation:anim forKey:key];

	if ([anim isKindOfClass:[CAPropertyAnimation class]])
	{
		CAPropertyAnimation *propertyAnimation = (id)anim;

		//	If we're animating the size, mark the duration (for use in the setFrame: method)
		if ([propertyAnimation.keyPath isEqualToString:@"bounds"] ||	//	iOS <= 7 animation key
			[propertyAnimation.keyPath isEqualToString:@"bounds.size"]) //	iOS >= 8 animation key
		{
			self.lastSizeAnimation = anim;
		}
	}
}

#pragma mark -
#pragma mark Private

- (void)delayedSetNeedsDisplay
{
	[self setNeedsDisplay];
}

@end
