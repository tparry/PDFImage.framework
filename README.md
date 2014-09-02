PDFImage.framework
===========

`PDFImage` is a framework for iOS that renders simple PDF files to screen.

`PDFImage.framework` is **not a full PDF rendering library**. It is designed to draw small scalable PDF vector files as a replacement to exporting many asset images at different sizes - much like *NSImage on the Mac*.

![image](Images/scalable.png?raw=true)

Making a PDF
-----

In Photoshop, choose `File > Save As...`. Select `Photoshop PDF` as the file format and save. In the next window, just leave everything as is and proceed saving.

For best results, make sure all Photoshop layers are vector shapes or smart objects.

To optimize the file and make it smaller, try [`PDFShaver.app`](https://github.com/tparry/PDFShaver.app), a Mac OS X app to slim down the file size of PDF files.

Usage
-----

Download the [`PDFImage.framework`](../../releases/latest) and link it with your project.

Add the following line to import the required classes.

    #import <PDFImage/PDFImage.h>

Syntax is similar to creating a `UIImage`:

    PDFImage* image = [PDFImage imageNamed:@"email"];

This will load the `email.pdf` file from the main bundle.

To show the `PDFImage` on the screen:

    PDFImage* image = [PDFImage imageNamed:@"email"];
    
    PDFImageView* imageView = [[PDFImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [imageView setImage:image];
    [view addSubview:imageView];
    
The `PDFImageView` will automatically make sure a pixel perfect version of the loaded PDF is drawn to screen, even if the view is resized or animated.

A `UIImage` can be generated as so:

    PDFImage* image = [PDFImage imageNamed:@"email"];
    
    PDFImageOptions* options = [PDFImageOptions optionsWithSize:CGSizeMake(50, 50)];
    
    UIImage* result = [image imageWithOptions:options];
    
By default, the resulting `UIImage` is drawn scale to fill. If required, the options can use any `UIViewContentMode` to adjust how the result is drawn.

    PDFImage* image = [PDFImage imageNamed:@"email"];
    
    PDFImageOptions* options = [PDFImageOptions optionsWithSize:CGSizeMake(50, 50)];
    [options setContentMode:UIViewContentModeScaleAspectFit];
    
    UIImage* result = [image imageWithOptions:options];


A tintColor can also be specified to change the entire color, useful for reusing the same graphics in different colors.

    PDFImageOptions* options = ...;
    [options setTintColor:[UIColor redColor]];
    
    //  or
    
    PDFImageView* imageView = ...;
    [imageView setTintColor:[UIColor redColor]];

See the included headers of the [`PDFImage.framework`](../../releases/latest) for the full API interface.

See the `PDFImageDemo` target in `PDFImage.xcodeproj` for more examples.


Details
-----

`PDFImage` is thread safe. Obviously this does not extend to the view subclasses included.

`PDFImage` uses ARC, however if you use the precompiled [`PDFImage.framework`](../../releases/latest) it is fully compatible with MRC projects and does not require any additional compiler flags.

For optimal performance, `NSCache` is used to memory-cache both bundled PDF files as well as generated `UIImages`. These are automatically purged when the device runs low on memory, or if the App is terminated.
