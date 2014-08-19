//
//  MusicFileManager.h
//  TifWayMusic
//
//  Created by Maple on 8/18/13.
//
//

#import <Foundation/Foundation.h>

@interface MusicFileManager : NSObject

/**
 生成当前时间字符串
 @returns 当前时间字符串
 */
+ (NSString*)getCurrentTimeString;

/**
 生成文件路径
 @param _fileName 文件名
 @returns 文件路径
 */
+ (NSString*)getPathByFileName:(NSString *)_fileName;

+ (NSString*)getTempPathByFileName:(NSString *)_fileName;

/**
 生成文件路径
 @param _fileName 文件名
 @param _type 文件类型
 @returns 文件路径
 */
+ (NSString*)getPathByFileName:(NSString *)_fileName ofType:(NSString *)_type;


/**
 删除文件
 @param _path 文件路径
 @returns 成功返回yes
 */
+ (BOOL)deleteFileAtPath:(NSString*)_path;

/**
 清除音频文件缓存
 */
+ (void)clearVoiceCache;

/**
 获取音频文件缓存路径
 @returns 缓存路径
 */
+ (NSString*)getMusicCacheDirectory;

+ (NSString*)getTempMusicCacheDirectory;

/**
 判断文件是否存在
 @param _path 文件路径
 @returns 存在返回yes
 */
+ (BOOL)fileExistsAtPath:(NSString*)_path;

+ (void)createMusicCache;

+ (void)clearMusicCache;

+ (void)clearTempMusicCache;



@end
