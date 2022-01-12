---
layout: post
title: Go에서 HashSet 구현하기
categories:
  - Golang
tags:
  - golang
  - data structure
sharing:
  twitter: Go에서 HashSet 구현하기
---

12월 18일 기준 가장 최근 버전인 Go 1.17에도 아직 `Set`이라는 자료구조가 없다. 알고리즘 문제나 Advent of Code 문제를 풀 때 `Set`을 필요로 하는 경우가 생각보다 많았어서 직접 구현해보았다.

`Set`이라는 자료구조를 통해 얻고 싶어하는 기능들을 아래와 같다.

- 데이터를 **중복 없이** 관리하고 싶을 때
- 데이터를 쉽게 추가하고 제거하는 기능이 필요할 때
- 데이터를 적은 공간 복잡도를 가진 자료구조에서 관리하고 싶을 때

그리고 이러한 기능들은 Go 언어에서 제공하는 `map`을 사용하면 아래와 같이 간단하게 구현할 수 있다.

```go
type set map[interface{}]struct{}
```

실제로 사용할 때는 `interface{}`를 추가하고 싶은 데이터의 자료형으로 변경해서 사용하면 된다. (e.g: `type set map[string]struct{}`) Go에서 `map`은 `HashTable`을 구현해놓은 것이기 때문에 key는 중복될 수 없고 데이터를 추가하고 제거하는 것은 O(1)으로 매우 빠르다. 그리고 빈 `struct{}`는 0바이트이기 때문에 메모리 사용도 최소화할 수 있다.

만약 위의 타입을 그냥 사용하는 것이 다른 동료 개발자들을 헷갈리게 할 것 같다면 아래와 같이 `set`에 함수들을 추가하는 것으로 해결할 수 있다.

```go
func (s set) Add(v interface{}) {
	s[v] = struct{}{}
}

func (s set) Remove(v interface{}) {
	delete(s, v)
}

func (s set) Contain(v interface{}) bool {
	_, ok := s[v]
	return ok
}

func (s set) Length() int {
	return len(s)
}
```

위의 코드들은 [Go Playground](https://go.dev/play/p/XthHr8HUHHL)에서 직접 사용해보실 수 있다.