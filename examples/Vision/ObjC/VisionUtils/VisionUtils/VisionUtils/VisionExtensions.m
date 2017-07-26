//
//  VisionExtensions.m
//  VisionUtils
//
//  Created by Vitaly Cherevaty on 7/26/17.
//  Copyright © 2017 Codeminders. All rights reserved.
//

#import "VisionExtensions.h"

@implementation VNFaceLandmarkRegion2D(VisionUtils)

-(NSPoint)vut_pointAtIndex:(NSUInteger)index
{
    vector_float2 vec2 = [self pointAtIndex:index];
    return NSMakePoint(vec2.x, vec2.y);
}

@end

@implementation VUTHelper

@end

