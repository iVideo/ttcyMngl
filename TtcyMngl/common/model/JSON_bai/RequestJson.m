//
//  RequestJson.m
//  MyMusicPlayer
//
//  Created by 牛利江 on 14-5-24.
//  Copyright (c) 2014年 ttcy. All rights reserved.
//

#import "RequestJson.h"
#import <Reachability.h>

@implementation RequestJson
-(id)getJosnNSArrayUrl:(NSString*)url sid:(NSString *)sid{
    if ([self isConnectionAvailableWithUrl:url]) {
   
        NSError *error;
        //加载一个NSURL对象
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        //将请求的url数据放到NSData对象中
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
       if (response==nil) {
           return nil;
       }
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        
//         将 NSDictionary 保存为plis文件
        
//        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//                                                                  NSUserDomainMask, YES) objectAtIndex:0];
//        NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
//        NSLog(@"%@",plistPath);
//        [json writeToFile:plistPath atomically:YES];
        NSArray *array = [json objectForKey:sid];
          
        return array;
     }
    
    return nil;
   
}
-(BOOL) isConnectionAvailableWithUrl:(NSString*)url{
    
    BOOL isExistenceNetwork = YES;
    NSURL *url2=[NSURL URLWithString:url];
    Reachability *reach = [Reachability reachabilityWithHostname:[url2 host]];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
          
            
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            break;
    }
    
    return isExistenceNetwork;
}


@end
