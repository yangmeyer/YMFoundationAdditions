
//  Created by YangMeyer on 12.11.12.
//  Copyright (c) 2012 Yang Meyer. All rights reserved.

#import "NSArray+Fill.h"

@implementation NSMutableArray (Fill)

+ (instancetype) arrayWithElements:(NSObject*)elem count:(NSUInteger)count
{
	NSMutableArray *result = [self arrayWithCapacity:count];
	for (NSUInteger i = 0; i < count; i++) {
		[result addObject:elem];
	}
	return result;
}

@end


@implementation NSArray (Fill)

+ (instancetype) arrayWithElements:(NSObject*)elem count:(NSUInteger)count
{
	return [NSArray arrayWithArray:[NSMutableArray arrayWithElements:elem count:count]];
}

@end
