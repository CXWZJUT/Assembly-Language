assum cx:code


code segment
       
       
      mov ax,1000h
      add ax,ax
      mov bx,2000h
      
      mov ax,4c00h
      int 21h   
code ends
end
      