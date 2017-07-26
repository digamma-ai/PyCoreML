//
//  VisionExtensions.h
//  VisionUtils
//
//  Created by Vitaly Cherevaty on 7/26/17.
//  Copyright © 2017 Codeminders. All rights reserved.
//

#import <Vision/Vision.h>
#import <Cocoa/Cocoa.h>

@interface VNFaceLandmarkRegion2D(VisionUtils)

-(NSPoint)vut_pointAtIndex:(NSUInteger)index;

@end

@interface VUTHelper : NSObject

@end
