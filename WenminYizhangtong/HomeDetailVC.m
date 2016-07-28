//
//  HomeDetailVC.m
//  WenminYizhangtong
//
//  Created by sgyaaron on 16/7/23.
//  Copyright © 2016年 alexyang. All rights reserved.
//

#import "HomeDetailVC.h"

@interface HomeDetailVC ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *homeDetailView;

@end

@implementation HomeDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"新闻中心";
//    self.strDetailUrl = @"http://wmyzt.applinzi.com/admin.php?r=article/Content/index&content_id=5";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.strDetailUrl]];
    [_homeDetailView loadRequest:request];
    _homeDetailView.delegate = self;
    
}

//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    
//    [webView stringByEvaluatingJavaScriptFromString:@"var script2 = document.createElement('script');"
//     "script.type = 'text/javascript';"
//     "script.text = \"function myFunction() { "
//     "    var share_desc = '';"
//     "    var meta = document.getElementsByTagName('meta');"
//     "    for(i in meta){"
//     "        if(typeof meta[i].name!=\"undefined\"&&meta[i].name.toLowerCase()==\"description\"){"
//     "            share_desc = meta[i].content;"
//     "        }"
//     "    }"
//     "    return share_desc;"
//     "}\";"
//     "document.getElementsByTagName('head')[0].appendChild(script2);"];
//     NSString *strDesc = [webView stringByEvaluatingJavaScriptFromString:@"myFunction();"
//      ];
//    NSString *strText = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//    NSString *strDesc0 = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('meta')[0].value"];
//    NSLog(@"webViewDidFinishLoad:%@",strText);
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
