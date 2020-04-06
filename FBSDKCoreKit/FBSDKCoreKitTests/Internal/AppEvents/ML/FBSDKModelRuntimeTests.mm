// Copyright (c) 2014-present, Facebook, Inc. All rights reserved.
//
// You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
// copy, modify, and distribute this software in source code or binary form for use
// in connection with the web services and APIs provided by Facebook.
//
// As with any software that integrates with the Facebook platform, your use of
// this software is subject to the Facebook Developer Principles and Policies
// [http://developers.facebook.com/policy/]. This copyright notice shall be
// included in all copies or substantial portions of the software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "TargetConditionals.h"

#if !TARGET_OS_TV

#import <XCTest/XCTest.h>

#include "FBSDKModelRuntime.hpp"

@interface FBSDKModelRuntimeTests : XCTestCase

@end

@implementation FBSDKModelRuntimeTests

- (void)testReLU {
    float a[] = {-1, -2, 1, 2};
    XCTAssert(a[0] < 0);
    fbsdk::relu(a, 4);
    XCTAssert(a[0] == 0);
}

- (void)testConcatenate {
    float a[] = {1, 2};
    float b[] = {3, 4, 5};
    float c[] = {1, 2, 3, 4, 5};
    float *concat = (float *)malloc((size_t)(sizeof(float) * 5));
    fbsdk::concatenate(concat, a, b, 2, 3);
    for (int i = 0; i < 5; i++) {
        XCTAssertEqual(concat[i], c[i]);
    }
}

- (void)testSoftMax {
    float a[2] = {1, 1};
    float b[2] = {0.5, 0.5};
    fbsdk::softmax(a, 2);
    for (int i = 0; i < 2; i++) {
      XCTAssertEqualWithAccuracy(a[i], b[i], 0.01);
    }
}

- (void)testEmbedding {
    int i,j,k;
    float* res;

    int a[2][2] = {
        {0, 1},
        {1, 2},
    };
    float b[3][3] = {
        {1, 0, 0},
        {0, 1, 0},
        {0, 0, 1},
    };
    float c[2][2][3] = {
        {
            {1, 0, 0},
            {0, 1, 0}

        },
        {
            {0, 1, 0},
            {0, 0, 1},
        },
    };
    res = fbsdk::embedding(*a, *b, 2, 2, 3);
    for (i = 0; i < 2; i++) {
        for (j = 0; j < 2; j++) {
            for (k = 0; k < 3; k++) {
                XCTAssertEqualWithAccuracy(c[i][j][k], res[2 * 3 * i + 3 * j + k], 0.01);
            }
        }
    }
}

- (void)testDenseExample1 {
    int i,j;
    float *arr;
    float a[2][3] = {{1, 2, 3}, {4, 5, 6}};
    float b[3][2] = {{0, 1}, {1, 0},{-1, 1}};
    float c[2] = {100, 200};
    float e[2][2] = {{99, 204}, {99, 210}};
    arr = fbsdk::dense(*a, *b, c, 2, 3, 2);
    for (i = 0; i < 2; i++) {
        for (j = 0; j < 2; j++) {
            XCTAssertEqualWithAccuracy(arr[i*2+j], e[i][j], 0.01);
        }
    }
}

- (void)testDenseExample2 {
    float *arr;
    float a[1][2] = {{1, 2}};
    float b[2][3] = {{0, 3, -1}, {1, 0, -2}};
    float c[3] = {100, 200, 5};
    float e[1][3] = {{102, 203, 0}};
    arr = fbsdk::dense(*a, *b, c, 1, 2, 3);
    for (int i = 0; i < 3; i++) {
        XCTAssertEqualWithAccuracy(arr[i], e[0][i], 0.01);
    }
}

