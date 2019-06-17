package main

import (
	"context"
	"encoding/json"
	"flag"
	"log"
	"os"

	"cloud.google.com/go/firestore"
)

func main() {
	filePath := flag.String("f", "./init.d/data.json", "import data file path")
	flag.Parse()

	f, err := os.Open(*filePath)
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()

	var c collection
	if err := json.NewDecoder(f).Decode(&c); err != nil {
		log.Fatal(err)
	}

	ctx := context.Background()
	client, err := firestore.NewClient(ctx, os.Getenv("PROJECT_ID"))
	if err != nil {
		log.Fatal(err)
	}

	b := client.Batch()
	for cname, docs := range c {
		for id, data := range docs {
			ref := client.Collection(cname).Doc(id)
			b.Set(ref, data)
		}
	}
	if _, err := b.Commit(ctx); err != nil {
		log.Fatal(err)
	}
}

type collection map[string]document

type document map[string]field

type field map[string]interface{}
