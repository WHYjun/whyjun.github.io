---
layout: post
lang: en
permalink: blog/The-Importance-of-Signals-from-Test-Codes
title: The Importance of Signals from Test Codes
categories:
  - development
tags:
  - test
sharing:
  twitter: The Importance of Signals from Test Codes
---

When you write tests, they tell you a lot about your main code. If a test is hard to write, the problem is usually in the code you are testing, not in the test. Those difficulties are signals, and they are worth reading.

## Why Test Codes Matter

Tests are a mirror for your main code. They show its strengths and its weak spots. A few signals to watch for:

* Difficulty writing tests: the code might be too complex or not modular.
* Excessive mocking: the code might be tightly coupled.
* Long setup times: the code might carry too many dependencies.
* Hidden dependencies: the code might be hard to maintain or extend.

## Key Signals and What They Mean

### Excessive Mocking

Mocking replaces a real dependency with a fake one. A few mocks are normal. When a single test needs many of them, the class under test leans on too many other classes. The fix is in the design: break the large class into smaller ones that can stand on their own.

### Long Setup Times

Setting up a test should be quick. When it drags, the code usually has too many dependencies or too little structure. Dependency injection helps here, since the test can supply what it needs instead of building the whole world first.

### Difficulty Isolating Tests

Each test should run on its own. When one test changes the outcome of another, the code has shared state hiding somewhere. Make each unit do one thing so the tests stop leaking into each other.

### Hidden Dependencies

Some dependencies are not visible in a method's signature. Calling `Instant.now()` inside a method is one of them: the method quietly depends on the system clock, so you cannot test it without controlling time. Dependency inversion fixes this. Instead of reading the clock directly, inject a clock interface and ask it for the current time.

#### Implementing Dependency Inversion

Here is the same idea in code.

Before:

```java
public class Event {
    private Instant timestamp;

    public Event() {
        this.timestamp = Instant.now();
    }
}
```

After:

```java
public interface Clock {
    Instant now();
}

public class SystemClock implements Clock {
    public Instant now() {
        return Instant.now();
    }
}

public class FakeClock implements Clock {
    public Instant now() {
        return Instant.parse("2007-12-03T10:15:30.00Z");
    }
}

public class Event {
    private Instant timestamp;

    public Event(Clock clock) {
        this.timestamp = clock.now();
    }
}
```

## Benefits of Listening to These Signals

Reading these signals improves the design. Modular code is easier to follow, has fewer places for bugs to hide, and takes less effort to extend when the requirements change.

## Practical Steps to Improve Your Code

* Refactor regularly. Don't wait until the code is a mess. Clean it up as you go.
* Use dependency injection. It reduces the need for mocks and keeps the code modular.
* Write small, focused functions. Each one should do a single thing, which makes it easy to test.
* Find and remove hidden dependencies. Patterns like port-adapter and dependency inversion decouple your code.

## Conclusion

Tests do more than check that your code works. They point at where the design is weak. When a test is painful to write, listen to it and fix the code underneath instead of forcing the test around it. Keep your tests simple, and let them guide the design.
