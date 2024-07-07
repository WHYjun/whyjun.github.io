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

When building a REST API with Java Spring Framework, handling multiple types of requests efficiently can be challenging. One effective approach is to use interfaces for controller requests. In this blog post, we'll walk through an example using a restaurant order system. We'll handle different types of orders (like hamburger and pizza) with a single endpoint.

## Scenario: Restaurant Order System

Imagine we have an endpoint /v1/orders that accepts different types of orders. Each order type has some common fields, but also unique fields. We'll use an interface called Order and implement it with specific classes for each order type. Let's dive in.

### Step 1: Define the Order Interface

First, we create an Order interface with common fields that all orders will have.

```java
public interface Order {
    String getOrderType();
}
```

### Step 2: Implement Order Types

Next, we create classes for specific order types, like HamburgerOrder and PizzaOrder.

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

Now, we create the controller to handle the /v1/orders POST request. We'll use `@RequestBody` and `@Valid` annotations to ensure the request body is correctly validated.

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

To handle polymorphic deserialization, we need to configure Jackson. This allows us to deserialize JSON into the correct Order implementation.

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

Finally, add global exception handling to manage validation errors.

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

Using interfaces for controller requests in Java Spring Framework allows you to handle multiple types of requests cleanly and efficiently. In this example, we created an Order interface and implemented specific order types, handled polymorphic deserialization with Jackson, and ensured validation with `@Valid` and `@RequestBody`. This approach makes your code more flexible and easier to maintain. Happy coding!
