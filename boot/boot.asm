[org 0x7c00]
[bits 16]

STAGE2_SECTORS equ 4

start:
  xor ax,ax
  mov ds,ax
  mov ss,ax
  mov es,ax
  mov sp,0x7c00
  cld

  mov [boot_drive],dl

  mov si,msg_boot
  call print_string

  mov ah,0x02
  mov al,STAGE2_SECTORS
  mov ch,0
  mov cl,2
  mov dh,0
  mov dl,[boot_drive]
  mov bx,0x7e00
  int 0x13
  jc disk_error
  cmp al,STAGE2_SECTORS
  jne disk_error

  jmp stage2

disk_error:
  mov si,msg_error
  call print_string
.hang:
  hlt
  jmp .hang

print_string:
  lodsb
  or al,al
  jz .done
  mov ah,0x0e
  mov bh,0
  int 0x10
  jmp print_string
.done:
  ret

boot_drive db 0
msg_boot   db 'boot ok, loading stage 2...',13,10,0
msg_error  db 'disk error',0

times 510 - ($-$$) db 0
dw 0xaa55

stage2:
  mov si,msg_stage2
  call print_string
.hang:
  hlt
  jmp .hang

msg_stage2 db 'by seeing this it means the stage 2 loading attempt did not suck much',0

times (STAGE2_SECTORS*512) - ($  stage2) db 0
