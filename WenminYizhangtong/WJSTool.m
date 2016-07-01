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

- (BOOL)validateMobile{
    
    NSString *MOBILE = @"^1[34578]\\d{9}$";
    
    NSPredicate *regexTestMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",MOBILE];
    
    if ([regexTestMobile evaluateWithObject:self]) {
        return YES;
    }else {
        return NO;
    }
}

+ (BOOL) validateEmail:(NSString *)email {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL) validateUserName:(NSString *)name

{
    
    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    
    BOOL B = [userNamePredicate evaluateWithObject:name];
    
    return B;
    
}

+ (BOOL) validatePassword:(NSString *)passWord {
    
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    
    return [passWordPredicate evaluateWithObject:passWord];
    
}

+ (BOOL) validateIdentityCard: (NSString *)identityCard

{
    
    BOOL flag;
    
    if (identityCard.length <= 0) {
        
        flag = NO;
        
        return flag;
        
    }
    
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    
    return [identityCardPredicate evaluateWithObject:identityCard];
    
}
@end
