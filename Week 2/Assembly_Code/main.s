.text
.global main
.global _start

main:
start:

push    {ip, lr}

#OPEN (CREATE) FILE
ldr r0, =newfile
mov r1, #0x02 @ create R/W
mov r2, #384 @ = 600 octal (me)
bl open

cmp r0, #-1 @ file descriptor
beq err

mov r4, r0 @ save file_descriptor

mov r0, r4
ldr r1, =1795
mov r2, #0x46
bl ioctl

mov r0, r4 @ file_descriptor
ldr r1, =address_joystick
mov r2,#1
bl write

mov r0, r4
ldr r1, =joystick_buffer
mov r2, #1
bl read

ldr r0, =joystick_buffer
ldr r0, [r0]
ldr r1, =four
ldr r1, [r1]
cmp r0, r1
beq write_leds
bne print_joystick_value

#CLOSE FILE
bl close
mov r0, r4 @ return file_descriptor as error code

exit: 
pop {r4, lr}
mov r7, #1 @ exit
svc 0

write_leds:
mov r0, r4 @ file_descriptor
ldr r1, =cross_hair @ address of buffer
mov r2, #192 @ length from read
bl write
#svc 0

print_joystick_value:
ldr r0, =joystick_text
ldr r1, =joystick_buffer @seed printf
ldr r1, [r1]
bl      printf          @ print string and pass params
pop     {ip, pc}

err: 
mov r4, r0
mov r0, #1
ldr r1, =errmsg
mov r2, #(errmsg - errmsgend)
mov r7, #4
svc 0

mov r0, r4
b exit

.data

