//
//  FMDBManager+CollectSong.m
//  TtcyMngl
//
//  Created by Lucky_Truda on 14-6-26.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "FMDBManager+CollectSong.h"
#import "HUD.h"

@implementation FMDBManager (CollectSong)

-(int)getCollectSongCountWithuserID:(NSString *)phone
{
    [_db open];
    int count = 0;
    NSMutableArray *countResult = [self queryByConfition:[NSString stringWithFormat:@"SELECT count(*) FROM %@ WHERE phone = %@", TABLE_CollectSong, phone]];
    if(countResult && [countResult count] > 0){
        NSDictionary *dic = [countResult objectAtIndex:0];
        count = [[dic objectForKey:@"count(*)"] intValue];
    }
    [_db close];
    return count;
}

- (void)addCollectSong:(SongObject *)songObj userID:(NSString *)phone callBack:(void (^)(BOOL))callBack
{
    BOOL isExist = NO;//是否收藏该歌曲
    NSMutableArray *collectSongAry = [self getCollectSongListWithuserID:phone];
    for (SongObject *song in collectSongAry) {
        if ([song.songUrl isEqualToString:songObj.songUrl]) {
            [HUD message:@"      "];
            NSLog(@"收藏失败，因为已收藏该歌曲");
            isExist = YES;
            break;
        }else {
            isExist = NO;
        }
    }
    if (isExist == NO) {
        [_db open];
        NSString* sql = [NSString stringWithFormat:INSERT_COLLECTSONG_TABLE,TABLE_CollectSong];
        if ([_db executeUpdate:sql,COLLECTSONG_PARAMETER]){
            NSLog(@"insert collect song successed");
            callBack(YES);
        }
        else{
            NSLog(@"insert collect song failed");
            callBack(NO);
        }
        [_db close];
    }
}

- (NSMutableArray *)getCollectSongListWithuserID:(NSString *)phone
{
    [_db open];
    NSMutableArray *songList = [[NSMutableArray alloc] init];
    NSMutableArray *dataList = [self queryByConfition:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE phone = %@", TABLE_CollectSong, phone]];
    if (dataList && [dataList count]>0) {
        for (int i = 0; i < [dataList count]; i++) {
            NSDictionary *songDit = [dataList objectAtIndex:i];
            [songList addObject:[self fliterDictionaryToSongObject:songDit]];
        }
        [_db close];
        return songList;
    }
    [_db close];
    return nil;
}

- (void)deleteCollectSongBySongName:(NSString *)songName userID:(NSString *)phone
{
    [_db open];
    NSString* sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@",TABLE_CollectSong,songName];
    if ([_db executeUpdate:sql]) {
        NSLog(@"delete collect song successed");
    }
    else{
        NSLog(@"delete collect song failed");
    }
    [_db close];
}

- (void)deleteAllCollectSongWithuserID:(NSString *)phone
{
    [_db open];
    [_db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@",TABLE_LocalSong]];
    [_db close];
}



@end


