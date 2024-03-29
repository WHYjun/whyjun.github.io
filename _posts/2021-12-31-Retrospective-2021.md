---
layout: post
title: 2021년 회고
categories:
  - Retrospective
tags:
  - retrospective
sharing:
  twitter: 2021년 회고
---

이번 한 해는 정말 정신없이 지나갔다. 개인적으로도 많은 일들이 있었기도 했지만 개발자로서도 새로운 시작을 했던 한 해였기 때문에 한 해를 돌아보고 어떻게 하면 더 발전할 수 있을지 고민해보기 위해서 2021년을 돌아보는 글을 작성하기로 했다.

## 새로운 회사, 새로운 언어

2021년은 기존 회사를 그만두고 새로운 회사로 이직하는 것으로 시작했다. 이직을 결심한 이유는 여러가지가 있었지만 회사 내부 프로덕트가 아니라 유저가 실제로 사용하는 프로덕트를 만들어보고 싶었고, 코로나 상황이 괜찮아질 것을 대비해서 아내가 박사 과정을 하는 주에서 회사를 다니면 좋을 것 같았다. (하지만 노트북을 받은 첫 날을 제외하고는 아직도 재택 근무를 하는 중..) 그렇게 회사를 알아보던 와중에 클라우드 팀을 새롭게 꾸리면서 풀스택 개발자를 뽑는 회사를 찾게 되었고 인터뷰를 거쳐 2월부터 다니게 되었다.

![golang-machine](/assets/images/gopher-machine.jpg){: .align-center}

새로운 회사에서 백엔드 언어로 `Go`를 클라우드 서비스로 `Google Cloud`를 사용했기 때문에 본의 아니게 또 새로운 기술들을 공부할 기회를 얻었다 (인턴으로 일할 때는 `Python`과 `AWS`, 첫 직장에서는 `C#`과 `Windows Server`를 사용). `Google Cloud`는 결국 `Docker`와 `Kubernetes`를 이용해서 배포했기 때문에 `AWS`와 크게 다른 부분은 없었지만 `Go`는 처음부터 새로 배워야 했다. 그래도 `Go` 언어 문법 자체는 단순하고 직관적이었기 때문에 일은 금방 시작할 수 있었다. 

하지만 일하다보니 내가 (그리고 우리 팀이) 작성하고 있는 코드들이 좋은 `Go` 코드가 아니라는 것을 깨닫고 `Go` 개발자스럽게 코드를 짜는 것에 대해 많은 고민을 하고 있다. 아직도 더 많은 공부가 필요하지만 이런 공부들이 인정을 받아 회사 내에 `Go` Standard 문서를 작성하고 소프트웨어 팀 전체를 대상으로 `Go`언어를 소개하는 프레젠테이션을 하는 기회를 받았다. 언어자체가 너무나 매력적인 언어이기 때문에 계속해서 배우고 싶고 단순히 일할 때 새로 배운 것을 사용하는 것에서 멈추지 않고 계속해서 기록할 계획이다. 그리고 이 블로그는 그 기록들이 쌓이는 공간이 되었으면 한다. 

## 회사 업무

다양한 프로젝트를 참여했었지만 간단하게 정리해보면 아래와 같다.

* 새로운 IoT Device 출시와 함께 관련 API를 독립적인 마이크로서비스로 옮기기
* 새로운 구독 서비스 출시
* 캐시 서버를 구축해 구독 서비스 성능 개선 (16배 속도 향상)
* Cypress와 Go Testing을 활용해 v1 코드 테스팅 자동화

이번 회사에서 처음으로 MSA를 접했는데 이해도가 부족했었던 터라 초반에 삽질을 많이 해버렸다. 그래도 덕분에 팀원들과 함께 회사 시스템이 어느 방향성을 가지고 나아가야 하는지 회사를 들어온지 얼마 되지 않던 시점에 많은 대화를 해볼 수 있는 기회가 되었다. 그리고 이 중에 캐시 서버와 구독 서비스에 대해 하고 싶은 이야기가 많지만 회사 기술 블로그에 올리기로 했기 때문에 그 글이 올라간 이후에 그 글을 다시 한국어로 작성하고 살을 좀 더 붙여서 올릴 예정이다. 