joystick_text: .asciz "Joystick value: '%x'\n"
errmsg: .asciz "create failed"
errmsgend:
newfile: .asciz "/dev/i2c-1"
prompt: .asciz "Input a string: \n"
promptend:
arrow_up: 		.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x30, 0x30, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x0, 0x30, 0x30, 0x0, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x0, 0x0, 0x30, 0x30, 0x0, 0x0, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x50, 0xB8, 0x7E, 0x84, 0x50, 0xB8, 0x7E, 0xF0, 0x2C, 0xF9, 0x76, 0x4, 0x48, 0xE0, 0x76, 0x54, 0xBC, 0xDF, 0x76, 0x11, 0x7B, 0x9C, 0x7C, 0xD8, 0xE3, 0xE4, 0x3, 0x2B, 0x3, 0x1, 0x0, 0x48, 0x2, 0x1, 0x0, 0x30, 0x9, 0xF8, 0x76, 0xF0, 0x2C, 0xF9, 0x76, 0xE8, 0x50, 0xB8, 0x7E, 0x88, 0x38, 0xF9, 0x76, 0xBC, 0xF2, 0xF7, 0x76, 0x0, 0x30, 0xF9, 0x76, 0x0, 0x0, 0x0, 0x0, 0x30, 0x12, 0xF9, 0x76, 0x4, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x11, 0x7B, 0x9C, 0x7C, 0x18, 0x3B, 0xF9, 0x76, 0x0, 0x0, 0x0, 0x0, 0xE8, 0x50, 0xB8, 0x7E, 0xF0, 0x50, 0xB8, 0x7E, 0x5C, 0x51, 0xB8, 0x7E, 0x2B, 0x3, 0x1, 0x0, 0x44, 0x51, 0xB8, 0x7E, 0xFC, 0xCB, 0xF6, 0x76, 0xF0, 0x50, 0xB8, 0x7E, 0xBC, 0x3A, 0xF9, 0x76, 0x2, 0x0, 0x0, 0x0, 0x58, 0x12, 0xF9, 0x76, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x0, 0x0, 0x0, 0x60, 0x39, 0xF9, 0x76, 0x0, 0x0, 0x30, 0x0, 0x0, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x18, 0x3B, 0xF9, 0x76, 0x60, 0x39, 0xF9, 0x76, 0x30, 0x30, 0x30, 0x30, 0x0, 0x0, 0x0, 0x0, 0x64, 0xD5, 0xDF, 0x76, 0x40, 0xF, 0xF9, 0x76, 0x0, 0x0, 0x30, 0x0, 0xEC, 0x1B, 0xF3, 0x76, 0x50, 0x3D, 0xF3, 0x76, 0xE8, 0x5, 0x0, 0x0, 0x44, 0x4, 0x0, 0x0, 0xEC, 0x1B, 0xF3, 0x76, 0x50, 0x3D, 0xF3, 0x76, 0xE8, 0x5, 0x0, 0x0, 0x44, 0x4, 0x0, 0x0, 0xEC, 0x1B, 0xF3, 0x76, 0x8, 0x40, 0x2B, 0x1, 0x1, 0x0, 0x0, 0x0, 0x0, 0x30, 0xF9, 0x76, 0x0, 0xF1, 0xE5, 0x76, 0x50, 0x3D, 0xF3, 0x76, 0xEC, 0x1B, 0xF3, 0x76, 0x39, 0xD, 0x1, 0x0, 0x1, 0x0, 0x0, 0x0, 0xA, 0x0, 0x0, 0x0, 0xEC, 0x1B, 0xF3, 0x76, 0x38, 0xD, 0x1, 0x0, 0xCC, 0xD, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x50, 0x11, 0xE6, 0x76, 0x50, 0x3D, 0xF3, 0x76, 0xD0, 0x15, 0xE6, 0x76, 0x1, 0x0, 0x0, 0x0, 0x50, 0x3D, 0xF3, 0x76, 0xEC, 0x1B, 0xF3, 0x76, 0xD4, 0x56, 0xE5, 0x76
arrow_down: 	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x0, 0x0, 0x30, 0x30, 0x0, 0x0, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x0, 0x30, 0x30, 0x0, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x30, 0x30, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x50, 0xF5, 0x7E, 0x84, 0x50, 0xF5, 0x7E, 0xF0, 0xCC, 0xF7, 0x76, 0x4, 0xE8, 0xDE, 0x76, 0x54, 0x5C, 0xDE, 0x76, 0x11, 0x7B, 0x9C, 0x7C, 0xD8, 0xE3, 0xE4, 0x3, 0x2B, 0x3, 0x1, 0x0, 0x48, 0x2, 0x1, 0x0, 0x30, 0xA9, 0xF6, 0x76, 0xF0, 0xCC, 0xF7, 0x76, 0xE8, 0x50, 0xF5, 0x7E, 0x88, 0xD8, 0xF7, 0x76, 0xBC, 0x92, 0xF6, 0x76, 0x0, 0xD0, 0xF7, 0x76, 0x0, 0x0, 0x0, 0x0, 0x30, 0xB2, 0xF7, 0x76, 0x4, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x11, 0x7B, 0x9C, 0x7C, 0x18, 0xDB, 0xF7, 0x76, 0x0, 0x0, 0x0, 0x0, 0xE8, 0x50, 0xF5, 0x7E, 0xF0, 0x50, 0xF5, 0x7E, 0x5C, 0x51, 0xF5, 0x7E, 0x2B, 0x3, 0x1, 0x0, 0x44, 0x51, 0xF5, 0x7E, 0xFC, 0x6B, 0xF5, 0x76, 0xF0, 0x50, 0xF5, 0x7E, 0xBC, 0xDA, 0xF7, 0x76, 0x2, 0x0, 0x0, 0x0, 0x58, 0xB2, 0xF7, 0x76, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x0, 0x0, 0x0, 0x60, 0xD9, 0xF7, 0x76, 0x0, 0x0, 0x30, 0x0, 0x0, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x18, 0xDB, 0xF7, 0x76, 0x60, 0xD9, 0xF7, 0x76, 0x30, 0x30, 0x30, 0x30, 0x0, 0x0, 0x0, 0x0, 0x64, 0x75, 0xDE, 0x76, 0x40, 0xAF, 0xF7, 0x76, 0x0, 0x0, 0x30, 0x0, 0xEC, 0xBB, 0xF1, 0x76, 0x50, 0xDD, 0xF1, 0x76, 0xE8, 0x5, 0x0, 0x0, 0x44, 0x4, 0x0, 0x0, 0xEC, 0xBB, 0xF1, 0x76, 0x50, 0xDD, 0xF1, 0x76, 0xE8, 0x5, 0x0, 0x0, 0x44, 0x4, 0x0, 0x0, 0xEC, 0xBB, 0xF1, 0x76, 0x8, 0xE0, 0xF7, 0x1, 0x1, 0x0, 0x0, 0x0, 0x0, 0xD0, 0xF7, 0x76, 0x0, 0x91, 0xE4, 0x76, 0x50, 0xDD, 0xF1, 0x76, 0xEC, 0xBB, 0xF1, 0x76, 0x15, 0xD, 0x1, 0x0, 0x1, 0x0, 0x0, 0x0, 0xA, 0x0, 0x0, 0x0, 0xEC, 0xBB, 0xF1, 0x76, 0x14, 0xD, 0x1, 0x0, 0xC8, 0x51, 0xF5, 0x7E, 0x0, 0x0, 0x0, 0x0, 0x50, 0xB1, 0xE4, 0x76, 0x50, 0xDD, 0xF1, 0x76, 0xD0, 0xB5, 0xE4, 0x76, 0x1, 0x0, 0x0, 0x0, 0x50, 0xDD, 0xF1, 0x76, 0xEC, 0xBB, 0xF1, 0x76, 0xD4, 0xF6, 0xE3, 0x76
arrow_left:		.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xE8, 0x7E, 0x84, 0x0, 0xE8, 0x7E, 0xF0, 0xDC, 0xFD, 0x76, 0x4, 0xF8, 0xE4, 0x76, 0x54, 0x6C, 0xE4, 0x76, 0x11, 0x7B, 0x9C, 0x7C, 0xD8, 0xE3, 0xE4, 0x3, 0x2B, 0x3, 0x1, 0x0, 0x48, 0x2, 0x1, 0x0, 0x30, 0xB9, 0xFC, 0x76, 0xF0, 0xDC, 0xFD, 0x76, 0xE8, 0x0, 0xE8, 0x7E, 0x88, 0xE8, 0xFD, 0x76, 0xBC, 0xA2, 0xFC, 0x76, 0x0, 0xE0, 0xFD, 0x76, 0x0, 0x0, 0x0, 0x0, 0x30, 0xC2, 0xFD, 0x76, 0x4, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x11, 0x7B, 0x9C, 0x7C, 0x18, 0xEB, 0xFD, 0x76, 0x0, 0x0, 0x0, 0x0, 0xE8, 0x0, 0xE8, 0x7E, 0xF0, 0x0, 0xE8, 0x7E, 0x5C, 0x1, 0xE8, 0x7E, 0x2B, 0x3, 0x1, 0x0, 0x44, 0x1, 0xE8, 0x7E, 0xFC, 0x7B, 0xFB, 0x76, 0xF0, 0x0, 0xE8, 0x7E, 0xBC, 0xEA, 0xFD, 0x76, 0x2, 0x0, 0x0, 0x0, 0x58, 0xC2, 0xFD, 0x76, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x0, 0x0, 0x0, 0x60, 0xE9, 0xFD, 0x76, 0x0, 0x0, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x18, 0xEB, 0xFD, 0x76, 0x60, 0xE9, 0xFD, 0x76, 0x30, 0x30, 0x30, 0x30, 0x0, 0x0, 0x0, 0x0, 0x64, 0x85, 0xE4, 0x76, 0x40, 0xBF, 0xFD, 0x76, 0x0, 0x0, 0x0, 0x0, 0xEC, 0xCB, 0xF7, 0x76, 0x50, 0xED, 0xF7, 0x76, 0xE8, 0x5, 0x0, 0x0, 0x44, 0x4, 0x0, 0x0, 0xEC, 0xCB, 0xF7, 0x76, 0x50, 0xED, 0xF7, 0x76, 0xE8, 0x5, 0x0, 0x0, 0x44, 0x4, 0x0, 0x0, 0xEC, 0xCB, 0xF7, 0x76, 0x8, 0xF0, 0x51, 0x1, 0x1, 0x0, 0x0, 0x0, 0x0, 0xE0, 0xFD, 0x76, 0x0, 0xA1, 0xEA, 0x76, 0x50, 0xED, 0xF7, 0x76, 0xEC, 0xCB, 0xF7, 0x76, 0x39, 0xD, 0x1, 0x0, 0x1, 0x0, 0x0, 0x0, 0xA, 0x0, 0x0, 0x0, 0xEC, 0xCB, 0xF7, 0x76, 0x38, 0xD, 0x1, 0x0, 0xCC, 0xD, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x50, 0xC1, 0xEA, 0x76, 0x50, 0xED, 0xF7, 0x76, 0xD0, 0xC5, 0xEA, 0x76, 0x1, 0x0, 0x0, 0x0, 0x50, 0xED, 0xF7, 0x76, 0xEC, 0xCB, 0xF7, 0x76, 0xD4, 0x6, 0xEA, 0x76
arrow_right: 	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x4F, 0xFA, 0x76, 0x84, 0xC0, 0xCB, 0x7E, 0x80, 0xC0, 0xCB, 0x7E, 0xBC, 0x32, 0xF9, 0x76, 0xF0, 0x6C, 0xFA, 0x76, 0x4, 0x88, 0xE1, 0x76, 0x54, 0xFC, 0xE0, 0x76, 0x53, 0x8C, 0x28, 0x21, 0x62, 0x44, 0x9, 0x1, 0x4F, 0x3, 0x1, 0x0, 0xF8, 0x2, 0x1, 0x0, 0x30, 0x32, 0x35, 0x30, 0xF0, 0x6C, 0xFA, 0x76, 0x0, 0x0, 0x0, 0x0, 0x8, 0x0, 0x0, 0x0, 0x7, 0x0, 0x0, 0x0, 0x68, 0xC1, 0xCB, 0x7E, 0xCC, 0xD, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x70, 0xFA, 0x76, 0x0, 0x0, 0x0, 0x0, 0xE0, 0x2A, 0xE5, 0x76, 0x2, 0x0, 0x0, 0x0, 0x9C, 0xC0, 0xCB, 0x7E, 0x18, 0x7B, 0xFA, 0x76, 0xA8, 0x6, 0x1, 0x0, 0xB0, 0xC, 0x1, 0x0, 0x7, 0x0, 0x0, 0x0, 0x7, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x7D, 0xC1, 0xCB, 0x7E, 0x74, 0x9, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x58, 0x52, 0xFA, 0x76, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xEC, 0x5B, 0xF4, 0x76, 0x50, 0x7D, 0xF4, 0x76, 0xE8, 0x5, 0x0, 0x0, 0x44, 0x4, 0x0, 0x0, 0xEC, 0x5B, 0xF4, 0x76, 0x50, 0x7D, 0xF4, 0x76, 0xE8, 0x5, 0x0, 0x0, 0x44, 0x4, 0x0, 0x0, 0xEC, 0x5B, 0xF4, 0x76, 0x8, 0x30, 0x36, 0x0, 0x1, 0x0, 0x0, 0x0, 0x0, 0x70, 0xFA, 0x76, 0x0, 0x31, 0xE7, 0x76, 0x50, 0x7D, 0xF4, 0x76, 0xEC, 0x5B, 0xF4, 0x76, 0x39, 0xD, 0x1, 0x0, 0x1, 0x0, 0x0, 0x0, 0xA, 0x0, 0x0, 0x0, 0xEC, 0x5B, 0xF4, 0x76, 0x38, 0xD, 0x1, 0x0, 0xCC, 0xD, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x50, 0x51, 0xE7, 0x76, 0x50, 0x7D, 0xF4, 0x76, 0xD0, 0x55, 0xE7, 0x76, 0x1, 0x0, 0x0, 0x0, 0x50, 0x7D, 0xF4, 0x76, 0xEC, 0x5B, 0xF4, 0x76, 0xD4, 0x96, 0xE6, 0x76
cross_hair:		.byte 0x0, 0x0, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x0, 0x0, 0x30, 0x30, 0x0, 0x0, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x0, 0x0, 0x30, 0x30, 0x0, 0x0, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xEF, 0xF8, 0x76, 0x84, 0x50, 0xB6, 0x7E, 0x80, 0x50, 0xB6, 0x7E, 0xBC, 0xD2, 0xF7, 0x76, 0xF0, 0xC, 0xF9, 0x76, 0x4, 0x28, 0xE0, 0x76, 0x54, 0x9C, 0xDF, 0x76, 0x53, 0x8C, 0x28, 0x21, 0x62, 0x44, 0x9, 0x1, 0x4F, 0x32, 0x35, 0x30, 0xF8, 0x2, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0xCF, 0x14, 0x2, 0x0, 0x7, 0x0, 0x0, 0x0, 0x68, 0x51, 0xB6, 0x7E, 0xD4, 0xD, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x10, 0xF9, 0x76, 0x0, 0x0, 0x0, 0x0, 0xE0, 0xCA, 0xE3, 0x76, 0x0, 0x0, 0x0, 0x0, 0x94, 0x50, 0xB6, 0x7E, 0x2, 0x0, 0x0, 0x0, 0xB0, 0x6, 0x1, 0x0, 0xB8, 0xC, 0x1, 0x0, 0x7, 0x0, 0x0, 0x0, 0x7, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x7D, 0x51, 0xB6, 0x7E, 0x8, 0x0, 0x0, 0x0, 0x7C, 0x9, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x58, 0xF2, 0xF8, 0x76, 0x0, 0x0, 0x0, 0x30, 0x0, 0x0, 0x30, 0x0, 0x0, 0x30, 0x0, 0x0, 0x30, 0x0, 0x0, 0x30, 0x0, 0x0, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x0, 0x0, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xEC, 0xFB, 0xF2, 0x76, 0x50, 0x1D, 0xF3, 0x76, 0xE8, 0x5, 0x0, 0x0, 0x44, 0x4, 0x0, 0x0, 0xEC, 0xFB, 0xF2, 0x76, 0x50, 0x1D, 0xF3, 0x76, 0xE8, 0x5, 0x0, 0x0, 0x44, 0x4, 0x0, 0x0, 0xEC, 0xFB, 0xF2, 0x76, 0x8, 0xC0, 0x6E, 0x0, 0x1, 0x0, 0x0, 0x0, 0x0, 0x10, 0xF9, 0x76, 0x0, 0xD1, 0xE5, 0x76, 0x50, 0x1D, 0xF3, 0x76, 0xEC, 0xFB, 0xF2, 0x76, 0x41, 0xD, 0x1, 0x0, 0x1, 0x0, 0x0, 0x0, 0xA, 0x0, 0x0, 0x0, 0xEC, 0xFB, 0xF2, 0x76, 0x40, 0xD, 0x1, 0x0, 0xD4, 0xD, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x50, 0xF1, 0xE5, 0x76, 0x50, 0x1D, 0xF3, 0x76, 0xD0, 0xF5, 0xE5, 0x76, 0x1, 0x0, 0x0, 0x0, 0x50, 0x1D, 0xF3, 0x76, 0xEC, 0xFB, 0xF2, 0x76, 0xD4, 0x36, 0xE5, 0x76
off:			.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x90, 0x81, 0x7E, 0x84, 0x90, 0x81, 0x7E, 0xF0, 0xBC, 0xFE, 0x76, 0x4, 0xD8, 0xE5, 0x76, 0x54, 0x4C, 0xE5, 0x76, 0x11, 0x7B, 0x9C, 0x7C, 0xD8, 0xE3, 0xE4, 0x3, 0x2B, 0x3, 0x1, 0x0, 0x48, 0x2, 0x1, 0x0, 0x30, 0x99, 0xFD, 0x76, 0xF0, 0xBC, 0xFE, 0x76, 0xE8, 0x90, 0x81, 0x7E, 0x88, 0xC8, 0xFE, 0x76, 0xBC, 0x82, 0xFD, 0x76, 0x0, 0xC0, 0xFE, 0x76, 0x0, 0x0, 0x0, 0x0, 0x30, 0xA2, 0xFE, 0x76, 0x4, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x11, 0x7B, 0x9C, 0x7C, 0x18, 0xCB, 0xFE, 0x76, 0x0, 0x0, 0x0, 0x0, 0xE8, 0x90, 0x81, 0x7E, 0xF0, 0x90, 0x81, 0x7E, 0x5C, 0x91, 0x81, 0x7E, 0x2B, 0x3, 0x1, 0x0, 0x44, 0x91, 0x81, 0x7E, 0xFC, 0x5B, 0xFC, 0x76, 0xF0, 0x90, 0x81, 0x7E, 0xBC, 0xCA, 0xFE, 0x76, 0x2, 0x0, 0x0, 0x0, 0x58, 0xA2, 0xFE, 0x76, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x0, 0x0, 0x0, 0x60, 0xC9, 0xFE, 0x76, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x18, 0xCB, 0xFE, 0x76, 0x60, 0xC9, 0xFE, 0x76, 0x30, 0x30, 0x30, 0x30, 0x0, 0x0, 0x0, 0x0, 0x64, 0x65, 0xE5, 0x76, 0x40, 0x9F, 0xFE, 0x76, 0x0, 0x0, 0x0, 0x0, 0xEC, 0xAB, 0xF8, 0x76, 0x50, 0xCD, 0xF8, 0x76, 0xE8, 0x5, 0x0, 0x0, 0x44, 0x4, 0x0, 0x0, 0xEC, 0xAB, 0xF8, 0x76, 0x50, 0xCD, 0xF8, 0x76, 0xE8, 0x5, 0x0, 0x0, 0x44, 0x4, 0x0, 0x0, 0xEC, 0xAB, 0xF8, 0x76, 0x8, 0xE0, 0x79, 0x1, 0x1, 0x0, 0x0, 0x0, 0x0, 0xC0, 0xFE, 0x76, 0x0, 0x81, 0xEB, 0x76, 0x50, 0xCD, 0xF8, 0x76, 0xEC, 0xAB, 0xF8, 0x76, 0x41, 0xD, 0x1, 0x0, 0x1, 0x0, 0x0, 0x0, 0xA, 0x0, 0x0, 0x0, 0xEC, 0xAB, 0xF8, 0x76, 0x40, 0xD, 0x1, 0x0, 0xD4, 0xD, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x50, 0xA1, 0xEB, 0x76, 0x50, 0xCD, 0xF8, 0x76, 0xD0, 0xA5, 0xEB, 0x76, 0x1, 0x0, 0x0, 0x0, 0x50, 0xCD, 0xF8, 0x76, 0xEC, 0xAB, 0xF8, 0x76, 0xD4, 0xE6, 0xEA, 0x76
joystick_buffer: .word 0x0
address_joystick: .word 0xf2
four: .word 0x4
val_comp:  .word 0x8   
