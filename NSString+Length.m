
//  Created by YangMeyer on 30.07.12.
//  Copyright (c) 2012 Yang Meyer. All rights reserved.

#import "NSString+Length.h"

@implementation NSString (Length)

- (BOOL) containsText {
	return [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0;
}

- (BOOL) containsSubstring:(NSString*)substring {
	return [self rangeOfString:substring].location != NSNotFound;
}

- (BOOL) containsAnySubstring:(NSArray*)substrings {
	for (NSString* aSubstring in substrings)
		if ([self containsSubstring:aSubstring])
			return YES;
	return NO;
}

- (BOOL) containsAllSubstrings:(NSArray*)substrings {
	for (NSString* aSubstring in substrings)
		if (![self containsSubstring:aSubstring])
			return NO;
	return YES;
}

@end
