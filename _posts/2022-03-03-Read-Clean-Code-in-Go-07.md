---
layout: post
title: Go 언어로 읽는 클린 코드 7장 - 오류처리
categories:
  - Books
tags:
  - 노개북
  - 클린 코드
sharing:
  twitter: Go 언어로 읽는 클린 코드 7장 - 오류처리 #코딩 #개발자 #노마드북클럽 #노개북
---

클린 코드, 애자일 소프트웨어 장인 정신: Day 07 - 객체와 자료 구조

> Java 언어를 기반으로 쓰여진 이 책의 내용들을 어떻게 Go 언어에 적용할 수 있을까를 고민하며 읽었습니다.

## 😀 책에서 기억하고 싶은 내용을 써보세요.

"간단히 말해, 뭔가 잘못될 가능성은 늘 존재한다. 뭔가 잘못되면 바로 잡을 책임은 바로 우리 프로그 래머에게 있다." (p.130)

"함수를 호출한 즉시 오류를 확인해야 하기 때문이다. 불행히도 이 단계는 잊어버리기 쉽다." (p.131)

"예외를 던질 때는 전후 상황을 충분히 덧붙인다. 그러면 오류가 발생한 원인과 위치를 찾기가 쉬워진다." (p.135)

"하지만 애플리케이션에서 오류를 정의할 때 프로그래머에게 가장 중요한 관심사는 오류를 잡아내는 방법이 되어야 한다." (p.135)

"대다수 상황에서 우리가 오류를 처리하는 방식은 (오류를 일으킨 원인과 무관하게) 비교적 일정하다. 1) 오류를 기록한다. 2) 프로그램을 계속 수행해도 좋은지 확인한다." (p.136)

"null을 반환하지 마라" (p.138)

"실상은 null 확인이 너무 많아 문제다. 메서드에서 null을 반환하고픈 유혹이 든다면 그 대신 예외를 던지거나 특수 사례 객체를 반환한다. 사용하려는 외부 API가 null을 반환 한다면 감싸기 메서드를 구현해 예외를 던지거나 특수 사례 객체를 반환하는 방식을 고려한다." (p.139)

"null을 전달하지 마라. 메서드에서 null을 반환하는 방식도 나쁘지만 메서드로 null을 전달하는 방식은 더 나쁘다. 정상적인 인수로 null을 기대하는 API가 아니라면 메서드로 null을 전달하는 코드는 최대한 피한다." (p.140)

"대다수 프로그래밍 언어는 호출자가 실수로 넘기는 null을 적절히 처리하는 방법이 없다. 그렇다면 애초에 null을 넘기지 못하도록 금지하는 정책이 합리적이다. 즉, 인수로 null이 넘어오면 코드에 문제가 있다는 말이다. 이런 정책을 따르면 그만큼 부주의한 실수를 저지를 확률도 작아진다." (p.142)

"깨끗한 코드는 읽기도 좋아야 하지만 안정성도 높아야 한다. 이 둘은 상충하는 목표가 아니다. 오류 처리를 프로그램 논리와 분리해 독자적인 사안으로 고려하면 튼튼하고 깨끗한 코드를 작성할 수 있다. 오류 처리를 프로그램 논리와 분리하면 독립적인 추론이 가능해지며 코드 유지보수성도 크게 높아진다." (p.142)

## Go 언어에서는?

### Exception이 없는 Go 언어

