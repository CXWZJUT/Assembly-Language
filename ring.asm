.model small
.stack
.data
count dw
msg db ' The bell is ringing!',0dh,0dh,'$'
.code

main  proc  far
start:
      mov ax,@data
	  mov ds,ax
	  
;save old interrupt vector 保存旧的中断向量
      mov al,1ch
	  mov ah,35h
	  int 21h   ;call DOS
	  push es
	  push bx
	  push ds
	  
	  
;set new interrupt vector 设置新的中断向量
      mov dx,offset ring  ;ring的偏移地址放入dx
	  mov ax,seg ring     ;ring的段地址放入ax
	  mov ds,ax
	  mov al,1ch          ;中断型号
	  mov ah,25h          ;设置中断向量
	  int 21h
	  
	  pop ds\
	  in  al,21h
	  and al,11111110b    ;重新增设定时器中断
	  out 21h,al
	  
	  sti                 ;允许中断嵌套
	  
	  mov di,20000
delay:
      mov si,30000
delay1:
      dec  si 
	  jnz  delay1  ;结果不为零（或不相等）则转移
	  dec  di
	  jnz  delay   ;结果不为零（或不相等）则转移
	  
	  
;restore old interrupt vector恢复旧的中断向量
      pop dx
	  pop ds
	  mov al,1ch
	  mov ah,25h
	  int 21h
	  
	  mov ax,4c00h   ; 退出
	  int 21h
mian endp
	

ring proc near
     push ds
	 push ax
	 push cx
	 push dx
	 
	 mov ax,@data
	 mov ds,ax
	 sti             ;允许中断嵌套
	 
	 
	 dec count 
	 jnz exit
	 
	 mov dx,offset msg
	 mov ah,09h         ;to display msg
	 int 21h
	 
	 mov dx,100
	 in al,61h        ;get 端口61
	 and al,0fch
	 
sound:
     xor al,02
	 out 61h,al
	 
	 mov cx,1400h
	 
waitl:
     loop waitl
	 dec dx      ;dx=dx-1
	 jne sound   ; dx!=0,jump to sound
	 mov count 182
exit:
     cli    ;关中断
	 pop dx
	 pop cx 
	 pop ax
	 pop ds
	 iret
ring endp
     end start
	 
	 
	 
	 
	 
	 
	 
	 
	
	  
	  
	  
	  