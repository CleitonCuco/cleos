[org 7c00h]
[bits 16]

start:
  xor ax,ax
  mov ds,ax
  mov ss,ax
  mov es,ax
  mov sp,7c00h

  mov si,msg
  call print_string

hang:
  hlt
  jmp hang

  

print_string:
  lodsb
  or al,al
  jz .done
  mov ah,0x0e
  mov bh,255
  int 10h
  jmp print_string
.done:
  ret

msg db 'hi,first booting attempt',0 

times 510 - ($-$$) db 0 
dw 0xaa55


