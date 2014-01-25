//
//  SPLocalizedString.h
//  genstrings2
//
//  Created by Sergio Padrino on 25/01/14.
//  Copyright (c) 2014 Sergio Padrino All rights reserved.
//

#import <Foundation/Foundation.h>

//#define NSLocalizedString(key, comment) \
//[[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]

//#define NSLocalizedStringFromTable(key, tbl, comment) \
//[[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:(tbl)]

//#define NSLocalizedStringFromTableInBundle(key, tbl, bundle, comment) \
//[bundle localizedStringForKey:(key) value:@"" table:(tbl)]

//#define NSLocalizedStringWithDefaultValue(key, tbl, bundle, val, comment) \
//[bundle localizedStringForKey:(key) value:(val) table:(tbl)]

#define SPLocalizedStringWithDefaultValue(key, context, table, bundle, value) \
SPLocalization_localizedString(@"(" context @")" key, context, table, bundle, value)

#define SPLocalizedStringFromTableInBundle(key, context, table, bundle) \
SPLocalizedStringWithDefaultValue(key, context, table, bundle, key)

#define SPLocalizedStringFromTable(key, context, table) \
SPLocalizedStringFromTableInBundle(key, context, table, [NSBundle mainBundle])

#define SPLocalizedString(key, context) \
SPLocalizedStringFromTable(key, context, nil)

NSString *SPLocalization_localizedString(NSString *key, NSString *context, NSString *table, NSBundle *bundle, NSString *value);





#define SPLocalizedStringPluralWithDefaultValue(key, context, count, table, bundle, value) \
SPLocalization_localizedStringPlural(@"(" context @"##one)" key, @"(" context @"##other)" key, context, count, table, bundle, value)

#define SPLocalizedStringPluralFromTableInBundle(key, context, count, table, bundle) \
SPLocalizedStringPluralWithDefaultValue(key, context, count, table, bundle, key)

#define SPLocalizedStringPluralFromTable(key, context, count, table) \
SPLocalizedStringPluralFromTableInBundle(key, context, count, table, [NSBundle mainBundle])

#define SPLocalizedStringPlural(key, context, count) \
SPLocalizedStringPluralFromTable(key, context, count, nil)

NSString *SPLocalization_localizedStringPlural(NSString *keyOne, NSString *keyOther, NSString *context, NSInteger count, NSString *table, NSBundle *bundle, NSString *value);
