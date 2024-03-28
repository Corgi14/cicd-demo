package main

import (
	"encoding/json"
	"fmt"

	"github.com/NICEXAI/WeWorkFinanceSDK"
)

type ChatData struct {
	Seq          uint64      `json:"seq,omitempty"`           // 消息的seq值，标识消息的序号。再次拉取需要带上上次回包中最大的seq。Uint64类型，范围0-pow(2,64)-1
	MsgId        string      `json:"msgid,omitempty"`         // 消息id，消息的唯一标识，企业可以使用此字段进行消息去重。
	PublickeyVer uint32      `json:"publickey_ver,omitempty"` // 加密此条消息使用的公钥版本号。
	Message      interface{} `json:"message"`
}

func main() {
	// 	corpID := "wwea0c8ce5d0e82600"
	// 	corpSecret := "_bRD5jEXbwFULDAJZEgFwWs9tkyFlqNyxA8TDEbRPIU"
	// 	rsaPrivateKey := `
	// -----BEGIN PRIVATE KEY-----
	// MIIEwAIBADANBgkqhkiG9w0BAQEFAASCBKowggSmAgEAAoIBAQCd/fXkCVovHl30
	// teNMXD/D3knZQWT0yJLZMq+5zNPXdKs1i+DOmy1zx8zKpvai3X3uN9rCwL51LXgV
	// 2QZbgzNoA+C7eq36CoNjzLqz+rq8FICrH5h9AnSET/awhvHrLzVmmohE4Azj0WZc
	// vVCv0BN5HmrXWfqS5cfyWmuwRZFrVP1KTE8GIHo0p7klcBGNDLOi8ZgdKfHcPn3s
	// 9JMJ9/Q9XDpZaRgFpahuHgAuFEZcNF45Rp+HKtN0cnfArdC5owk5i1N81x4rbTdC
	// 62r8deioIIHWOf9S4iiCpdA9dsgfdcPQu7EtIFVsCWO/MFSU52wd0gXWGTosLpfa
	// O9Dtnb17AgMBAAECggEBAI+l76MFidTblGvB0MeF/IgXHSgGmEcj8ri+qB2UCWyV
	// bHGEG8NePgZOPHppMkhEgJJOgH2gh8q8q7mZmHkuIlhJZlSvp213j5z28S5hItWN
	// AqwUTy4iRFRk7BP2rhC63J/Mk2ekGrQsmRhrHOitlHcEW/ovmm9jstc8tTsRFbXy
	// o1wWIW/pkcAuZJupT/gMz4BGNzdTSa/wkjKThVBBuSkQUG/liMHXPWmsk5S/U+xi
	// dSUIavGkbKeUd9Rbm7+DmIlGvJoFl1Fsp4nDNUOy/8+6E7IgghoqyL6eShLQMW2y
	// r3uFxVSFCHrWmEc0MppfBEULVssVLkrlgVrTn4W42/kCgYEA0OHbZliTNyYVwyeb
	// tnxHo84iqZT+WAcLnuwbv4QbwwNrqN9gvhKKYUmqPDtNuYbAtgS2dII4SYdRCFtH
	// tQhOWnUPlxXp1VECHarTqB9PYBMWs7UYeWqXXd45R6oHAc4sCGPL8bq6ad57Yd1V
	// YwEWxJ8MxcZj3GqJs73XBHgUbNcCgYEAwaFjz8xY40/fVBeBEgcjeCXcxasGBqSG
	// h/t7cHuOvgCKOJqRczxWAaNhXiotDRy1I1eO0su5Zt1asq0Kgwv63p2Cz/fZ4Z1Q
	// JUGxNtHb3wypy5ozz6mN/mSe0E9OQ1JFeDBBXlD1fNBKy+afPVoeQj/wj7LtT2yA
	// ihyjg3+4m/0CgYEAmikWs8JLZDhHd3CUC2pNtSc9jcrYrD8G5JN9JytpEdREcK3r
	// yFwGpSao7SsXggVh1PRFdFdnE107AN/dXE51BW2/w9H4cecHmL2q2DnDazSrXJYb
	// KgDxFeYcgDeMVFjFRqvgqNcXHWuFxASGMDttgk+gLZbtvI8kcfN57WJyMKECgYEA
	// wM5dvwrx79cWwHtvEG5/SSIahdHYfEDTnRAzSDwgVN3gxKBU+PQ5iAQR7lv85DOT
	// ww9qrkgh42XC7GwWLYt+ULFzEnbwRBILPi39smKhl6baZFy1/rANLiUvZqmxeqOv
	// fRA/5xSifZhDAmowYj0cKEfW2KAIYa/fBqehwk0pnFkCgYEAgp+e2Rx5HSwCFBUv
	// ipL4HcmUgOwespOBmWAJgAmfqh0CVLXpUouVKVTb6ubEzqaM463d4z4PfnWk9iiv
	// 2SHJdSfTac+gamYFryhIOznPPEPuF7jlLUc6O00lMPubgs1KusL1ai/FNDGcN8IT
	// bHHmKEy+n2+Gfyvp6ZT4+w4fVQE=
	// -----END PRIVATE KEY-----
	// `
	err := loadConfig()
	if err != nil {
		fmt.Printf("err: %+v", err)
		return
	}
	//初始化客户端
	client, err := WeWorkFinanceSDK.NewClient(Cfg.CorpId, Cfg.CorpSecret, Cfg.RsaPrivateKey)
	if err != nil {
		fmt.Printf("SDK 初始化失败：%v \n", err)
		return
	}

	//同步消息
	chatDataList, err := client.GetChatData(4, 100, "", "", 3)
	if err != nil {
		fmt.Printf("消息同步失败：%v \n", err)
		return
	}

	var list []ChatData

	for _, chatData := range chatDataList {
		//消息解密
		chatInfo, err := client.DecryptData(chatData.EncryptRandomKey, chatData.EncryptChatMsg)
		if err != nil {
			fmt.Printf("消息解密失败：%v \n", err)
			return
		}
		var cd ChatData

		cd.Seq = chatData.Seq
		cd.MsgId = chatData.MsgId
		cd.PublickeyVer = chatData.PublickeyVer

		switch chatInfo.Type {
		case "text":
			cd.Message = chatInfo.GetTextMessage()
		case "image":
			cd.Message = chatInfo.GetImageMessage()
		case "revoke":
			cd.Message = chatInfo.GetRevokeMessage()
		case "agree":
			cd.Message = chatInfo.GetAgreeMessage()
		case "voice":
			cd.Message = chatInfo.GetVoiceMessage()
		case "video":
			cd.Message = chatInfo.GetVideoMessage()
		case "card":
			cd.Message = chatInfo.GetCardMessage()
		}

		list = append(list, cd)
		// if chatInfo.Type == "image" {
		// 	image := chatInfo.GetImageMessage()
		// 	sdkfileid := image.Image.SdkFileId

		// 	isFinish := false
		// 	buffer := bytes.Buffer{}
		// 	index_buf := ""
		// 	for !isFinish {
		// 		//获取媒体数据
		// 		mediaData, err := client.GetMediaData(index_buf, sdkfileid, "", "", 5)
		// 		if err != nil {
		// 			fmt.Printf("媒体数据拉取失败：%v \n", err)
		// 			return
		// 		}
		// 		buffer.Write(mediaData.Data)
		// 		if mediaData.IsFinish {
		// 			isFinish = mediaData.IsFinish
		// 		}
		// 		index_buf = mediaData.OutIndexBuf
		// 	}
		// 	filePath, _ := os.Getwd()
		// 	filePath = path.Join(filePath, "test.png")
		// 	err := os.WriteFile(filePath, buffer.Bytes(), 0666)
		// 	if err != nil {
		// 		fmt.Printf("文件存储失败：%v \n", err)
		// 		return
		// 	}
		// 	break
		// }
	}
	jsonData, err := json.Marshal(list)
	if err != nil {
		fmt.Printf("json marshalling failed: %v \n", err)
	}
	fmt.Println("chat data list: ", string(jsonData))
}
