//
//  FileOperation.h
//  thColorSort
//
//  Created by huanghu on 2017/6/12.
//  Copyright © 2017年 charles. All rights reserved.
//

#import <Foundation/Foundation.h>
static NSString *languageDefaultsArrayKey = @"languageArray";
static NSString *languageDefaultsKey = @"userLanguage";
@interface FileOperation : NSObject
+(NSString*) copyFile2Documents:(NSString*)fileName fromPath:(NSString*)sourcePath;
+(BOOL)readConfigFileToUserDefaultsWithFilePath:(NSString *)filePath;
+(void)checkIsFirst;
@end
