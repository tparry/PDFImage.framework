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

#import "PDFDemoListViewController.h"

#import "PDFTintColorDemoViewController.h"
#import "PDFTableViewDemoViewController.h"
#import "PDFAnimationDemoViewController.h"
#import "PDFLocalizedDemoViewController.h"

typedef NS_ENUM(NSUInteger, PDFDemo)
{
	PDFDemoTintColor,
	PDFDemoTableView,
	PDFDemoAnimation,
	PDFDemoLocalized,
};

@interface PDFDemoListViewController () <UITableViewDataSource, UITableViewDelegate>
{
	NSArray* demos;
	UITableView* demoTableView;
}

- (PDFDemo) demoForIndexPath:(NSIndexPath*) indexPath;
- (NSString*) nameForDemo:(PDFDemo) demo;
- (Class) classForDemo:(PDFDemo) demo;

@end

@implementation PDFDemoListViewController

- (void) viewDidLoad
{
	[super viewDidLoad];
	
	[self setTitle:@"PDFImage Demo List"];
	
	//	Demo order
	demos = @[@(PDFDemoTintColor), @(PDFDemoTableView), @(PDFDemoAnimation), @(PDFDemoLocalized)];
	
	demoTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	[demoTableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
	[demoTableView setDataSource:self];
	[demoTableView setDelegate:self];
	[self.view addSubview:demoTableView];
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if(demoTableView.indexPathForSelectedRow != nil)
		[demoTableView deselectRowAtIndexPath:demoTableView.indexPathForSelectedRow animated:YES];
}

#pragma mark -
#pragma mark Private

- (PDFDemo) demoForIndexPath:(NSIndexPath*) indexPath
{
	const PDFDemo demo = [[demos objectAtIndex:indexPath.row] unsignedIntegerValue];
	return demo;
}

- (NSString*) nameForDemo:(PDFDemo) demo
{
	switch(demo)
	{
		case PDFDemoTintColor:	return @"Tint Color";
		case PDFDemoTableView:	return @"UITableView Performance";
		case PDFDemoAnimation:	return @"PDFImageView Animation";
		case PDFDemoLocalized:	return @"Localized Resources";
	}
	
	return nil;
}

- (Class) classForDemo:(PDFDemo) demo
{
	switch(demo)
	{
		case PDFDemoTintColor:	return [PDFTintColorDemoViewController class];
		case PDFDemoTableView:	return [PDFTableViewDemoViewController class];
		case PDFDemoAnimation:	return [PDFAnimationDemoViewController class];
		case PDFDemoLocalized:	return [PDFLocalizedDemoViewController class];
	}
	
	return nil;
}

#pragma mark -
#pragma mark UITableView Delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	const PDFDemo demo = [self demoForIndexPath:indexPath];
	Class class = [self classForDemo:demo];
	
	UIViewController* viewController = [[class alloc] init];
	[self.navigationController pushViewController:viewController animated:YES];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return demos.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* identifier = @"demoCell";
	
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	
	if(cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
	}
	
	const PDFDemo demo = [self demoForIndexPath:indexPath];
	NSString* name = [self nameForDemo:demo];
	
	[cell.textLabel setText:name];
	
	return cell;
}

@end
