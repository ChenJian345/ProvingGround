//
//  30daysTest.cpp
//  ProvingGround
//
//  Created by Mark on 2020/4/30.
//  Copyright © 2020 markcj. All rights reserved.
//

#include "30daysTest.hpp"
#include <vector>
#include <iostream>

using namespace std;

//int main() {
//    
//    return 0;
//}

//// 求矩阵中，值都是1的最大的正方形子矩阵
//int maximalSquare(vector<vector<char>>& matrix) {
//    if (matrix.size() == 0) {
//        return 0;
//    }
//
//    // 还是用动态规划的思想
//    int M = (int)matrix.size();
//    int N = (int)matrix[0].size();
//    int result = 0;
//    // dp的值： dp[i][j]表示到扩展到(i, j)位置时，所能扩大成的正方形的边长
//    vector<vector<int>> dp(M, vector<int>(N, 0));
//    for (int i = 0; i < M; i++) {
//        for (int j = 0; j < N; j++) {
//            if (i == 0 || j == 0) { // 最边上的点，只有当前点为1时，才能组成长度为1的正方形
//                dp[i][j] = matrix[i][j] - '0';
//            }
//
//            // 其他一般的点，若matrix[i][j]位置是1时，需要关心上边、左边、左上的dp值
//            if (matrix[i][j] == '1') {
//                dp[i][j] = min(dp[i-1][j], min(dp[i][j-1], dp[i-1][j-1])) + 1;
//            }
//            result = max(result, dp[i][j]);
//        }
//    }
//    return result;
//}


//// 寻找指定搜索二叉树的指定路径
//bool isValidSequence(TreeNode* root, vector<int>& arr) {
//    if (!root || arr.size() == 0) {
//        return false;
//    }
//
//    TreeNode *cur = NULL;
//    for (int i = 0; i < arr.size(); i++) {
//        if (i == 0) {
//            if (root->val == arr[0]) {
//                cur = root;
//            } else {
//                return false;
//            }
//        }
//
//        cout << "arr[i] = " << arr[i] << ", tree-val = " << cur->val << endl;
//        // i可以被用来当做层数
//        if (cur->left != NULL && arr[i] == cur->left->val) {
//            cur = cur->left;
//        } else if (cur->right != NULL && arr[i] == cur->right->val) {
//            cur = cur->right;
//        } else {
//            return false;
//        }
//    }
//
//    // 数组结尾，是否是叶子节点，如果是，则
//    if (cur->left == NULL && cur->right == NULL) {
//        return true;
//    } else {
//        return false;
//    }
//}
