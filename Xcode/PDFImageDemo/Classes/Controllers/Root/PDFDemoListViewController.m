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
#import "PDFBarButtonDemoViewController.h"

typedef NS_ENUM(NSUInteger, PDFDemo)
{
	PDFDemoTintColor,
	PDFDemoTableView,
	PDFDemoAnimation,
	PDFDemoLocalized,
	PDFDemoBarButton,
};

@interface PDFDemoListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, readonly) NSArray *demos;
@property (nonatomic, readonly) UITableView *demoTableView;

@end

@implementation PDFDemoListViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.title = @"PDFImage Demo List";

	//	Demo order
	_demos = @[ @(PDFDemoTintColor),
				@(PDFDemoTableView),
				@(PDFDemoAnimation),
				@(PDFDemoLocalized),
				@(PDFDemoBarButton) ];

	_demoTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	_demoTableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	_demoTableView.dataSource = self;
	_demoTableView.delegate = self;
	[self.view addSubview:_demoTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	if (self.demoTableView.indexPathForSelectedRow != nil)
	{
		[self.demoTableView deselectRowAtIndexPath:self.demoTableView.indexPathForSelectedRow animated:YES];
	}
}

#pragma mark -
#pragma mark Private

- (PDFDemo)demoForIndexPath:(NSIndexPath *)indexPath
{
	const PDFDemo demo = [self.demos[indexPath.row] unsignedIntegerValue];
	return demo;
}

- (NSString *)nameForDemo:(PDFDemo)demo
{
	switch (demo)
	{
		case PDFDemoTintColor:
			return @"Tint Color";
		case PDFDemoTableView:
			return @"UITableView Performance";
		case PDFDemoAnimation:
			return @"PDFImageView Animation";
		case PDFDemoLocalized:
			return @"Localized Resources";
		case PDFDemoBarButton:
			return @"UIBarButtonItem";
	}
}

- (Class)classForDemo:(PDFDemo)demo
{
	switch (demo)
	{
		case PDFDemoTintColor:
			return [PDFTintColorDemoViewController class];
		case PDFDemoTableView:
			return [PDFTableViewDemoViewController class];
		case PDFDemoAnimation:
			return [PDFAnimationDemoViewController class];
		case PDFDemoLocalized:
			return [PDFLocalizedDemoViewController class];
		case PDFDemoBarButton:
			return [PDFBarButtonDemoViewController class];
	}
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	const PDFDemo demo = [self demoForIndexPath:indexPath];
	Class class = [self classForDemo:demo];

	UIViewController *viewController = [class new];
	[self.navigationController pushViewController:viewController animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.demos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *const identifier = @"demoCell";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
	}

	const PDFDemo demo = [self demoForIndexPath:indexPath];
	NSString *name = [self nameForDemo:demo];

	cell.textLabel.text = name;

	return cell;
}

@end
