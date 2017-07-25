//
//  main.m
//  Vision_ConsoleTest
//
//  Created by Vitaly Cherevaty on 7/25/17.
//  Copyright © 2017 Codeminders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Vision/Vision.h>
#import <Cocoa/Cocoa.h>

static void drawContour(VNFaceLandmarkRegion2D *region, CGRect box){
    NSUInteger count = region.pointCount;
    NSBezierPath *path = [[NSBezierPath alloc] init];
    
    for(int i = 0; i < count; i++){
        vector_float2 vec2 = [region pointAtIndex:i];
        CGPoint pt = CGPointZero;
        pt.x = box.origin.x + (CGFloat)vec2.x * box.size.width;
        pt.y = box.origin.y + (CGFloat)vec2.y * box.size.height;
        
        if (i == 0) {
            [path moveToPoint:pt];
        } else {
            [path lineToPoint: pt];
        }
    }
    [[NSColor greenColor] set];
    [path stroke];
}

static void drawResults(NSURL *srcImageURL, NSURL *dstImageURL, NSArray *results)
{
    NSImage *image = [[NSImage alloc] initWithContentsOfURL:srcImageURL];
    
    [image lockFocus];
    
    NSSize imageSize = image.size;
    for (VNFaceObservation *result in results) {
        
        CGRect boundingBox = VNImageRectForNormalizedRect(result.boundingBox, imageSize.width, imageSize.height);

        [[NSColor redColor] set];
        [NSBezierPath strokeRect:boundingBox];
        
        
        VNFaceLandmarks2D *landmarks = result.landmarks;
        
        if (landmarks.faceContour != nil) {
            drawContour(landmarks.faceContour, boundingBox);
        }
        
        if (landmarks.nose != nil) {
            drawContour(landmarks.nose, boundingBox);
        }
        
        if (landmarks.leftEye != nil) {
            drawContour(landmarks.leftEye, boundingBox);
        }
        
        if (landmarks.rightEye != nil) {
            drawContour(landmarks.rightEye, boundingBox);
        }
        
        if (landmarks.outerLips != nil) {
            drawContour(landmarks.outerLips, boundingBox);
        }
    }
    
    
    [image unlockFocus];
    
    CGImageRef imageRef = [image CGImageForProposedRect:NULL context:NULL hints:NULL];
    NSBitmapImageRep *bitmap = [[NSBitmapImageRep alloc] initWithCGImage:imageRef];
    NSData *data = [bitmap representationUsingType:NSBitmapImageFileTypeJPEG properties:@{NSImageCompressionFactor:@(1.0)}];
    
    NSError *error = nil;
    BOOL res = [data writeToFile:[dstImageURL path] options:0 error:&error];
    if(!res){
        NSLog(@"ERROR: Can't save image. %@", error);
    }
}


static void detectFaces(NSURL *srcImageURL, NSURL *dstImageURL){
    
    VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithURL:srcImageURL options:@{}];
    VNDetectFaceLandmarksRequest *faceLandmarksRequest = [[VNDetectFaceLandmarksRequest alloc] init];
    
    NSError *error = nil;
    BOOL res = [handler performRequests:@[faceLandmarksRequest] error:&error];
    if(res){

        NSArray *results = faceLandmarksRequest.results;
        int i = 0;
        for (VNFaceObservation *result in results) {
            NSLog(@"---------");
            NSLog(@"Face %d", i);
            NSLog(@"---------");

            CGRect boundingBox = result.boundingBox;
            
            NSLog(@"%@", NSStringFromRect(boundingBox));
            i++;
        }

        drawResults(srcImageURL, dstImageURL, results);
        
    } else {
        NSLog(@"ERROR: %@", error);
    }
    
}

static void printUsage(){
    
    NSLog(@"Invalid params");
    NSLog(@"Usage: Vision_ConsoleTest <source image path> <destination jpeg image path>");

}

int main(int argc, const char * argv[]) {
    @autoreleasepool {

        if (argc < 3) {
            printUsage();
            return 1;
        }

        NSString *srcStr = [NSString stringWithUTF8String:argv[1]];
        NSString *dstStr = [NSString stringWithUTF8String:argv[2]];
        
        NSURL *srcImageURL = [NSURL fileURLWithPath:srcStr];
        NSURL *dstImageURL = [NSURL fileURLWithPath:dstStr];
        
        if(srcImageURL == nil || dstImageURL == nil){
            printUsage();
            return 1;
        }
        
        detectFaces(srcImageURL, dstImageURL);
    }
    return 0;
}
