---
layout: post
lang: en
permalink: blog/Using-Interface-for-Controller-Requests-in-Java Spring-Framework
title: Using Interface for Controller Requests in Java Spring Framework
categories:
  - development
tags:
  - java
sharing:
  twitter: Using Interface for Controller Requests in Java Spring Framework
---

When you build a REST API with Spring, one endpoint often has to accept several kinds of request. Using an interface for the request body lets a single endpoint handle them all. The example here is a restaurant order system, where one `/v1/orders` endpoint takes both hamburger and pizza orders.

## Scenario: Restaurant Order System

We have an endpoint `/v1/orders` that accepts different order types. Every order shares a few fields and adds its own. We define an `Order` interface and implement it with one class per order type.

### Step 1: Define the Order Interface

Start with an `Order` interface holding what every order has in common.

```java
public interface Order {
    String getOrderType();
}
```

### Step 2: Implement Order Types

Then write a class per order type, like `HamburgerOrder` and `PizzaOrder`.

```java
import lombok.Data;
import javax.validation.constraints.NotNull;

@Data
public class HamburgerOrder implements Order {
    @NotNull
    private String orderType = "hamburger";
    @NotNull
    private String bunType;
    @NotNull
    private String meatType;
    private boolean extraCheese;
}
```

```java
import lombok.Data;
import javax.validation.constraints.NotNull;

@Data
public class PizzaOrder implements Order {
    @NotNull
    private String orderType = "pizza";
    @NotNull
    private String crustType;
    @NotNull
    private String size;
    private boolean extraToppings;
}
```

### Step 3: Create the Controller

The controller handles the `/v1/orders` POST request. The `@RequestBody` and `@Valid` annotations bind and validate the incoming JSON.

```java
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

@RestController
@RequestMapping("/v1/orders")
@Validated
public class OrderController {

    @PostMapping
    public ResponseEntity<String> createOrder(@Valid @RequestBody Order order) {
        if (order instanceof HamburgerOrder) {
            HamburgerOrder hamburgerOrder = (HamburgerOrder) order;
            // Process hamburger order
            return new ResponseEntity<>("Hamburger order received", HttpStatus.OK);
        } else if (order instanceof PizzaOrder) {
            PizzaOrder pizzaOrder = (PizzaOrder) order;
            // Process pizza order
            return new ResponseEntity<>("Pizza order received", HttpStatus.OK);
        } else {
            return new ResponseEntity<>("Unknown order type", HttpStatus.BAD_REQUEST);
        }
    }
}
```

### Step 4: Configure Jackson for Polymorphic Deserialization

Jackson needs to know which class to build from the JSON. Annotate the `Order` interface so it reads the `orderType` field and picks the matching implementation.

```java
import com.fasterxml.jackson.annotation.JsonSubTypes;
import com.fasterxml.jackson.annotation.JsonTypeInfo;

@JsonTypeInfo(
        use = JsonTypeInfo.Id.NAME,
        include = JsonTypeInfo.As.PROPERTY,
        property = "orderType"
)
@JsonSubTypes({
        @JsonSubTypes.Type(value = HamburgerOrder.class, name = "hamburger"),
        @JsonSubTypes.Type(value = PizzaOrder.class, name = "pizza")
})
public interface Order {
    String getOrderType();
}
```

### Step 5: Add Global Validation Handling

Finally, handle validation errors in one place.

```java
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<String> handleValidationExceptions(MethodArgumentNotValidException ex) {
        return new ResponseEntity<>("Invalid order data", HttpStatus.BAD_REQUEST);
    }
}
```

## Conclusion

An interface for the request body lets one endpoint accept many order types without a pile of branching at the door. We defined an `Order` interface, implemented it per type, let Jackson pick the right class from `orderType`, and validated with `@Valid`. Adding a new order type now means writing one class and one Jackson subtype, and nothing else has to change. Happy coding!
