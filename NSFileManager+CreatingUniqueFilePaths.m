
//  Created by YangMeyer on 04.10.12.
//  Copyright (c) 2012 Yang Meyer. All rights reserved.

#import "NSFileManager+CreatingUniqueFilePaths.h"

@implementation NSFileManager (CreatingUniqueFilePaths)

+ (NSString*)ym_documentsPath
{
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSAssert([paths count] > 0, @"Cannot find Documents directory!");
	return [paths objectAtIndex:0];
}

+ (NSString *)ym_uniquePathForFileWithExtension:(NSString *)extension
{
    NSString* pseudoUniqueIdentifier = [[NSProcessInfo processInfo] globallyUniqueString];
	NSString* fileName = [pseudoUniqueIdentifier stringByAppendingPathExtension:extension];
	return [[self ym_documentsPath] stringByAppendingPathComponent:fileName];
}

@end
