//
//  burn.go
//  go-burn
//
//  Created by Caius Durling on 2013-12-03.
//  Copyright 2013 . All rights reserved.
//
//  Spins up all of your available CPUs to create high load
//
package main

import (
	"fmt"
	"runtime"
	"sync"
)

var Runners int

func main() {
	Runners := runtime.NumCPU()
	runtime.GOMAXPROCS(Runners)

	fmt.Printf("Burning %d CPUs\n", Runners)

	var wg sync.WaitGroup
	wg.Add(Runners)

	for i := 0; i < Runners; i++ {
		go (func() {
			for {
			}
		})()
	}

	wg.Wait()
}