- (void)testConv1DExample1 {
    int i,j;
    float* res;
    float a[4][2][3] = {
        {
            {1, 2, 3},
            {4, 5, 6},
        },
        {
            {7, 8, 9},
            {1, 2, 3},
        },
        {
            {3, 2, 1},
            {1, 2, 9},
        },
        {
            {9, 8, 7},
            {4, 5, 6},
        },
    };
    float b[2][3][2] = {
        {
            {-1, 3},
            {5, -7},
            {-9, 9},
        },
        {
            {2, 4},
            {6, 8},
            {10, -10},
        },
    };
    float c[4][1][2] = {
        {{80, 12}},
        {{-4, 36}},
        {{102, -66}},
        {{66, 30}},
    };
    res = fbsdk::conv1D(**a, **b, 4, 2, 3, 2, 2);
    for (i = 0; i < 4; i++) {
        for (j = 0; j < 2; j++) {
            XCTAssertEqualWithAccuracy(c[i][0][j], res[2 * i + j], 0.01);
        }
    }
}

- (void)testConv1DExample2 {
    int i,j;
    float* res;
    float a[1][5][3] = {
        {
            {1, 2, 3},
            {4, 5, 6},
            {9, 8, 7},
            {5, 8, 1},
            {5, 3, 0},
        },
    };
    float b[3][3][4] = {
        {
            {-1, 3, 0, 1},
            {5, -7, 5, 7},
             {-9, 9, 2, 3},
        },
        {
            {2, 4, 5, 6},
            {6, 8, 9, 4},
            {10, -10, 5, 6},
        },
        {
            {1, 0, 5, 6},
            {2, 5, 9, 4},
            {9, 10, 5, 6},
        }
    };
    float c[1][3][4] = {
        {
            {168, 122, 263, 232},
            {133, 111, 291, 253},
            {47, 123, 208, 196},
        }
    };
    res = fbsdk::conv1D(**a, **b, 1, 5, 3, 3, 4);
    for (i = 0; i < 1; i++) {
        for (j = 0; j < 4; j++) {
            XCTAssertEqualWithAccuracy(c[i][0][j], res[4 * i + j], 0.01);
        }
    }
}

- (void)testConv1DExample3 {
    int i,j;
    float* res;
    float a[2][2][3] = {
        {
            {-1, -1, -1},
            {0, 0, 0},
        },
    };
    float b[2][3][2] = {
        {
            {-1, 3},
            {5, -7},
            {-9, 9},
        },
        {
            {2, 4},
            {6, 8},
            {10, -10},
        },
    };
    float c[1][1][2] = {{{5, -5}}};
    res = fbsdk::conv1D(**a, **b, 1, 2, 3, 2, 2);
    for (i = 0; i < 1; i++) {
        for (j = 0; j < 2; j++) {
            XCTAssertEqualWithAccuracy(c[i][0][j], res[2 * i + j], 0.01);
        }
    }
}

- (void)testTextVectorizationLessThanMaxLen {
    int* res;
    char strs[] = {"0123456"};
    int e[] = {48, 49, 50, 51, 52, 53, 54, 0, 0, 0};
    res = fbsdk::vectorize(strs, 7, 10);
    for (int i = 0; i < 7; i++) {
        XCTAssertEqualWithAccuracy(res[i], e[i], 0.01);
    }
}

- (void)testTextVectorizationLargerThanMaxLen {
    int* res;
    char strs[] = {"0123456"};
    int e[] = {48, 49, 50};
    res = fbsdk::vectorize(strs, 7, 3);
    for (int i = 0; i < 3; i++) {
        XCTAssertEqualWithAccuracy(res[i], e[i], 0.01);
    }
}

- (void)testTranspose3D {
    float input_data[2][3][4] = {
        {
            {0, 1, 2, 3},
            {4, 5, 6, 7},
            {8, 9, 10, 11},
        },
        {
            {12, 13, 14, 15},
            {16, 17, 18, 19},
            {20, 21, 22, 23},
        },
    };
    float expected_data[4][3][2] = {
        {
            {0, 12},
            {4, 16},
            {8, 20},
        },
        {
            {1, 13},
            {5, 17},
            {9, 21},
        },
        {
            {2, 14},
            {6, 18},
            {10, 22},
        },
        {
            {3, 15},
            {7, 19},
            {11, 23},
        },
    };
    fbsdk::MTensor input({2, 3, 4});
    fbsdk::MTensor expected({4, 3, 2});
    memcpy(input.mutable_data(), **input_data, input.count() * sizeof(float));
    memcpy(expected.mutable_data(), **expected_data, expected.count() * sizeof(float));
    [self AssertEqual:expected input:fbsdk::transpose3D(input)];
}

