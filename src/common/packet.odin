package common

// import "src:basic/bytes"

TCP_Packet :: struct
{
  kind: TCP_Packet_Kind
}

TCP_Packet_Kind :: enum u8
{
  PLAYER_CONNECTED,
  PLAYER_DISCONNECTED,
}

UDP_Packet :: struct
{
  kind: UDP_Packet_Kind
}

UDP_Packet_Kind :: enum u8
{
  
}
