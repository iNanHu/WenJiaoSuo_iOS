//
//  WJSTool.m
//  WenminYizhangtong
//
//  Created by sgyaaron on 16/6/24.
//  Copyright © 2016年 alexyang. All rights reserved.
//
#import <ASIFormDataRequest.h>
#import <TFHpple.h>
#import "WJSTool.h"


@implementation WJSTool

+(NSString*) urlstring:(NSString*)strurl{
    
    NSError *error;
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *htmlData = [[NSString stringWithContentsOfURL:[NSURL
                                                           URLWithString: strurl]
                                                 encoding:enc error:&error]
                        dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *elements  = [xpathParser searchWithXPathQuery:@"//title"]; // get the title
    NSLog(@"%lu",(unsigned long)[elements count]);
    TFHppleElement *element = [elements objectAtIndex:0];
    
    NSString *content = [element content];
    NSString *tagname = [element tagName];
    NSString *attr = [element objectForKey:@"href"];
    NSLog(@"content = %@",content);
    NSLog(@"tagname = %@",tagname);
    NSLog(@"attr is = %@",attr);
    
    return content;
}

+(void)getPostResult:(NSString*)startqi{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@""]];
    
    [request setPostValue:startqi forKey:@"startqi"];
    [request setPostValue:@"20990101001" forKey:@"endqi"];
    [request setPostValue:@"qihao" forKey:@"searchType"];//网页的中的搜索方式
    [request startSynchronous];
    
    NSData* data = [request responseData];
    
    if (data==nil) {
        NSLog(@"has not data");
    }
    else{
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *retStr = [[NSString alloc] initWithData:data encoding:enc];
        NSLog(@"html = %@",retStr);
    }
}


@end
