---
layout: post
title: Go 에서 Enum 사용하기 그리고 주의할 점
categories:
  - Golang
tags:
  - golang
---

Go 언어는 `enum` 타입을 제공하지 않지만 `Enum`으로 사용할 데이터 타입을 따로 생성 후 `iota`를 이용해서 비슷하게 사용할 수 있다. [(예시 코드)](https://go.dev/play/p/5C0w6YGPyys)

```go
package main

import "fmt"

type level int
type Status int

const (
	easy level = iota + 1
	medium
	hard
)

const (
	StatusUnknown Status = iota
	StatusOK
	StatusError
)

func main() {
	levelList := []level{easy, medium, hard}
	fmt.Println(levelList)
	// Output: [1 2 3]

	statusList := []Status{StatusUnknown, StatusOK, StatusError}
	fmt.Println(statusList)
	// Output: [0 1 2]
}
```

주의할 점은 `iota`가 항상 0 부터 시작하기 때문에 `enum`의 첫 값을 `iota + 1`으로 해서 1 부터 시작하도록 하던지 아니면 첫 `enum`을 Unknown이나 Nil을 나타내는데 사용해야 한다. Go의 `Zero Value`때문에 예상치 못한 부작용이 생길 수 있기 때문이다.

이벤트 큐에서 아래와 같은 `JSON` 형식의 request를 받는 시스템이 있다고 가정해보자.

```go
type Request struct {
	ID        int    `json:"ID"`
	Timestamp int    `json:"Timestamp"`
    Message   string `json:"Message"`
	Status    Status `json:"Status"`
}
```

만약 이 Request를 보내는 코드에서 아래와 같이 `Status`를 `JSON`에 넣는 것을 까먹고 보냈다면 어떻게 될까?

```json
{
  "ID": 1,
  "Timestamp": 1641775651,
  "Message": "Example message"
}
```

`Status` 필드에 아무런 데이터가 들어가있지 않기 때문에 Request의 Status 값은 0이 될 것이다. 첫 `enum`이 `StatusUnknown`이 아니라 `StatusOK`였다면 `Status` 데이터가 없는 모든 Request들은 아무도 모르게 버그를 일으킬 것이다. 그렇기 때문에 Go에서 `enum`을 사용할 때는 `Zero Value`를 염두에 두고 꼭 첫 `enum`을 Unknown이나 Nil을 나타내는 값으로 지정하는 습관을 가져야 한다.
