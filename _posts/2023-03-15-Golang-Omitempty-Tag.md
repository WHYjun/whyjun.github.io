---
layout: post
lang: ko
permalink: golang/Golang-Omitempty-Tag
title: Go에서 omitempty 태그 사용하기
categories:
  - Golang
tags:
  - golang
sharing:
  twitter: Go에서 omitempty 태그 사용하기
---

Go로 웹 서버를 개발하다 보면 JSON 데이터를 주고 받는 경우가 많이 있습니다. struct를 JSON으로 바꿀 때 값이 Zero Value(각 type별 기본 값)이거나 nil인 경우 그 값을 보내지 않아야할 때가 있습니다. 이런 경우, `omitempty` 태그를 활용하면 JSON에서 쉽게 생략할 수 있습니다.

struct 필드에 `omitempty` 태그가 있다면, Go 언어의 JSON 인코더는 그 필드의 값이 Zero Value거나 nil일 때 그 필드를 생략합니다. 이는 JSON으로 데이터를 보내고 받는 API를 개발할 때 유용하고 특히 JSON 메세지의 사이즈를 줄일 수 있다는 장점이 있습니다.

## omitempty 태그

struct의 `omitempty` 태그는 아래와 같이 필드 type 뒤에 Backtick(`)안에 작성해 추가할 수 있습니다.

```go
type Person struct {
    Name      string `json:"name,omitempty"`
    Age       int    `json:"age,omitempty"`
    Address   string `json:"address,omitempty"`
    Telephone string `json:"telephone,omitempty"`
}
```

위의 예시를 보면 모든 필드에 `omitempty` 태그가 있는 것을 볼 수 있습니다. 이는 필드의 값이 Zero Value라면 JSON 형식으로 데이터를 변경할 때 필드가 사라짐을 의미합니다. 예를 들어 아래의 값을 가진 `Person` 인스턴스가 있다고 합시다.

```go
p := Person{
    Name:      "John",
    Age:       0,
    Address:   "",
    Telephone: "123-456-7890",
}
```

`Person`을 `json.Marshal` 함수를 사용해서 JSON으로 바꾼다면 결과값은 아래와 같이 나옵니다.

```json
{
    "name": "John",
    "telephone": "123-456-7890"
}
```

위에서 볼 수 있듯이, `Age`와 `Address` 필드가 사라진 것을 확인할 수 있습니다.
