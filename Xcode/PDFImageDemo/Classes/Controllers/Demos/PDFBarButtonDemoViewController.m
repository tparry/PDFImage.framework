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

#import "PDFBarButtonDemoViewController.h"

#import <PDFImage/PDFImage.h>

@interface PDFBarButtonDemoViewController ()

@end

@implementation PDFBarButtonDemoViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.info = @"Create a UIBarButtonItem using a PDFImage with the PDFBarButtonItem subclass";

	PDFBarButtonItem *button1 = [[PDFBarButtonItem alloc] initWithImage:[PDFImage imageNamed:@"3"] style:UIBarButtonItemStyleBordered target:nil action:nil];
	PDFBarButtonItem *button2 = [[PDFBarButtonItem alloc] initWithImage:[PDFImage imageNamed:@"4"] style:UIBarButtonItemStylePlain target:nil action:nil];
	PDFBarButtonItem *button3 = [[PDFBarButtonItem alloc] initWithImage:[PDFImage imageNamed:@"5"] style:UIBarButtonItemStylePlain target:nil action:nil];

	button1.tintColor = [UIColor redColor];
	button2.tintColor = [UIColor orangeColor];

	self.navigationItem.rightBarButtonItems = @[ button1,
												 button2,
												 button3 ];
}

@end
