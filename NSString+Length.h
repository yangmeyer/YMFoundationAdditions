
//  Created by YangMeyer on 30.07.12.
//  Copyright (c) 2012 Yang Meyer. All rights reserved.

@interface NSString (Length)

- (BOOL) containsText;

- (BOOL) containsSubstring:(NSString*)substring;
- (BOOL) containsAnySubstring:(NSArray*)substrings;
- (BOOL) containsAllSubstrings:(NSArray*)substrings;

@end
