---
layout: post
title: Go 언어로 읽는 클린 코드 1장 - 깨끗한 코드
categories:
  - Books
tags:
  - 노개북
  - 클린 코드
sharing:
  twitter: Go 언어로 읽는 클린 코드 1장 - 깨끗한 코드 #코딩 #개발자 #노마드북클럽 #노개북
---

클린 코드, 애자일 소프트웨어 장인 정신: Day 01 - 깨끗한 코드

> Java 언어를 기반으로 쓰여진 이 책의 내용들을 어떻게 Go 언어에 적용할 수 있을까를 고민하며 읽었습니다.

## 😀 책에서 기억하고 싶은 내용을 써보세요.

"프로그래머도 마찬가지다. 나쁜 코드의 위험을 이해하지 못하는 관리자 말을 그대로 따르는 행동은 전문가답지 못하다." (p.7)

"테스트 케이스가 없는 코드는 깨끗한 코드가 아니 다. 아무리 코드가 우아해도, 아무리 가독성이 높아도, 테스트 케이스가 없으면 깨끗하지 않다." (p.12)

"간단한 코드는 1) 모든 테스트를 통과한다. 2) 중복이 없다. 3) 시스템 내 모든 설계 아이디어를 표현한다. 4) 클래스, 메서드, 함수 등을 최대한 줄인다." (p.13)

## 🤔 오늘 읽은 소감은? 떠오르는 생각을 가볍게 적어보세요.

### 나쁜 코드로 치르는 대가

회사에서 리팩토링을 하고 있는 중이었기 때문에 책에 나온 예시들이 너무 와닿았다. 그 잘못의 원인이 프로그래머라는 사실 또한 큰 공감이 되었다. 프로젝트 매니저들에게 왜 이것이 선행되어야 하는지 설명하는 과정은 쉽지 않았지만 다른 프로젝트들을 위해서 쉽게 확장을 하려면 필요하다는 사실을 모두 이해하며 진행하는 중이다. 그러다 보니 팀 전체적으로 코드 리뷰가 더 엄격해졌고 이 책에서 나온 좋은 코드의 정의에 대해 서로 많이 공유하는 문화가 생겼다. 특히 지금 코드 때문에 모두가 힘들었다보니 더 그런 것 같다.

### 좋은 코드의 정의

책에 나와 있는 여러 정의들 가운데 나에게 가장 큰 울림을 준 정의는 론 제프리스와 켄트 벡의 정의다. 그리고 이는 효율적인 테스트로 이어진다고 믿는다. 중복이 없으면 한 가지 기능만 하는 최소한의 수의 함수들이 시스템 내 모든 설계 아이디어를 표현하고 있다면 테스트를 모두 통과하는 것으로 우리는 이 코드가 제대로 동작하고 있다고 믿을 수 있다. 새로운 기능을 추가하는 것도 간편해지며 다른 사람들도 코드를 읽을 때 테스트 코드를 직접 돌려보면서 이 코드가 어떻게 동작하는지 알 수 있게 된다. 큰 시스템을 개발해본 경험이 부족해서일 수 있지만 아직까지 나는 위와 같이 정의된 코드가 좋은 코드라고 생각한다. 머리로는 알고 꿈은 항상 크게 잡고 있지만 내 실력이 부족해서, 그리고 책에 나와있듯이 개발자로서의 프로의식이 부족해서 이런 코드들을 작성하지 못하고 있다. 스스로를 돌아보면 나한테 제일 필요한 것은 더 많은 개발 지식보다 개발자로서의 프로의식이 아닐까?

## 👀 소감 3줄 요약

- 개발 부채를 피할 수는 없지만 가장 적은 이자이면서 쉽게 환급할 수 있도록 코드를 작성해야겠다. 그러려면 읽기 쉽고 테스트하기 편한 코드를 작성해야 한다고 생각한다.
- "중복을 피하라. 한 기능만 수행하라. 제대로 표현하라. 작게 추상화하라." (p.14)
- Go 언어에는 객체(`Object`)라는 개념이 없지만 `SRP`나 `Dependency Injection`은 여전히 쓰이고 있다. 책에서 설명할 설계 원칙들과 예시 코드들이 기대가 된다.

