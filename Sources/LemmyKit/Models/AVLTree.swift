//
//  AVLTree.swift
//  
//
//  Created by PEXAVC on 7/13/23.
//

/*
 Will be used for caching and storing site metadata for searching purposes.
 AVL trees, due to its nature of being balanced, allows for faster lookups.
 
 Adding or removing CAN be expensive though.
 */

import Foundation

class AVLTree<T: Comparable> {
    class Node<T> {
        var value: T
        var left: Node<T>?
        var right: Node<T>?
        var height: Int

        init(value: T) {
            self.value = value
            self.left = nil
            self.right = nil
            self.height = 1
        }
    }

    var root: Node<T>?

    // Calculate the height of a node
    private func height(_ node: Node<T>?) -> Int {
        return node?.height ?? 0
    }

    // Get the balance factor of a node
    private func balanceFactor(_ node: Node<T>?) -> Int {
        return height(node?.left) - height(node?.right)
    }

    // Update the height of a node
    private func updateHeight(_ node: Node<T>) {
        node.height = max(height(node.left), height(node.right)) + 1
    }

    // Right rotation
    private func rotateRight(_ node: Node<T>?) -> Node<T>? {
        guard let node = node, let left = node.left else {
            return nil
        }
        
        /* N refers to the explicitly passed in node:
           N
          /
         N_L
          \
           N_LR
         */
        
        //N_LR is saved temporarily
        let leftRight = left.right
        //N_LR becomes N
        left.right = node
        //N_LL becomes N_LR
        node.left = leftRight
        
        /*
            N_L
           /   \
         N_LR   N
         */
        
        
        /*
         When performing a right rotation on an AVL tree, it may seem like a good idea to just put the node in the left node of the child. However, this approach would not maintain the constraints of the AVL tree, which requires that the balance factor of each node is in the range of -1, 0, or 1.

         If only the left node of the child is considered, after the right rotation it will have two subtrees. The height of the right subtree will be one greater than the height of the left subtree. This is because we are rotating right, which means that the previously left branch is now the root node, and its old right subtree is now the new right branch. This results in an imbalance in the height of the left and right subtrees of the node, which violates the AVL tree's balance constraint.
         */

        updateHeight(node)
        updateHeight(left)

        return left
    }

    // Left rotation
    private func rotateLeft(_ node: Node<T>?) -> Node<T>? {
        guard let node = node, let right = node.right else {
            return nil
        }
        
        /* N refers to the explicitly passed in node:
           N
            \
            N_R
            /
          N_RL
         */

        //Save N_RL temporarily
        let rightLeft = right.left
        //N_RL becomes N
        right.left = node
        //N_RR becomes N_RL
        node.right = rightLeft

        updateHeight(node)
        updateHeight(right)
        
        /*
            N_R
           /   \
          N   N_RL
         */

        return right
    }

    // Checks and balances a node to ensure that the AVL tree property is maintained
    private func balance(_ node: Node<T>?) -> Node<T>? {
        guard let node = node else {
            return nil
        }

        updateHeight(node)

        if balanceFactor(node) > 1 {
            if balanceFactor(node.left) < 0 {
                node.left = rotateLeft(node.left)
            }

            return rotateRight(node)
        } else if balanceFactor(node) < -1 {
            if balanceFactor(node.right) > 0 {
                node.right = rotateRight(node.right)
            }

            return rotateLeft(node)
        }

        return node
    }

    // Insert a new node into the AVL tree
    func insert(_ value: T) {
        root = insertHelper(root, value)
    }

    private func insertHelper(_ node: Node<T>?, _ value: T) -> Node<T> {
        guard let node = node else {
            return Node(value: value)
        }

        if value < node.value {
            node.left = insertHelper(node.left, value)
        } else {
            node.right = insertHelper(node.right, value)
        }

        return balance(node)!
    }

    // Inorder traversal
    func inorderTraverse(_ node: Node<T>?, visit: (T) -> Void) {
        guard let node = node else { return }

        inorderTraverse(node.left, visit: visit)
        visit(node.value)
        inorderTraverse(node.right, visit: visit)
    }
}
