
//  Created by YangMeyer on 08.10.12.
//  Copyright (c) 2012 Yang Meyer. All rights reserved.

#import <Foundation/Foundation.h>

@interface NSObject (YMOptionsAndDefaults)

/**
 Idempotent - calling multiple times simply overwrites previous values.
 @param	options 	optional, may be nil
 @param	defaults	required
 */
- (void)ym_registerOptions:(NSDictionary *)options
				  defaults:(NSDictionary *)defaults;

/**
 @param	optionKey	required
 @return the value from the options dictionary if it was set, or the default value otherwise.
 */
- (id)ym_optionOrDefaultForKey:(NSString*)optionKey;

@end