## 코드에 적용해보기

Java의 객체(`Object`)를 이용한 추상화는 할 수 없지만, Go 언어의 `Receiver Function`을 활용해서 실제 구현을 쉽게 추상화할 수 있을 것 같다. 예를 들어, 학생 정보가 들어가있는 배열이 있는데 그 배열에 있는 학생들의 이름을 전부 출력해보고 싶다면 어떻게 해야 할까? 가장 먼저 떠오르는 것은 반복문을 돌려서 배열안에 있는 학생의 이름을 전부 출력해보는 것이다. 그리고 이 기능이 여러번 반복된다면 함수로 만들 수 있을 것이다. 

하지만 아래 예시와 같이 Go 에서는 `type`을 새로 정의내리고  `Receiver Function`으로 이름을 출력하는 기능을 추상화할 수 있다. (실제 코드는 다음 [링크](https://go.dev/play/p/y56ZKWeZcLE)에서 실제로 사용해볼 수 있다.)

```go
package main

import "fmt"

type student struct {
	ID   int
	Name string
}

type studentArr []student

func (arr studentArr) PrintNames() {
	for _, s := range arr {
		fmt.Println(s.Name)
	}
}

func main() {
	students := studentArr{
		{ID: 1, Name: "Nico"},
		{ID: 2, Name: "Lynn"},
		{ID: 3, Name: "Young"},
	}

	students.PrintNames()
}
```

막상 적어보니 이렇게까지 추상화해야 하나라는 생각이 들었다. 추상화가 있으면 좋을만한 예시를 생각해보다가 학생 정보에 학생들이 수강했던 강의 정보들까지 있다면 어떨까? 그리고 그 강의의 이름들을 출력하고 싶다면 어떻게 하면 좋을까?

```go
package main

import "fmt"

type student struct {
	ID      int
	Name    string
	Courses []string
}

type studentArr []student

func (arr studentArr) PrintCourses() {
	// Go 에서 HashSet을 구현하는 법은 아래 링크에서 확인할 수 있다.
	// https://whyjun.github.io/golang/Write-HashSet-In-Go
	courseSet := make(map[string]struct{})
	for _, s := range arr {
		for _, c := range s.Courses {
			if _, ok := courseSet[c]; !ok {
				courseSet[c] = struct{}{}
				fmt.Println(c)
			}
		}
	}
}

func main() {
	students := studentArr{
		{ID: 1, Name: "Nico", Courses: []string{"React MasterClass", "Kokoa Clone"}},
		{ID: 2, Name: "Lynn", Courses: []string{"Kokoa Clone"}},
		{ID: 3, Name: "Young", Courses: []string{"Youtube Clone"}},
	}
	students.PrintCourses()
}
```

이렇게 추상화된 함수들은 나중에 이 배열이 다른 `struct`로 바뀐다고 할 지라도 실제 구현만 바꿔서 사용할 수 있고 이 추상화된 함수를 테스트하던 테스트 코드들도 그대로 활용할 수 있을 것이다. 모든 코드를 다 추상화해서 사용할 필요는 없지만 이처럼 반복된 기능을 수행하거나 다른 API나 시스템에서 호출될 기능들이라면 추상화해서 제공함으로써 다른 개발자들이 손쉽게 이 기능들을 사용할 수 있을 것 같다. 그리고 또 하나의 장점으로 `Receiver Function`은 내가 만든 `type`에 함수를 만드는 것이기 때문에 다른 코드에서 쉽게 자동 완성으로 불러낼 수 있다는 점이다. 이를 이용하면 다른 개발자들이 중복된 함수를 만드는 것을 방지할 수 있지 않을까라는 생각도 해보았다.