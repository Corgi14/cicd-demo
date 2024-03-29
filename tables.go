package main

type Message struct {
	MessageID  string   `gorm:"primaryKey;type:varchar(255)"`
	Action     string   `gorm:"type:varchar(50)"`
	FromUserID string   `gorm:"type:varchar(255)"`
	RoomID     string   `gorm:"type:varchar(255)"`
	MsgTime    int64    // 假设这里用的是毫秒时间戳
	MsgType    string   `gorm:"type:varchar(50)"`
	ToList     []ToList `gorm:"foreignKey:MessageID"`
}

type ToList struct {
	ID        uint   `gorm:"primaryKey"`
	MessageID string `gorm:"type:varchar(255)"`
	UserID    string `gorm:"type:varchar(255)"`
}

type TextMessage struct {
	MessageID string `gorm:"primaryKey;type:varchar(255)"`
	Content   string
}

type ImageMessage struct {
	MessageID string `gorm:"primaryKey;type:varchar(255)"`
	SdkFileID string
	Md5Sum    string
	FileSize  uint32
}

type RevokeMessage struct {
	MessageID string `gorm:"primaryKey;type:varchar(255)"`
	PreMsgID  string
}

type AgreeMessage struct {
	MessageID string `gorm:"primaryKey;type:varchar(255)"`
	UserID    string
	AgreeTime int64
}

type DisagreeMessage struct {
	MessageID    string `gorm:"primaryKey;type:varchar(255)"`
	UserID       string
	DisagreeTime int64
}

type VoiceMessage struct {
	MessageID  string `gorm:"primaryKey;type:varchar(255)"`
	SdkFileID  string
	VoiceSize  uint32
	PlayLength uint32
	Md5Sum     string
}

type VideoMessage struct {
	MessageID  string `gorm:"primaryKey;type:varchar(255)"`
	SdkFileID  string
	FileSize   uint32
	PlayLength uint32
	Md5Sum     string
}

type CardMessage struct {
	MessageID string `gorm:"primaryKey;type:varchar(255)"`
	CorpName  string
	UserID    string
}

type LocationMessage struct {
	MessageID string `gorm:"primaryKey;type:varchar(255)"`
	Longitude float64
	Latitude  float64
	Address   string
	Title     string
	Zoom      uint32
}

type EmotionMessage struct {
	MessageID string `gorm:"primaryKey;type:varchar(255)"`
	Type      uint32
	Width     uint32
	Height    uint32
	ImageSize uint32
	SdkFileID string
	Md5Sum    string
}

type FileMessage struct {
	MessageID string `gorm:"primaryKey;type:varchar(255)"`
	FileName  string
	FileExt   string
	SdkFileID string
	FileSize  uint32
	Md5Sum    string
}

type LinkMessage struct {
	MessageID   string `gorm:"primaryKey;type:varchar(255)"`
	Title       string
	Description string
	LinkURL     string
	ImageURL    string
}

type WeAppMessage struct {
	MessageID   string `gorm:"primaryKey;type:varchar(255)"`
	Title       string
	Description string
	Username    string
	DisplayName string
}
