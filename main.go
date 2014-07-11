package main

import (
	_ "encoding/xml"
	"flag"
	"log"
	_ "net/http"
	"time"
)

// example url for gh is

var (
	feedUrl string
	refreshInterval string
)

func main() {
	flag.StringVar(&feedUrl, "url", "", "Url of the feed to monitor")
	flag.StringVar(&refreshInterval, "interval", "3s", "How often to refresh the feed")
	flag.Parse()

	dur, _ := time.ParseDuration(refreshInterval)

	read := make(chan string)
	tick := time.NewTicker(dur)

	go func() {
		for {
			select {
			case <-tick.C:
				read <- "yo"

			}
		}
	}()

	for {
		select {
		case msg := <-read:
			log.Println(msg)
		}
	}

}
