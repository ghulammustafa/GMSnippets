//
//  GMBarcodeScannerViewController.m
//  GMSnippets
//
//  Created by Mustafa on 21/01/2015.
//  Copyright (c) 2015 Learning. All rights reserved.
//

#import "GMBarcodeScannerViewController.h"
#import "MTBBarcodeScanner.h"

#pragma mark -

@interface GMBarcodeScannerViewController ()

@property (strong, nonatomic) MTBBarcodeScanner *scanner;
@property (strong, nonatomic) NSMutableArray *uniqueCodes;
@property (strong, nonatomic) NSMutableArray *uniqueCodeTypes;

@property (weak, nonatomic) IBOutlet UIView *previewView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *scanButton;

- (IBAction)toggleScanButtonTapped:(id)sender;

@end

#pragma mark -

@implementation GMBarcodeScannerViewController

#pragma mark - Properties

- (void)setUniqueCodes:(NSMutableArray *)uniqueCodes {
    _uniqueCodes = uniqueCodes;
    [self.tableView reloadData];
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // UI styling (minor)
    self.previewView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.previewView.layer.borderWidth = 1.0f;
    
    self.tableView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.tableView.layer.borderWidth = 1.0;
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.scanner stopScanning];
    [super viewWillDisappear:animated];
}

#pragma mark - Scanner

- (MTBBarcodeScanner *)scanner {
    
    if (!_scanner) {
        _scanner = [[MTBBarcodeScanner alloc] initWithPreviewView:_previewView];
    }
    
    return _scanner;
}

#pragma mark - Scanning

- (void)startScanning {
    self.uniqueCodeTypes = [[NSMutableArray alloc] init];
    self.uniqueCodes = [[NSMutableArray alloc] init];
    
    [self.scanner startScanningWithResultBlock:^(NSArray *codes) {
        
        for (AVMetadataMachineReadableCodeObject *code in codes) {
            
            if (code.stringValue && [self.uniqueCodes indexOfObject:code.stringValue] == NSNotFound) {
                [self.uniqueCodes addObject:code.stringValue];
                
                if ([code.type isEqualToString:AVMetadataObjectTypeUPCECode]) {
                    [self.uniqueCodeTypes addObject:@"UPC-E"];
                    
                } else if ([code.type isEqualToString:AVMetadataObjectTypeCode39Code]) {
                    [self.uniqueCodeTypes addObject:@"Code 39"];
                    
                } else if ([code.type isEqualToString:AVMetadataObjectTypeCode39Mod43Code]) {
                    [self.uniqueCodeTypes addObject:@"Code 39 mod 43"];
                    
                } else if ([code.type isEqualToString:AVMetadataObjectTypeEAN13Code]) {
                    [self.uniqueCodeTypes addObject:@"EAN-13 (including UPC-A)"];
                    
                } else if ([code.type isEqualToString:AVMetadataObjectTypeEAN8Code]) {
                    [self.uniqueCodeTypes addObject:@"EAN-8"];
                    
                } else if ([code.type isEqualToString:AVMetadataObjectTypeCode93Code]) {
                    [self.uniqueCodeTypes addObject:@"Code 93"];
                    
                } else if ([code.type isEqualToString:AVMetadataObjectTypeCode128Code]) {
                    [self.uniqueCodeTypes addObject:@"Code 128"];
                    
                } else if ([code.type isEqualToString:AVMetadataObjectTypePDF417Code]) {
                    [self.uniqueCodeTypes addObject:@"PDF417"];
                    
                } else if ([code.type isEqualToString:AVMetadataObjectTypeQRCode]) {
                    [self.uniqueCodeTypes addObject:@"QR"];
                    
                } else if ([code.type isEqualToString:AVMetadataObjectTypeAztecCode]) {
                    [self.uniqueCodeTypes addObject:@"Aztec"];
                    
                } else if ([code.type isEqualToString:AVMetadataObjectTypeInterleaved2of5Code]) {
                    [self.uniqueCodeTypes addObject:@"Interleaved 2 of 5"];
                    
                } else if ([code.type isEqualToString:AVMetadataObjectTypeITF14Code]) {
                    [self.uniqueCodeTypes addObject:@"ITF14"];
                    
                } else if ([code.type isEqualToString:AVMetadataObjectTypeDataMatrixCode]) {
                    [self.uniqueCodeTypes addObject:@"DataMatrix"];
                    
                } else {
                    [self.uniqueCodeTypes addObject:code.type];
                }
                
                NSLog(@"Found unique code: %@ (%@)", code.stringValue, code.type);
                
                // Update the tableview
                [self.tableView reloadData];
                [self scrollToLastTableViewCell];
            }
        }
    }];
    
    [self.scanButton setTitle:@"Stop Scanning" forState:UIControlStateNormal];
    self.scanButton.backgroundColor = [UIColor redColor];
}

- (void)stopScanning {
    [self.scanner stopScanning];
    
    [self.scanButton setTitle:@"Start Scanning" forState:UIControlStateNormal];
    self.scanButton.backgroundColor = self.view.tintColor;
}

#pragma mark - Actions

- (IBAction)toggleScanButtonTapped:(id)sender {
    
    if ([self.scanner isScanning]) {
        [self stopScanning];
        
    } else {
        [MTBBarcodeScanner requestCameraPermissionWithSuccess:^(BOOL success) {
            
            if (success) {
                [self startScanning];
                
            } else {
                [self displayPermissionMissingAlert];
            }
        }];
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"SubtitleBarcodeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    
    cell.textLabel.text = self.uniqueCodes[indexPath.row];
    cell.detailTextLabel.text = self.uniqueCodeTypes[indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.uniqueCodes.count;
}

#pragma mark - Helper Methods

- (void)displayPermissionMissingAlert {
    NSString *message = nil;
    
    if ([MTBBarcodeScanner scanningIsProhibited]) {
        message = @"This app does not have permission to use the camera.";
        
    } else if (![MTBBarcodeScanner cameraIsPresent]) {
        message = @"This device does not have a camera.";
        
    } else {
        message = @"An unknown error occurred.";
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Scanning Unavailable"
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"Ok"
                      otherButtonTitles:nil] show];
}

- (void)scrollToLastTableViewCell {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.uniqueCodes.count - 1 inSection:0];
    
    [self.tableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
}

@end
