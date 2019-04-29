//
//  PDFQLPreviewController.m
//  UITest
//
//  Created by Mark on 2018/3/14.
//  Copyright © 2018年 markcj. All rights reserved.
//

#import "PDFQLPreviewController.h"
#import "Micros.h"
#import "PDFMicros.h"

@implementation PDFQLPreviewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    
    self.delegate = self;
    self.dataSource = self;
}

#pragma mark - QLPreviewControllerDelegate
/*!
 * @abstract Invoked before the preview controller is closed.
 */
- (void)previewControllerWillDismiss:(QLPreviewController *)controller {
    NSLog(@"PDFQLPreviewController preview controller will Dismiss");
}

/*!
 * @abstract Invoked after the preview controller is closed.
 */
- (void)previewControllerDidDismiss:(QLPreviewController *)controller {
    NSLog(@"PDFQLPreviewController preview controller did Dismiss");
}

#pragma mark - QLPreviewControllerDataSource

/*!
 * @abstract Returns the number of items that the preview controller should preview.
 * @param controller The Preview Controller.
 * @result The number of items.
 */
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}

/*!
 * @abstract Returns the item that the preview controller should preview.
 * @param index The index of the item to preview.
 * @result An item conforming to the QLPreviewItem protocol.
 */
- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    NSString *pdfFilePath = [[NSBundle mainBundle] pathForResource:@"Accessory-Design-Guidelines" ofType:@"pdf"];
    return (id <QLPreviewItem>)[NSURL fileURLWithPath:pdfFilePath];
}

@end
