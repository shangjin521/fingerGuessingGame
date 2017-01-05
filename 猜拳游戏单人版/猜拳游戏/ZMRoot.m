
//
//  Created by apple on 15/11/24.
//  Copyright © 2015年 zhangzhimin. All rights reserved.
//

#import "ZMRoot.h"

@implementation ZMRoot

- (void) showFist
{
    int num = arc4random_uniform(3)+1;
    self.fist = num;
}

@end