새로운 회사를 결정할 때까지만 해도 이런 것들은 기대하지 못했다. 인터뷰를 볼 때까지만 해도 정확한 팀이 정해져 있지 않았기 때문에 새로운 언어를 배우게 될 지도 몰랐었고 회사 기술 블로그에 글을 두 편이나 쓰게 될 지도 몰랐다. 회사 사정상 아직 회사 기술 블로그에 올라가지 않았기 때문에 여기에 올릴 수는 없지만 그 글들이 내가 배우고 경험한 것을 개인 기술 블로그를 만들어서 공유해야겠다라는 생각을 하게 해주었다. 지금까지 가지고 있던 좋은 느낌을 계속해서 가지고 2022년에도 일할 수 있으면 좋겠다.

## 운전

![dog-driving-car-memes](https://www.etags.com/blog/wp-content/uploads/2017/08/dog-driving-car-memes.jpg){: .align-center}

개발과는 전혀 상관없는 이야기지만 더 이상 대중교통으로 회사를 다닐 수 없는 주로 이사를 왔기 때문에 운전을 배웠다. 미국에서 운전은 필수항목이기는 하나 이사오기 전까지는 계속 도시에서 살았고 첫 회사도 버스 하나만 타면 출근할 수 있었기 때문에 7년차 장롱면허로 계속해서 살았다. 아직도 조금만 길이 좋지 않거나 처음 가보는 길을 가야 하면 아내를 옆 좌석에 태워야 하지만 그래도 혼자서 이곳저곳 다닐 수 있게 되었다. 그러나 운전을 하게 만든 가장 큰 이유였던 회사는 아직도 가본 적이 없다. 

## 2022년 1분기 목표

회사 일에 익숙해진 만큼 1분기는 다시 개인 개발 공부를 하려고 한다. 특히, `Go`언어와 웹 개발 도메인에 대해 공부를 더 해야겠다고 생각한다. 회사에서 새로운 서비스를 계속 출시하면서 유저가 늘어나고 있다 보니 베타 버전으로 출시한 플랫폼에서도 점점 성능개선을 필요로 하는 부분들이 나오고 있다. 이미 출시한 IoT 장비들을 다 활용하고 싶은 회사 입장에서는 서비스를 빨리 키우고 싶은 게 당연하지만 개발자 입장에서는 불편함이 느껴지는 부분들을 무시하고 넘어갈 수 없다고 생각한다. 일단 회사에서 정한 일정과 개발 과제를 우선적으로 하면서 내가 불편함을 느끼는 부분에 대해서 계속해서 따로 공부해보고 실제로 어떻게 개선해야 하는지 확신이 생길 때 팀에 이야기해볼 예정이다. 팀에서 받아들여지지 않으면 어쩔 수 없지만 그렇게 공부해나가다 보면 다른 일에 쓸 때가 있겠지.. 그리고, 2021년에 사놓은 책이지만 아직도 첫번째 챕터를 끝내지 못한 `Refactoring 2`도 1분기 내에 완독하고 싶은데 가능할 지 모르겠다. 회사 개발 로드맵을 보면 2분기부터는 정말 바쁠 것 같아서 더 미루다보면 또 하나의 인테리어 소품이 될까봐 걱정이 된다.

## 마치며

어쩌다 보니 회고가 회사와 고(`Go`)로 가득 차 있는 것 같다. 개인적인 일들도 많았지만 개발과는 관련 없이 그냥 정말 삶이 바빴기 때문에 개발 회고로 쓸 내용은 회사 일 밖에 없었고 그만큼 개인적으로 해야 하는 개발 공부를 하지 못한 게 아닐까라는 후회도 남는다. 하지만 하던 일을 제대로 기록하지 못하고 있던 내가 이렇게 회고라고 쓰고 있는 걸 보면 많은 것이 바뀐 2021년이었던 것 같다. 2021년 처럼 2022년에도 조금씩 더 성장하는 개발자가 되었으면 좋겠다.