- (void)testTranspose2D {
    float input_data[3][4]= {
        {0, 1, 2, 3},
        {4, 5, 6, 7},
        {8, 9, 10, 11},
    };
    float expected_data[4][3] = {
        {0, 4, 8},
        {1, 5, 9},
        {2, 6, 10},
        {3, 7, 11},
    };
    fbsdk::MTensor input({3, 4});
    fbsdk::MTensor expected({4, 3});
    memcpy(input.mutable_data(), *input_data, input.count() * sizeof(float));
    memcpy(expected.mutable_data(), *expected_data, expected.count() * sizeof(float));
    [self AssertEqual:expected input:fbsdk::transpose2D(input)];
}

- (void)testAdd {
    float input[2][3][2] = {
        {
            {0, 12},
            {4, 16},
            {8, 20},
        },
        {
            {1, 13},
            {5, 17},
            {9, 21},
        },
    };
    float b[2] = {1, 2};
    float result[2][3][2] = {
        {
            {1, 14},
            {5, 18},
            {9, 22},
        },
        {
            {2, 15},
            {6, 19},
            {10, 23},
        },
    };
  fbsdk::add(**input, b, 2, 3, 2);
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 3; j++) {
            for (int k = 0; k < 2; k++) {
                XCTAssertEqualWithAccuracy(input[i][j][k], result[i][j][k], 0.01);
            }
        }
    }
}

- (void)testMaxPool1DExample1 {
    int i,j;
    float* res;
    float input[2][2][3] = {
        {
            {-1, 2, 3},
            {4, -5, 6},
        },
        {
            {7, -8, 9},
            {-10, 11, 12},
        },
    };
    float expected[2][1][3] = {
        {{4, 2, 6}},
        {{7, 11, 12}},
    };
    res = fbsdk::maxPool1D(**input, 2, 2, 3, 2);
    for (i = 0; i < 2; i++) {
        for (j = 0; j < 3; j++) {
            XCTAssertEqualWithAccuracy(expected[i][0][j], res[3 * i + j], 0.01);
        }
    }
}

- (void)testMaxPool1DExample2 {
    int i,j;
    float* res;
    float input[2][2][3] = {
        {
            {-1, -2, -3},
            {-4, -5, -6},
        },
        {
            {-7, -8, -9},
            {-10, -11, -12},
        },
    };
    float expected[2][1][3] = {
        {{-1, -2, -3}},
        {{-7, -8, -9}},
    };
    res = fbsdk::maxPool1D(**input, 2, 2, 3, 2);
    for (i = 0; i < 2; i++) {
        for (j = 0; j < 3; j++) {
            XCTAssertEqualWithAccuracy(expected[i][0][j], res[3 * i + j], 0.01);
        }
    }
}

- (void)testMaxPool1DExample3 {
    int i,j;
    float* res;
    float input[3][3][4] = {
        {
            {-1, -2, -3, 3},
            {-4, -5, -6, 9},
            {4, 5, 6, 7},
        },
        {
            {-7, -8, -9, 9},
            {-10, -11, -12, 5},
            {4, 5, 6, 7},
        },
        {
            {-7, -8, -9, 0},
            {-10, -11, -12, 2},
            {4, 5, 6, 7},
        },
    };
    float expected[3][1][4] = {
        {{4, 5, 6, 9}},
        {{4, 5, 6, 9}},
        {{4, 5, 6, 7}},
    };
    res = fbsdk::maxPool1D(**input, 3, 3, 4, 3);
    for (i = 0; i < 3; i++) {
        for (j = 0; j < 4; j++) {
            XCTAssertEqualWithAccuracy(expected[i][0][j], res[4 * i + j], 0.01);
        }
    }
}

- (void)AssertEqual:(const fbsdk::MTensor&)expected
              input:(const fbsdk::MTensor&)input
{
  const std::vector<int64_t>& expected_sizes = expected.sizes();
  const std::vector<int64_t>& input_sizes = input.sizes();
  XCTAssertEqual(expected_sizes, input_sizes);
  const float *expected_data = expected.data();
  const float *input_data = input.data();
  for (int i = 0; i < expected.count(); i++) {
    XCTAssertEqualWithAccuracy(expected_data[i], input_data[i], 0.01);
  }
}

@end

#endif
