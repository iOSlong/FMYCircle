//
//  RegionCountry.m
//  XWJSC
//
//  Created by xuewu.long on 16/12/21.
//  Copyright © 2016年 fmylove. All rights reserved.
//

#import "RegionCountry.h"

@implementation RegionCountry

- (NSString *)name {
    return [[self.regionCountry componentsSeparatedByString:@","] firstObject];
}
- (NSString *)ID {
    return [[self.regionCountry componentsSeparatedByString:@","] lastObject];
}

@end
