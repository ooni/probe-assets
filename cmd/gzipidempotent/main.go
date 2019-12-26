package main

import (
	"bytes"
	"compress/gzip"
	"io/ioutil"
	"log"
	"time"
)

func must(err error, message string) {
	if err != nil {
		log.Fatal(message)
	}
}

func main() {
	for _, name := range []string{"asn.mmdb", "ca-bundle.pem", "country.mmdb"} {
		var buf bytes.Buffer
		zw := gzip.NewWriter(&buf)
		zw.Name = name
		zw.ModTime = time.Date(2019, time.December, 26, 0, 0, 0, 0, time.UTC)
		data, err := ioutil.ReadFile(name)
		must(err, "ioutil.ReadFile failed")
		_, err = zw.Write(data)
		must(err, "zw.Write failed")
		err = zw.Close()
		must(err, "zw.Close failed")
		err = ioutil.WriteFile(name + ".gz", buf.Bytes(), 0644)
		must(err, "ioutil.WriteFile failed")
	}
}
