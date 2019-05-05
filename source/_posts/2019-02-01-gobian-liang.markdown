---
layout: post
title: "go变量声明和使用"
date: 2019-02-01 16:31
comments: true
categories: go
---


go变量声明和使用

···objective-c

package main

import "fmt"

var x, y int

var (
	a int
	b bool
)

var c, d int = 1, 2

var e, f = 123, "hello"

func main() {

	//这咱不带声明格式的用法，只能出现在函数休内
	g, h := 123, "hello"

	println(x, y, a, b, c, d, e, f, g, h)

	var testString string = "hello world!"

	fmt.Println(testString)

	var a, b int

	a, b = 5, 7

	println("a=", a, "b=", b)

	a, b = b, a

	println("a和b交换后 a=", a, "b=", b)

}

···

