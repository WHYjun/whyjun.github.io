---
layout: post
lang: ko
permalink: books/Read-Clean-Code-In-Go-04
title: Go 언어로 읽는 클린 코드 4장 - 주석
categories:
  - Books
tags:
  - 노개북
  - 클린 코드
sharing:
  twitter: Go 언어로 읽는 클린 코드 4장 - 주석 #코딩 #개발자 #노마드북클럽 #노개북
---

클린 코드, 애자일 소프트웨어 장인 정신: Day 04 - 주석

> Java 언어를 기반으로 쓰여진 이 책의 내용들을 어떻게 Go 언어에 적용할 수 있을까를 고민하며 읽었습니다.

## 😀 책에서 기억하고 싶은 내용을 써보세요.

"이유는 단순하다. 프로그래머들이 주석을 유지하고 보수하기란 현실적으로 불가능하니까." (p.68)

"자신이 저지른 난장판을 주석으로 설명 하려 애쓰는 대신에 그 난장판을 깨끗이 치우는 데 시간을 보내라!" (p.69)

"주기적으로 TODO 주석을 점검해 없애도 괜찮은 주석은 없애라고 권한다." (p.75)

"설명이 잘 된 공개 API는 참으로 유용하고 만족스럽다. 표준 자바 라이브러리에서 사용한 Javadocs가 좋은 예다. Javadocs가 없다면 자바 프로그램을 짜기가 아주 어려우리라. 공개 API를 구현한다면 반드시 훌륭한 Javadocs를 작성한다." (p.75)

"함수나 변수로 표현할 수 있다면 주석을 달지 마라" (p.84)

"공개 API는 Javadocs가 유용하지만 공개하지 않을 코드라면 Javadocs는 쓸모가 없다. 시스템 내부에 속한 클래스와 함수에 Javadocs를 생성할 필요는 없다." (p.90)

## 🤔 오늘 읽은 소감은? 떠오르는 생각을 가볍게 적어보세요.

예전 회사에서 주석에 속아서 코드를 잘못 이해했다가 골탕을 먹었던 게 기억이 났다. 왜 주석을 관리하지 않았는가보다 그것을 믿고 코드를 제대로 확인하지 않았던 부분에 대해서 지적하는지 이상하게 생각했었는데 개발자로 계속 일을 하다가 보니 정말 책에서 나온 것처럼 여러 군데에 파편적으로 나누어져있는 주석을 제대로 관리하는 것은 코드를 제대로 관리하는 것보다 훨씬 어렵다는 것을 알게 되었다. 그렇기 때문에 특별한 이유가 있지 않다면 주석은 정해진 위치에 모여 있어야 한다고 생각한다. 개인적으로 선호하는 방법은 public 함수 위 주석을 달고 그 주석들을 문서화 유틸리티들을 활용해서 문서로 만들어서 사용하는 것이다. 이러면 따로 문서를 만들 필요도 없다는 장점과 코드 리뷰 중에 문서도 같이 리뷰할 수 있다는 장점도 있다고 생각한다. 특히 웹 개발에서는 백엔드 API가 `Javascript`가 아닌 경우가 많아서 코드를 읽는데 어려움이 있을 수 있는데 이런 경우 어떤 http error response를 반환하는지가 미리 문서에 작성되어 있으면 다른 개발자들이 쉽게 코드를 작성할 수 있다.

## 👀 소감 3줄 요약

- 주석의 목적이 코드를 명확하게 하는 거라면 코드의 함수와 변수를 명확하게 해야 한다.
- 코드에 문서가 필요하다면 함수 주석을 문서화해주는 도구를 사용하자. Swagger나 각 언어 표준 라이브러리에 있는 문서화 도구들이 있을 것이다.
- 코드가 먼저다. 코드를 잘 관리하자.

## godoc: 주석을 문서로 만들기

[Godoc: documenting Go code](https://go.dev/blog/godoc)

실제로 Go 언어는 기본적으로 godoc이 내장되어있다. 그리고 `godoc` 커맨드를 이용해서 웹 문서로 쉽게 변환할 수 있다. 우리가 사용하는 여러 패키지들의 문서들은 그렇게 만들어진 것이고 [Go Package](https://pkg.go.dev)에서 쉽게 확인할 수 있다. 

예를 들면 실제 `fmt` 패키지 소스 코드를 확인해보면 아래와 같이 되어있고 실제 문서는 이렇게 자동으로 생성된다 [(링크)](https://pkg.go.dev/fmt#Fprint). 이 문서를 보면 예시 코드가 있는데 그 예시 코드는 `_test` 패키지에 예시를 작성하고 싶은 함수명앞에 `Example`을 추가해서 만들면 `godoc`에 추가할 수 있다 [(링크)](https://cs.opensource.google/go/go/+/refs/tags/go1.17.7:src/fmt/example_test.go;l=142).

```go
// Fprint formats using the default formats for its operands and writes to w.
// Spaces are added between operands when neither is a string.
// It returns the number of bytes written and any write error encountered.
func Fprint(w io.Writer, a ...interface{}) (n int, err error) {

}
```