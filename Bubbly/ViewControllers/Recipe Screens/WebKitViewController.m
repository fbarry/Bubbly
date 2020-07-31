//
//  WebKitViewController.m
//  Bubbly
//
//  Created by Fiona Barry on 7/31/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "WebKitViewController.h"
#import <WebKit/WebKit.h>

@interface WebKitViewController ()

@property (weak, nonatomic) IBOutlet WKWebView *webKitView;

@end

@implementation WebKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url
                                        cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                        timeoutInterval:10.0];
    // Load Request into WebView.
    [self.webKitView loadRequest:request];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
