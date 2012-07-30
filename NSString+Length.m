
//  Created by YangMeyer on 30.07.12.
//  Copyright (c) 2012 Yang Meyer. All rights reserved.

#import "NSString+Length.h"

@implementation NSString (Length)

- (BOOL) containsText {
	return [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0;
}

@end
