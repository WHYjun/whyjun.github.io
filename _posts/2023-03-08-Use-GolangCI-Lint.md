---
layout: post
lang: ko
permalink: golang/Use-GolangCI-Lint
title: golangcli-lint로 Go 코드 규칙 적용하기
categories:
  - Golang
tags:
  - golang
sharing:
  twitter: golangcli-lint로 Go 코드 규칙 적용하기
---

개발팀 사이즈가 커지면서 관리해야 하는 리포지토리의 개수가 늘어났고 각각의 프로젝트가 팀을 리드하는 개발자에 따라 자유분방한 모습으로 진화했습니다. 특히 Go 언어를 처음으로 사용하는 개발자들이 늘어나면서 코드 리뷰 과정에서 Idiomatic Go에 대해서 설명하고 작성하는데 시간을 꽤 소모하게 되었습니다. 그러다보니 실제로 리뷰가 되어야 하는 부분보다 더 많은 시간을 쏟게 되는 경우가 늘어났고 이를 방지하기 위해 자동화된 도구가 필요하다라는 피드백이 나오기 시작했습니다.

다행히도 Go 커뮤니티에는 다양한 Lint 도구들이 이미 개발되어 있었는데 대표적으로 `govet`, `gofmt`, `golint` 등이 있습니다. 이러한 도구들은 좋은 Go 코드를 작성하기 위해 필요한 부분들을 다 체크하지만 각각 따로 돌려야 한다는 단점이 있습니다. 이러한 단점을 극복하기 위해 저희 팀은 `golangci-lint`를 사용하기로 했습니다. 

`golangci-lint`는 Lint 도구는 아니지만 다양한 Lint 도구들을 한번에 돌릴 수 있게 도와줍니다. 단순히 도구들을 순서대로 돌리는 것이 아니라 병렬적으로 돌리는 동시에 분석 결과값을 캐싱함으로써 정적 분석을 매우 빠르게 끝낼 수 있습니다. 그리고 회사에 많은 개발자들이 사용하고 있는 Visual Studio Code를 지원하고 이 점을 활용해 `settings.json`에 설정 몇 가지를 추가하는 것으로 코드 규칙을 지키지 않을 경우 Warning 메세지를 바로 띄워주어 개발자들이 빠르게 고칠 수 있게 도와줍니다.

![golangci-lint log](https://repository-images.githubusercontent.com/132145189/05239680-dfaf-11e9-9646-2c3ef2f5f8d4){: .align-center}

## 설치하기

Mac과 Windows가 아닌 다른 환경에서 설치하는 방법은 [공식 문서](https://golangci-lint.run/usage/install/)에 자세히 나와있습니다.

### Mac

```bash
brew install golangci-lint
brew upgrade golangci-lint

golangci-lint version
```

### Windows

```bash
# Git for Windows를 설치할 때 같이 설치되는 Git Bash에 아래 명령어를 입력하시면 설치됩니다.
# 실제 binary는 $(go env GOPATH)/bin/golangci-lint에 있습니다
curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin 

golangci-lint --version
```

## 사용하기

```bash
golangci-lint run
```

위 명령어를 입력하면 `golangci-lint` 기본으로 설정되어 있는 Lint 도구들로 코드를 분석합니다. 어떠한 도구들을 사용하는지 확인하고 싶으면 `golangci-lint help linters`로 확인할 수 있습니다. `golangci-lint`를 직접 설정하고 싶다면 [공식 문서](https://golangci-lint.run/usage/configuration/)를 참고해서 `.golangci.yml` 파일을 작성하시면 됩니다.

## Visual Studio Code에 추가하기

Visual Studio Code 설정에 들어가서 `settings.json`을 연 다음, 아래 설정을 추가하면 Visual Studio Code에서 Warning 메세지를 확인할 수 있습니다.

```json
"go.lintTool": "golangci-lint"
"go.lintFlags": [
    "--fast"
]
```

## 사용 후기

실제로 적용해보니 코드 리뷰로 잡아내지 못한 이슈들이 꽤 있었습니다. 대표적으로 error를 `fmt.Errorf`로 래핑할 때, `%w`를 사용하지 않았던 부분입니다. `errors` 패키지를 잘 활용하지 않았다보니 알아차리지 못했지만 프로젝트의 사이즈가 커지면서 어떤 error인지를 확인해야 하는 경우가 빈번하게 발생했는데 `%w`가 아닌 `%s`나 `%v`를 사용했을 때는 `errors.UnWrap()` 함수를 사용할 수 없고 그 때문에 `errors.Is`와 `errors.As`도 활용할 수 없다는 것을 알게 되었습니다. 이처럼 Linter는 하나의 정해진 코드 규칙을 모든 개발자가 지킬 수 있게 해준다는 점을 넘어서 코드에 있는 버그들을 개발자들이 일찍 알아차릴 수 있게 해줍니다.