이 책이 처음 출간된 다음 해인 2009년에 탄생한 Go 언어는 exception(예외)를 지원하지 않는다. 책에서는 exception을 지원하는 언어가 많아졌기 때문에 가장 첫 조언으로 에러 코드 대신 exception을 사용하라고 한다. 그럼 왜 Go 언어는 exception을 지원하지 않을까? 이 질문에 Go 언어 공식 사이트는 "여러 값을 반환할 수 있는 특징을 활용해서 다른 언어와 다른 방식으로 쉽게 에러를 반환하고 처리할 수 있다"고 답한다 [(Why does Go not have exceptions?)](https://go.dev/doc/faq#exceptions). 그렇기 때문에 Go 코드들을 읽다보면 아래와 같이 error 타입을 함께 반환하는 코드들을 많이 볼 수 있다. 

```go
result, err := doSomething()
if err != nil {
    fmt.Println("fail to get result: ", err.Error())
}
```

위의 예시에서는 어떤 함수가 실행되고 result라는 결과값이 err라는 에러와 같이 반환되었다. 만약 err가 nil이 아니라면 (null 값이 아니라면), err 안에 있는 메세지를 감싸서 출력하는 식으로 에러를 처리한다. 함수에서 error 값을 같이 반환하는 것이 하나의 규칙이다 보니 개발자들이 함수를 호출한 이후에 즉시 오류를 확인하게 한다. 그렇다고 할 지라도 잊어버리고 버그를 만들어내는 경우도 종종 볼 수 있다.

exception 대신 에러만 있기 때문에 Go 언어 개발자들은 어떤 경우에 exception으로 따로 만들어서 처리해줘야 하는가를 고민할 필요가 없다. 결국 exception으로 처리해줘야 할 것도 본질은 에러에서부터 왔다. 그러므로 어떤 exception으로 잡을지가 아니라 어떻게 처리해야 할 지에 개발자들이 더 고민할 수 있게 해준다.

### error type

Go 언어는 C 언어에서 에러 코드를 -1과 같은 형식으로 반환하는 문제를 해결하기 위해서 error라는 에러 타입을 다음과 같이 만들었다.

```go
type error interface {
    Error() string
}
```

`Error()`라는 메소드 한 개만을 가지고 있는 interface이기 때문에 `Error()` 메소드만 구현한다면 매우 쉽게 커스텀 에러 타입들을 만들어낼 수 있다. 아래와 같이 에러를 처리할 때 추가적인 정보를 제공한다거나 C 언어처럼 integer 값으로 관리하고 있던 에러 코드들을 에러 타입으로 쉽게 만들어줄 수 있다.

```go
type ChallengeSignUpError struct {
    ChallengeName string
    Err         error
}

func (e *ChallengeSignUpError) Error() string {
    return fmt.Sprintf("failed to sign up %s: %s", ChallengeName, e.Err.Error())
}

type intAsError int

func (e *intAsError) Error() string {
    // 각 에러 코드에 대한 설명을 추가할 수 있다. 
    return fmt.Sprintf("%d", e)
}
```

이러한 커스텀 타입이 아니라 그냥 단순한 error 타입으로 충분하다면 아래 세 가지 방법으로 error를 구현할 수 있다.

- `fmt.Errorf`
- `errors.New`
- `errChallengeNotFound := &ChallengeSignUpError{ChallengeName: "Clean Code Book Club", Err: fmt.Errof("challenge not found")}`

그리고 이러한 error들은 다른 언어에서 사용되는 exception들과 같이 throw할 수도 있고 아니면 catch해서 throw하지 않은 채로 처리할 수도 있다. 이처럼 Go 언어에서도 exception이라는 타입이 없을 뿐이지 발생한 에러를 기록하고 프로그램이 계속 작동하는지 확인하는 점은 바뀌지 않는다.

## 👀 소감 3줄 요약
- 에러가 없을 수 없다는 것을 인정하면서 에러를 처리하는 코드가 얼마나 중요한지 깨닫게 되었다.
- integer로 된 에러 코드나 null을 반환하지 않기 위해서 언어는 다양한 발전을 거쳤다. 대부분의 언어는 exception을 채용했고, Go 언어는 error 값을 같이 반환하는 방식을 택했다. 
- Go 언어는 그래도 여전히 개발자들에게 많은 자유를 주었다. 이러한 자유에는 큰 책임이 따른다. 에러를 제대로 처리하고 있는지 항상 확인해야 한다. 이러한 부분들을 강제하기 위해 Rust는 아예 Null을 없애고 Option이란 개념을 추가했다 [(Rust can never be null)]("https://blog.knoldus.com/rust-can-never-be-null/").
