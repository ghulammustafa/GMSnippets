//
//  GMViewController.m
//  GMSnippets
//
//  Created by Mustafa on 31/07/2014.
//  Copyright (c) 2014 Learning. All rights reserved.
//

#import <SystemConfiguration/CaptiveNetwork.h>
#include <ifaddrs.h>
#include <arpa/inet.h>

#import "GMViewController.h"
#import "GMMapViewController.h"
#import "GMPrintViewController.h"
#import "GMDocumentsViewController.h"
#import "GMBarcodeScannerViewController.h"

#import "AFNetworking.h"
#import "Reachability.h"

typedef enum kGMAction {
    kGMActionUploadVideo,
    kGMActionWiFiSSID,
    kGMActionCurrentIP,
    kGMActionCarrierInformation,
    kGMActionMapsPlayground,
    kGMActionPrintPlayground,
    kGMActionDocumentsPlayground,
    kGMActionBarcodeScanning,
    kGMActionCount
} kGMAction;

#pragma mark -

@interface GMViewController ()

@property (weak, nonatomic) IBOutlet UITableView *vcTableView;

@end

#pragma mark -

@implementation GMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kGMActionCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    switch (indexPath.row) {

        case kGMActionUploadVideo:
            cell.textLabel.text = @"Upload Video";
            break;
            
        case kGMActionWiFiSSID:
            cell.textLabel.text = @"WiFi SSID";
            break;

        case kGMActionCurrentIP:
            cell.textLabel.text = @"Current IP";
            break;

        case kGMActionCarrierInformation:
            cell.textLabel.text = @"Carrier Information";
            break;
            
        case kGMActionMapsPlayground:
            cell.textLabel.text = @"Maps Playground";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
            
        case kGMActionPrintPlayground:
            cell.textLabel.text = @"Print Playground";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
            
        case kGMActionDocumentsPlayground:
            cell.textLabel.text = @"Documents Playground";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
            
        case kGMActionBarcodeScanning:
            cell.textLabel.text = @"Barcode Scanning";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
            
        default:
            cell.textLabel.text = @"N/A";
            break;
    }
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
            
        case kGMActionUploadVideo:
            [self uploadVideo];
            break;
            
        case kGMActionWiFiSSID:
            [self showWiFiSSID];
            break;

        case kGMActionCurrentIP:
            [self showIPAddress];
            break;

        case kGMActionCarrierInformation:
            [self showCarrierInfo];
            break;
            
        case kGMActionMapsPlayground:
            [self showMapViewController];
            break;

        case kGMActionPrintPlayground:
            [self showPrintViewController];
            break;
            
        case kGMActionDocumentsPlayground:
            [self showDocumentsViewController];
            break;
            
        case kGMActionBarcodeScanning:
            [self showBarcodeScanningViewController];
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark Action methods

- (void)showBarcodeScanningViewController {
    GMBarcodeScannerViewController *viewController = [[GMBarcodeScannerViewController alloc] initWithNibName:@"GMBarcodeScannerViewController" bundle:nil];
    viewController.title = @"Barcode Scanner";
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)showDocumentsViewController {
    GMDocumentsViewController *viewController = [[GMDocumentsViewController alloc] initWithNibName:@"GMDocumentsViewController" bundle:nil];
    viewController.title = @"Documents Playground";
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)showPrintViewController {
    GMPrintViewController *viewController = [[GMPrintViewController alloc] initWithNibName:@"GMPrintViewController" bundle:nil];
    viewController.title = @"Print Playground";
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)showMapViewController {
    GMMapViewController *viewController = [[GMMapViewController alloc] initWithNibName:@"GMMapViewController" bundle:nil];
    viewController.title = @"Maps Playground";
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)showCarrierInfo {
    // Check reachability
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    NSString *message = nil;

    if(status == NotReachable) {
        NSLog(@"No internet");
        message = @"No internet connection found";
        
    } else if (status == ReachableViaWiFi) {
        NSLog(@"WiFi");
        message = @"Device is connected to a WiFi network";
        
    } else if (status == ReachableViaWWAN) {
        NSLog(@"3G");
        message = @"Device is connected to a 3G network";
    }

    CTTelephonyNetworkInfo *telephonyNetworkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = telephonyNetworkInfo.subscriberCellularProvider;
    NSString *mobileCountryCode = carrier.mobileCountryCode;
    NSString *carrierName = carrier.carrierName;
    NSString *isoCountryCode = carrier.isoCountryCode;
    NSString *mobileNetworkCode = carrier.mobileNetworkCode;
    
    NSString *information = [NSString stringWithFormat:@"Mobile Country Code: %@\nCarrier Name: %@\nISO Country Code: %@\nMobile Network Code: %@",
                             mobileCountryCode, carrierName, isoCountryCode, mobileNetworkCode];
    
    message = [NSString stringWithFormat:@"%@\n\n%@", message, information];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Carrier Information"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil,
                              nil];
    [alertView show];
}

- (void)showIPAddress {
    NSString *ip = [self getIPAddress];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"IP"
                                                        message:ip
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil,
                              nil];
    [alertView show];
}

- (void)showWiFiSSID {
    
    // Check reachability
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if(status == NotReachable) {
        NSLog(@"No internet");

    } else if (status == ReachableViaWiFi) {
        NSLog(@"WiFi");

    } else if (status == ReachableViaWWAN) {
        NSLog(@"3G");
    }

    // Get SSID and show the result in an alert
    NSString *ssid = [GMViewController currentWifiSSID];

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"WiFi SSID"
                                                        message:ssid
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil,
                              nil];
    [alertView show];
}

- (void)uploadVideo {
    NSURL *baseURL = [NSURL URLWithString:@"http://tempurl.org/path/base/"];
    NSString *fileUploadURLString = @"http://tempurl.org/path/base/imageUpload_mobile.ashx";
    NSString *fileName = @"Sample";
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Sample" ofType:@"jpg"];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"1000", @"userID",
                                @"imageName.jpg", @"imageName",
                                @"!@#uploadPic123" , @"imageUploadKey",
                                nil];
    
    // Create requestGMSnippets
    AFHTTPRequestOperationManager *operationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    AFHTTPRequestOperation *operation = [operationManager POST:fileUploadURLString
                                                    parameters:parameters
                                     constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                         NSError *error = nil;
                                         [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:fileName error:&error];
                                     }
                                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                           NSLog(@"Upload Completed!");
                                                       }
                                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                           NSLog(@"Upload Failed!");
                                                           NSLog(@"error: %@", operation.responseString);
                                                           NSLog(@"%@",error);
                                                       }];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"Uploaded %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    
    [operation start];
}

#pragma mark -
#pragma mark Helper methods/ possible category methods

- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
} 

+ (NSString *)currentWifiSSID {
    NSString *ssid = nil;
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    for (NSString *ifnam in ifs) {
        NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSLog(@"Supported Interface Information: %@", info);
        
        if (info[@"SSID"]) {
            ssid = info[@"SSID"];
        }
    }
    return ssid;
}

@end
