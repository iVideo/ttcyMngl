//
//  MusicFileManager.m
//  TifWayMusic
//
//  Created by Maple on 8/18/13.
//
//

#import "MusicFileManager.h"

#define NSUSERDOCUMENT(dir)  [NSString stringWithFormat:@"%@/CachesMusic",dir]
#define NSTEMPUSERDOCUMENT(dir)  [NSString stringWithFormat:@"%@/TempMusic",dir]
@implementation MusicFileManager

+ (NSString*)getCurrentTimeString
{
    NSDateFormatter *dateformat=[[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:@"yyyyMMddHHmmss"];
    return [dateformat stringFromDate:[NSDate date]];
}

+ (BOOL)fileExistsAtPath:(NSString*)_path
{
    return [[NSFileManager defaultManager] fileExistsAtPath:_path];
}


+ (NSString*)getMusicCacheDirectory
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];

    return NSUSERDOCUMENT(path);
}

+ (NSString*)getTempMusicCacheDirectory
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    
    return NSTEMPUSERDOCUMENT(path);
}


+ (void)clearVoiceCache{
    [[NSFileManager defaultManager] removeItemAtPath:[self getMusicCacheDirectory] error:nil];
}


+ (BOOL)deleteFileAtPath:(NSString*)_path
{
    return [[NSFileManager defaultManager] removeItemAtPath:_path error:nil];
}


+ (NSString*)getPathByFileName:(NSString *)_fileName ofType:(NSString *)_type
{
    NSString* fileDirectory = [[[self getMusicCacheDirectory] stringByAppendingPathComponent:_fileName] stringByAppendingPathExtension:_type];
    return fileDirectory;
}

+ (NSString*)getPathByFileName:(NSString *)_fileName{
    NSString* fileDirectory = [[self getMusicCacheDirectory] stringByAppendingPathComponent:_fileName];
    return fileDirectory;
}


+ (NSString*)getTempPathByFileName:(NSString *)_fileName{
    NSString* fileDirectory = [[self getTempMusicCacheDirectory] stringByAppendingPathComponent:_fileName];
    return fileDirectory;
}

+ (void)createMusicCache{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *musicDir = NSUSERDOCUMENT([paths objectAtIndex:0]);
    BOOL isDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:musicDir isDirectory:&isDir];
    
    if (!existed) {
        [fileManager createDirectoryAtPath:musicDir withIntermediateDirectories:YES attributes:nil error:nil];
        
    }
    NSString *temMusicDir = NSTEMPUSERDOCUMENT([paths objectAtIndex:0]);
    existed = [fileManager fileExistsAtPath:temMusicDir isDirectory:&isDir];
    if (!existed) {
        [fileManager createDirectoryAtPath:musicDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
}

+ (void)clearMusicCache{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *musicDir = NSUSERDOCUMENT([paths objectAtIndex:0]);
    [fileManager removeItemAtPath:musicDir error:nil];
    [fileManager createDirectoryAtPath:musicDir withIntermediateDirectories:YES attributes:nil error:nil];

}

+ (void)clearTempMusicCache{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *tempMusicDir = NSTEMPUSERDOCUMENT([paths objectAtIndex:0]);
    [fileManager removeItemAtPath:tempMusicDir error:nil];
    [fileManager createDirectoryAtPath:tempMusicDir withIntermediateDirectories:YES attributes:nil error:nil];
}

@end
