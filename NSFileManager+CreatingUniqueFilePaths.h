
//  Created by YangMeyer on 04.10.12.
//  Copyright (c) 2012 Yang Meyer. All rights reserved.

#import <Foundation/Foundation.h>

@interface NSFileManager (CreatingUniqueFilePaths)

+ (NSString*)ym_documentsPath;

+ (NSString *)ym_uniquePathForFileWithExtension:(NSString *)extension;

@end
