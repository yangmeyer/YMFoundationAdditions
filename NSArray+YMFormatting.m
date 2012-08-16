
//  Created by YangMeyer on 14.08.12.
//  Copyright (c) 2012 zenplaya Inc. All rights reserved.

#import "NSArray+YMFormatting.h"

@implementation NSArray (YMFormatting)

- (NSString*) formattedListOfElementsUsingLinePrefix:(NSString*)prefix {
	return ([self count]
			? [prefix stringByAppendingString:[self componentsJoinedByString:[NSString stringWithFormat:@"\n%@", prefix]]]
			: @"");
}

@end
