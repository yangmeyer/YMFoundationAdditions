
//  Created by Yang Meyer on 03.05.12.
//  Copyright (c) 2012 Yang Meyer. All rights reserved.

/**
 Adds functional programming idioms to NSArray.
 */
@interface NSArray (Blocks)

/** Returns a new array with `aBlock` applied to each element of self. */
- (NSArray*) map:(id(^)(id))aBlock;

/** Returns a new array with only those elements conforming to the given condition,
	i.e. where calling `condition(element)` returns YES. */
- (NSArray*) select:(BOOL(^)(id))condition;

- (BOOL) containsObjectMatchingCondition:(BOOL(^)(id))condition;

@end
