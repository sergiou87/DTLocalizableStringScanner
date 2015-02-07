//
// SPLocalizedString.h
//
// The MIT License (MIT)
//
// Copyright (c) 2014 Sergio Padrino
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <Foundation/Foundation.h>

#define SPLocalizedStringWithDefaultValue(key, context, table, bundle, value) \
SPLocalization_localizedString([NSString stringWithFormat:@"%@%@", @"(" context @")", key], context, table, bundle, value)

#define SPLocalizedStringFromTableInBundle(key, context, table, bundle) \
SPLocalizedStringWithDefaultValue(key, context, table, bundle, key)

#define SPLocalizedStringFromTable(key, context, table) \
SPLocalizedStringFromTableInBundle(key, context, table, [NSBundle mainBundle])

#define SPLocalizedString(key, context) \
SPLocalizedStringFromTable(key, context, nil)

NSString *SPLocalization_localizedString(NSString *key, NSString *context, NSString *table, NSBundle *bundle, NSString *value);





#define SPLocalizedStringPluralWithDefaultValue(key, context, count, table, bundle, value) \
SPLocalization_localizedStringPlural([NSString stringWithFormat:@"%@%@", @"(" context @"##one)", key], [NSString stringWithFormat:@"%@%@", @"(" context @"##other)", key], context, count, table, bundle, value)

#define SPLocalizedStringPluralFromTableInBundle(key, context, count, table, bundle) \
SPLocalizedStringPluralWithDefaultValue(key, context, count, table, bundle, key)

#define SPLocalizedStringPluralFromTable(key, context, count, table) \
SPLocalizedStringPluralFromTableInBundle(key, context, count, table, [NSBundle mainBundle])

#define SPLocalizedStringPlural(key, context, count) \
SPLocalizedStringPluralFromTable(key, context, count, nil)

NSString *SPLocalization_localizedStringPlural(NSString *keyOne, NSString *keyOther, NSString *context, NSInteger count, NSString *table, NSBundle *bundle, NSString *value);
