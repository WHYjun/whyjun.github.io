---
layout: post
lang: ko
permalink: algorithm/Reverse-Array
title: 알고리즘 공부 - Go에서 배열 역순으로 정렬하기 (reverse)
categories:
  - Algorithm
tags:
  - algorithm
sharing:
  twitter: 알고리즘 공부 - Go에서 배열 역순으로 정렬하기 (reverse)
---

알고리즘 문제를 풀다 보면, 배열을 거꾸로 뒤집어야 하는 경우가 종종 있다. 아쉽게도 Go Standard Library는 `reverse` 함수가 없기 때문에 직접 구현해야 한다. 시간도 아끼고 필요할 때마다 쓰기 위해서 까먹기 전에 정리하기로 했다. 나중에 시간 날 때 나만의 알고리즘 라이브러리처럼 만들어두면 좋을 것 같다.

```go
func reverse(arrs *[]interface{}, l, r int) {
    for ; l < r; l, r = l + 1, r - 1 {
        (*arrs)[l], (*arrs)[r] = (*arrs)[r], (*arrs)[l]
    }
}
```