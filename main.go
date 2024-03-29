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
