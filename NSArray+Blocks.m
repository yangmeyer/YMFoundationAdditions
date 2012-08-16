
//  Created by Yang Meyer on 03.05.12.
//  Copyright (c) 2012 Yang Meyer. All rights reserved.

#import "NSArray+Blocks.h"

@implementation NSArray (Blocks)

- (NSArray*) map:(id(^)(id))f {
	NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];
	for (id object in self) {
		[result addObject:f(object)];
	}
	return [NSArray arrayWithArray:result];
}

- (NSArray*) select:(BOOL(^)(id))condition {
	NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];
	for (id object in self) {
		if (condition(object)) {
			[result addObject:object];
		}
	}
	return [NSArray arrayWithArray:result];
}

- (BOOL) containsObjectMatchingCondition:(BOOL(^)(id))condition {
	return [[self select:condition] count] > 0;
}

@end
