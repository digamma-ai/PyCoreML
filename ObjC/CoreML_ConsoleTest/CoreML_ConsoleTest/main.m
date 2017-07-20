//
//  main.m
//  CoreML_ConsoleTest
//
//  Created by Vitaly Cherevaty on 7/19/17.
//  Copyright © 2017 Codeminders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MarsHabitatPricer.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        MarsHabitatPricer *model = [[MarsHabitatPricer alloc] init];
        NSError *error = nil;
        MarsHabitatPricerOutput *output = [model predictionFromSolarPanels:4 greenhouses:3 size:10000 error:&error];
        if(output){
            NSLog(@"Output: %@", @(output.price));
        } else {
            NSLog(@"ERROR: %@", error);
        }
    }
    return 0;
}
