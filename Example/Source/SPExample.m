//
//  SPExample.m
//  spgenstrings
//
//  Created by Sergio Padrino on 25/01/14.
//  Copyright (c) 2014 Sergio Padrino All rights reserved.
//

#import "SPExample.h"

#import "SPLocalizedString.h"

@implementation SPExample

- (void)doSomething
{
    NSLog(@"%@", SPLocalizedString(@"Hello world!", @"First hello world"));
    NSLog(@"%@", SPLocalizedString(@"Hello world!", @"Second hello world"));
    NSLog(@"%@", SPLocalizedStringFromTable(@"Hello world!", @"Another text from another table", @"OtherTable"));
    
    for (NSUInteger count = 1; count < 5; count ++)
    {
        NSString *formatString = SPLocalizedStringPlural(@"%d people is following you", @"Followers label description", count);
        NSLog(@"%@", [NSString stringWithFormat:formatString, count]);
    }
}

@end
