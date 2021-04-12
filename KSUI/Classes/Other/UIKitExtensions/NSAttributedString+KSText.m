//
//  NSAttributedString+YYText.m
//
//  Created by zhu hao on 2019/12/19.
//  Copyright © 2019 凯声文化. All rights reserved.
//

#import "NSAttributedString+KSText.h"

@implementation NSAttributedString (KSText)

@end

@implementation NSMutableAttributedString (KSText)

- (void)setAttribute:(NSString *)name value:(id)value range:(NSRange)range {
    if (!name || [NSNull isEqual:name]) return;
    if (value && ![NSNull isEqual:value]) [self addAttribute:name value:value range:range];
    else [self removeAttribute:name range:range];
}

#pragma mark - Property Setter

- (void)setFont:(UIFont *)font {
    [self setFont:font range:NSMakeRange(0, self.length)];
}

- (void)setColor:(UIColor *)color {
    [self setColor:color range:NSMakeRange(0, self.length)];
}

- (void)setTextStrikethrough{
    [self setTextStrikethroughRange:NSMakeRange(0, self.length)];
}

- (void)textVerticalAlignment{
    /// 重新设置baselineOffset 让其他文本相对于第一个文本垂直居中
    __block UIFont *firstFont;
    __block UIFont *font;
    __block BOOL first = YES;
    [self enumerateAttributesInRange:NSMakeRange(0, self.length) options:1 usingBlock:^(NSDictionary<NSAttributedStringKey, id> *attrs, NSRange range, BOOL * _Nonnull stop) {
        if(attrs.count == 0 || attrs == nil){
            *stop = YES;
        }
        if(first){
            firstFont = [attrs valueForKey:NSFontAttributeName];
            first = NO;
        }
        font = [attrs valueForKey:NSFontAttributeName];
        if(firstFont != nil && font != nil && firstFont != font){
            // 垂直居中
            [self addAttributes:@{NSBaselineOffsetAttributeName:@((firstFont.lineHeight - font.lineHeight)/2 + ((firstFont.descender - font.descender)))} range:range];
        }
    }];
}

#pragma mark - Range Setter

- (void)setFont:(UIFont *)font range:(NSRange)range {
    [self setAttribute:NSFontAttributeName value:font range:range];
}

- (void)setColor:(UIColor *)color range:(NSRange)range {
    [self setAttribute:NSForegroundColorAttributeName value:color range:range];
}

- (void)setTextStrikethroughRange:(NSRange)range {
    [self setAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:range];
}

@end
