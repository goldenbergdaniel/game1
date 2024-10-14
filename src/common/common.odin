package main

// import "src:basic/bytes"

COLOR_BLACK  :: [4]f32{10,   10,  10, 1}
COLOR_BLUE   :: [4]f32{  0,   0, 255, 1}
COLOR_GREEN  :: [4]f32{  0, 255,   0, 1}
COLOR_ORANGE :: [4]f32{200, 100,   0, 1}
COLOR_PURPLE :: [4]f32{255,   0, 255, 1}
COLOR_RED    :: [4]f32{255,   0,   0, 1}
COLOR_WHITE  :: [4]f32{245, 245, 245, 1}
COLOR_YELLOW :: [4]f32{255, 255,   0, 1}


// Entity ////////////////////////////////////////////////////////////////////////////////


Entity :: struct
{
  kind:   Entity_Kind,
  active: bool,

  pos:   [2]f32,
  vel:   [2]f32,
  dim:   [2]f32,
  color: [4]f32,
}

Entity_Kind :: enum
{
  PADDLE,
  BALL,
}

Ball   :: struct {using Entity}
Paddle :: struct {using Entity}


// Packet ////////////////////////////////////////////////////////////////////////////////


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
