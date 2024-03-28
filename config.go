package main

import (
	"log"
	"os"

	"github.com/joho/godotenv"
)

type Config struct {
	Port          string
	CorpId        string
	CorpSecret    string
	RsaPrivateKey string
}

var Cfg *Config

func loadConfig() error {
	Cfg = &Config{}

	err := godotenv.Load()
	if err != nil {
		return err
	}
	Cfg.Port = os.Getenv("PORT")
	Cfg.CorpId = os.Getenv("CORP_ID")
	Cfg.CorpSecret = os.Getenv("CORP_SECRET")

	b, err := os.ReadFile("./private_key.pem")
	if err != nil {
		log.Printf("err: %+v", err)
		return err
	}
	Cfg.RsaPrivateKey = string(b)
	return nil
}
