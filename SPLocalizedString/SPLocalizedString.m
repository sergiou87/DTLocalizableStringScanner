//
//  SPLocalizedString.m
//  genstrings2
//
//  Created by Sergio Padrino on 25/01/14.
//  Copyright (c) 2014 Sergio Padrino All rights reserved.
//

#import "SPLocalizedString.h"

#pragma mark - Regular localized strings (without plural)

NSString *SPLocalization_localizedString(NSString *key, NSString *context, NSString *table, NSBundle *bundle, NSString *value)
{
    return NSLocalizedStringWithDefaultValue(key, table, bundle, value, comment);
}

#pragma mark - Plural localized strings

NSString *SPLocalization_localizedStringPlural(NSString *keyOne, NSString *keyOther, NSString *context, NSInteger count, NSString *table, NSBundle *bundle, NSString *value)
{
    NSString *key = (count == 1 ? keyOne : keyOther);
    return NSLocalizedStringWithDefaultValue(key, table, bundle, value, comment);
}
