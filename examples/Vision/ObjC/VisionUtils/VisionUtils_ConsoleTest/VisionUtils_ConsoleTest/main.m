//
//  main.m
//  VisionUtils_ConsoleTest
//
//  Created by Vitaly Cherevaty on 7/26/17.
//  Copyright © 2017 Codeminders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Vision/Vision.h>
#import <Cocoa/Cocoa.h>
#import <VisionUtils/VisionUtils.h>

static void drawContour(VNFaceLandmarkRegion2D *region, CGRect box){
    NSUInteger count = region.pointCount;
    NSBezierPath *path = [[NSBezierPath alloc] init];
    
    for(int i = 0; i < count; i++){
        CGPoint pt = [region vut_pointAtIndex:i];
        pt.x = box.origin.x + (CGFloat)pt.x * box.size.width;
        pt.y = box.origin.y + (CGFloat)pt.y * box.size.height;
        
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

int main(int argc, const char * argv[]) {
    @autoreleasepool {

        //workaround to load VUTUtils framework
        [VUTHelper class];
        
        NSString *baseDir = @"/Users/vcherevaty/Projects/PyCoreML/examples/Vision/Python";
        
        NSString *srcStr = [baseDir stringByAppendingPathComponent:@"test.jpg"];
        NSString *dstStr = [baseDir stringByAppendingPathComponent:@"test_out3.jpg"];;

        NSURL *srcImageURL = [NSURL fileURLWithPath:srcStr];
        NSURL *dstImageURL = [NSURL fileURLWithPath:dstStr];
        
        detectFaces(srcImageURL, dstImageURL);
    }
    return 0;
}
