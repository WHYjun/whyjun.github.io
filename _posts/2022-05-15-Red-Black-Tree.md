---
layout: post
title: 알고리즘 공부 - Red-Black Tree
categories:
  - Algorithm
tags:
  - algorithm
sharing:
  twitter: 알고리즘 공부 - Red-Black Tree
---

오랜만에 인터뷰 문제를 풀어볼 겸 LeetCode에 들어갔는데 인터뷰 가이드에 있는 문제들을 풀어보면 금방 풀겠지 하다가 한 문제에 잘못 걸렸다. 어찌저찌 구현은 했지만 다른 사람들이 풀은 방식 중에 듣기만 해보고 제대로 공부하지는 않았던 자료구조가 있어서 이렇게 따로 정리해보기로 했다. 고생시켰던 문제가 무엇인지 궁금하신 분은 이 [링크](https://leetcode.com/problems/odd-even-jump/)로 가면 확인해볼 수 있다. 사실 Hard 난이도인 걸 가이드 페이지에 안 나와있어서 풀었지 실제로 알았다면 풀려고 하지 않았을 것 같다.

## Red-Black Tree는?

위키피디아에 나온 정의로 설명하면, Red-Black Tree는 "Self-Balancing Binary Search Tree (스스로 균형을 맞추는 이진 탐색 트리)"입니다. 이는 Binary Search Tree의 특징을 그대로 가지고 있다는 뜻인데요. 새로운 Node가 이 자료구조에 들어오면 현재 Node보다 Key값이 작은 경우 그 Node의 왼쪽으로, 큰 경우에는 오른쪽으로 삽입하게 됩니다. 이러한 특징때문에 어떠한 값을 찾아야 하는 인터뷰 문제에서 자주 사용하게 되는 자료구조입니다. 여기에 더해 Red-Black Tree는 Node의 색깔이라는 개념을 추가해서 스스로 균형을 맞출 수 있도록 (어느 한 쪽으로 Node가 너무 많이 들어가지 않도록) 했습니다. 

<p align="center" > 
  <img  src="https://upload.wikimedia.org/wikipedia/commons/4/41/Red-black_tree_example_with_NIL.svg" alt="figure 1: red-black-tree" />
  <p align="center">이미지 출처: Wikipedia(https://en.wikipedia.org/wiki/Red%E2%80%93black_tree)</p>
</p>

위 이미지에서 볼 수 있듯이, Red-Black Tree는 아래와 같은 특징을 가지고 있습니다.

- Root Node의 색깔은 항상 검정이다.
- 모든 Nil Node의 색깔은 검정이라고 생각한다.
- 빨간 Node는 자신의 자식으로 빨간 Node를 가지지 않는다.
- 어느 Leaf Node에서 시작해도 Root Node까지 가는 길에 만나는 검정 Node의 개수는 같아야 한다.

이러한 조건들에 맞게 새로운 Node가 삽입이 될 때마다 Red-Black Tree는 스스로 균형을 맞출 수 있다. 그리고 이렇게 맞춰진 균형이 완벽하지 않더라도 어떠한 Node를 찾는데 걸리는 시간 복잡도는 `O(logN)`이고 삽입과 제거 또한 `O(logN)` 시간 복잡도로 수행할 수 있다.

## 이 문제에서 Red-Black Tree가 필요한 이유는?

이 문제에서 가장 시간을 많이 잡았던 부분은 배열을 역순으로 값을 확인하면서 그 값보다 크지만 가장 작거나 아니면 그 값보다 작지만 가장 큰 값을 그 값보다 우측에 있는 값들 중 찾아야 하는 부분이었다. 배열에 있는 값들을 하나하나 확인할 때마다 비교군에 새로운 값들이 추가되기 때문에 이를 자동으로 정렬해줄 수 있는 자료구조가 필요했고 어떤 자료구조를 사용하면 쉽고 빠르게 구현할 수 있을지에 대해서 생각하지 못했었다. 다행히 Discussion에서 treemap(Red-Black Tree를 기반으로 한 자료구조)을 사용하는 답변을 보아서 문제를 풀 수는 있었지만 지금 정리를 해놓지 않으면 나중에 이런 문제를 보게 되었을 때 Binary Search Tree를 생각해내지 못할 것 같았다. 

## 어떤 경우에 또 사용할 수 있을까?

새로운 값을 계속해서 비교해야 하는 문제에서 특히 유용할 것 같다. 이 문제를 풀 때 Go 오픈소스 모듈 중 하나인 `gods`에서 제공하는 `treemap`을 사용했는데 이 모듈에서 제공하는 `Ceiling`하고 `Floor`함수는 내가 비교하려는 값에 제일 가까운 크거나 작은 값을 반환해준다. 이와 같은 기능이 필요한 문제라면 사용해야 할 자료구조라고 생각한다.

```go
package main

import "github.com/emirpasic/gods/maps/treemap"

func main() {
    m := treemap.NewWithIntComparator() // empty (keys are of type int)
	m.Put(1, "x")                       // 1->x
	m.Put(2, "b")                       // 1->x, 2->b (in order)
	m.Put(1, "a")                       // 1->a, 2->b (in order)
	_, _ = m.Get(2)                     // b, true
	_, _ = m.Get(3)                     // nil, false
	_ = m.Values()                      // []interface {}{"a", "b"} (in order)
	_ = m.Keys()                        // []interface {}{1, 2} (in order)
	m.Remove(1)                         // 2->b
	m.Clear()                           // empty
	m.Empty()                           // true
	m.Size()                            // 0

	// Other:
	m.Min() // Returns the minimum key and its value from map.
	m.Max() // Returns the maximum key and its value from map.
    m.Ceiling() // Returns the smallest key that is larger than or equal to the given key
    m.Floor() // Returns the largest key that is smaller than or equal to the given key
}
```