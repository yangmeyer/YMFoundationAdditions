//
//  NSURL+PathParameters.m
//
//  Created by Johan Kool on 27/9/2011.
//  Copyright 2011 Koolistov Pte. Ltd. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are 
//  permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright notice, this list of 
//    conditions and the following disclaimer.
//  * Neither the name of KOOLISTOV PTE. LTD. nor the names of its contributors may be used to 
//    endorse or promote products derived from this software without specific prior written 
//    permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY 
//  EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF 
//  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 
//  THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
//  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT 
//  OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
//  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS 
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "NSURL+PathParameters.h"

@interface NSString (URLParameters)

- (NSString *)stringByEscapingForURLArgument;

@end

@implementation NSString (URLParameters)

- (NSString *)stringByEscapingForURLArgument {
    // Encode all the reserved characters, per RFC 3986 (<http://www.ietf.org/rfc/rfc3986.txt>)
    NSString *escapedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                  (CFStringRef)self,
                                                                                  NULL,
                                                                                  (CFStringRef)@"!*'\"();:@&=+$,/?%#[] ",
                                                                                  kCFStringEncodingUTF8);
    return [escapedString autorelease];
}

@end

@implementation NSURL (PathParameters)

- (NSURL *)URLByReplacingPathWithPath:(NSString *)path {
    // scheme://username:password@domain:port/path?query_string#fragment_id
    
    // Chop off path, query and fragment from absoluteString, then add new path and put back query and fragment
    
    NSString *absoluteString = [self absoluteString];
    NSUInteger endIndex = [absoluteString length];
    
    NSString *fragment = [self fragment];
    if (fragment) {
        endIndex -= [fragment length];
        endIndex--; // The # character
    }
    
    NSString *query = [self query];
    if (query) {
        endIndex -= [query length];
        endIndex--; // The ? character
    }

    // Check if the last character of the path is a slash (range must be valid as endIndex must be smaller or equal to length)
    BOOL trailingSlashOnPath = [[absoluteString substringWithRange:NSMakeRange(endIndex - 1, 1)] isEqualToString:@"/"];
       
    NSString *originalPath = [self path]; // This method strips any trailing slash "/"
    if (originalPath) {
        endIndex -= [originalPath length];
        if (trailingSlashOnPath && [originalPath length] > 1) { // Don't get confused with the starting slash
            endIndex--;
        }
    }
    
    absoluteString = [absoluteString substringToIndex:endIndex];
    absoluteString = [absoluteString stringByAppendingString:path];
    if (query) {
        absoluteString = [absoluteString stringByAppendingString:@"?"];
        absoluteString = [absoluteString stringByAppendingString:query];
    }
    if (fragment) {
        absoluteString = [absoluteString stringByAppendingString:@"#"];
        absoluteString = [absoluteString stringByAppendingString:fragment];
    }
    
    return [NSURL URLWithString:absoluteString];
}

- (NSURL *)URLByAppendingPathWithRelativePath:(NSString *)path {
    NSString *originalPath = [self path];
    NSString *combinedPath = [[originalPath stringByAppendingPathComponent:path] stringByStandardizingPath];
    // Don't standardize away a trailing slash
    if ([path length] > 1 && [path hasSuffix:@"/"]) {
        combinedPath = [combinedPath stringByAppendingString:@"/"];
    }
    return [self URLByReplacingPathWithPath:combinedPath];
}

- (NSURL *)URLByAppendingParameters:(NSDictionary *)parameters {
    NSMutableString *query = [[[self query] mutableCopy] autorelease];
      
    if (!query) {
        query = [NSMutableString stringWithString:@""];
    }
    
    // Sort parameters to be appended so that our solution is stable (and testable)
    NSArray *parameterNames = [parameters allKeys];
    parameterNames = [parameterNames sortedArrayUsingSelector:@selector(compare:)];
    
    for (NSString *parameterName in parameterNames) {
        id value = [parameters objectForKey:parameterName];
        NSAssert3([parameterName isKindOfClass:[NSString class]], @"Got '%@' of type %@ as key for parameter with value '%@'. Expected an NSString.", parameterName, NSStringFromClass([parameterName class]), value);
        
        // The value needs to be an NSString, or be able to give us an NSString
        if (![value isKindOfClass:[NSString class]]) {
            if ([value respondsToSelector:@selector(stringValue)]) {
                value = [value stringValue];
            } else {
                // Fallback to simply giving the description
                value = [value description];
            }
        }
        
        if ([query length] == 0) {
            [query appendFormat:@"%@=%@", [parameterName stringByEscapingForURLArgument], [value stringByEscapingForURLArgument]];
        } else {
            [query appendFormat:@"&%@=%@", [parameterName stringByEscapingForURLArgument], [value stringByEscapingForURLArgument]];
        }
    }
        
    // scheme://username:password@domain:port/path?query_string#fragment_id
    
    // Chop off query and fragment from absoluteString, then add new query and put back fragment
    
    NSString *absoluteString = [self absoluteString];
    NSUInteger endIndex = [absoluteString length];
    
    NSString *fragment = [self fragment];
    if (fragment) {
        endIndex -= [fragment length];
        endIndex--; // The # character
    }
    
    NSString *originalQuery = [self query];
    if (originalQuery) {
        endIndex -= [originalQuery length];
        endIndex--; // The ? character
    }
    
    absoluteString = [absoluteString substringToIndex:endIndex];
    absoluteString = [absoluteString stringByAppendingString:@"?"];
    absoluteString = [absoluteString stringByAppendingString:query];
    if (fragment) {
        absoluteString = [absoluteString stringByAppendingString:@"#"];
        absoluteString = [absoluteString stringByAppendingString:fragment];
    }
    
    return [NSURL URLWithString:absoluteString];
}

- (NSURL *)URLByAppendingParameterName:(NSString *)parameter value:(id)value {
    return [self URLByAppendingParameters:[NSDictionary dictionaryWithObjectsAndKeys:value, parameter, nil]];
}


@end
