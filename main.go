package main

import (
	"fmt"
	"log"
	"net/http"
	"net/http/httputil"
	"strings"
)

func main() {
	port := 39084
	log.Printf("Start proxy service :%d ", port)

	// 代理服务
	log.Fatal(http.ListenAndServe(fmt.Sprintf(":%d", port), http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		host := r.Host
		if strings.HasPrefix(host, "proxy.") {
			host = host[6:]
		}
		path := r.URL.Path
		log.Printf("host=%s  path=%s", host, path)
		proxy := &httputil.ReverseProxy{Director: func(req *http.Request) {
			req.URL.Scheme = "http"
			req.URL.Host = host
		}}
		proxy.ServeHTTP(w, r)
	})))
}
