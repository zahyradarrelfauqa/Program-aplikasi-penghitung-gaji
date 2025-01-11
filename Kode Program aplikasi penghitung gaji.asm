.model small
.stack 100h
.data

    msg_garis1 db 0Dh, 0Ah, '+----------------------------------------------+',0Dh, 0Ah, '$'   
    mas_salam db 0Dh, 0Ah, '| Selamat Datang Karyawan PT. Dahlan Muda Jaya |',0Dh, 0Ah, '$'
    msg_garis2 db 0Dh, 0Ah, '+----------------------------------------------+',0Dh, 0Ah, '$'
    msg_nama db 0Dh, 0Ah, '| Masukkan nama karyawan: ', '$'
    msg_nikr db 0Dh, 0Ah, '| Masukkan nomor induk karyawan: ', '$'
    msg_jenis db 0Dh, 0Ah, '| Masukkan jenis karyawan (1 = Tetap, 2 = Freelance): ', '$' 
    msg_jmulai db 0Dh, 0Ah, '| Masukkan jam mulai kerja: ', '$'    
    msg_jselesai db 0Dh, 0Ah, '| Masukkan jam selesai kerja: ', '$'
    msg_hlembur db 0Dh, 0Ah, '| Masukkan jumlah hari lembur: ', '$'
    msg_jlembur db 0Dh, 0Ah, '| Masukkan jumlah jam lembur: ', '$' 
    msg_hkerja db 0Dh, 0Ah, '| Masukkan jumlah hari kerja dalam sebulan: ', '$'
    msg_garis3 db 0Dh, 0Ah, '+----------------------------------------------+',0Dh, 0Ah, '$'
    msg_totalkerja db 0Dh, 0Ah, '| Total Jam Bekerja : ', '$'
    msg_totalgaji db 0Dh, 0Ah, '| Total Gaji Anda: Rp ', '$'
    msg_garis4 db 0Dh, 0Ah, '+----------------------------------------------+',0Dh, 0Ah, '$'
    newline db 0Dh, 0Ah, '$'

    nama db 30 dup('$')
    nikr db 20 dup('$')
    jenis db ?  
    jam_mulai db ? 
    jam_selesai db ?           
    hari_lembur db ?        
    jam_lembur db ?            
    hari_kerja db ?  
    total_jkerja dw ?          
    total_gaji dw ?             
    input_buffer db 6 dup('$')

.code
mulai:
    mov ax, @data
    mov ds, ax

    lea dx, msg_garis1
    mov ah, 09h
    int 21h

    lea dx, mas_salam
    mov ah, 09h
    int 21h

    lea dx, msg_garis2
    mov ah, 09h
    int 21h

    lea dx, msg_nama
    mov ah, 09h
    int 21h

    lea dx, nama
    mov ah, 0Ah
    int 21h

    lea dx, msg_nikr
    mov ah, 09h
    int 21h

    lea dx, nikr
    mov ah, 0Ah
    int 21h

    lea dx, msg_jenis
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h
    sub al, '0'
    mov jenis, al

    lea dx, msg_jmulai
    mov ah, 09h
    int 21h

    call input_two_digits
    mov jam_mulai, ax

    lea dx, msg_jselesai
    mov ah, 09h
    int 21h

    call input_two_digits
    mov jam_selesai, ax

    lea dx, msg_hkerja
    mov ah, 09h
    int 21h

    call input_two_digits
    mov hari_kerja, ax

    lea dx, msg_hlembur
    mov ah, 09h
    int 21h

    call input_two_digits
    mov hari_lembur, ax

    lea dx, msg_jlembur
    mov ah, 09h
    int 21h

    call input_two_digits
    mov jam_lembur, ax

    mov al, jam_selesai
    sub al, jam_mulai       
    mov ah, 0
    mov total_jkerja, ax   

    mov ax, total_jkerja
    mov bx, hari_kerja
    mul bx
    mov total_jkerja, ax    

    mov ax, 0            
    mov bx, 0            

    cmp jenis, 1         
    je karyawan_tetap
    cmp jenis, 2         
    je karyawan_freelance
    jmp selesai          

karyawan_tetap:
    mov bx, 175          
    mov ax, hari_kerja
    mul bx               
    jmp lembur

karyawan_freelance:
    mov bx, 100          
    mov ax, hari_kerja
    mul bx               
    jmp lembur

lembur:
    mov cx, 15           
    mul jam_lembur       
    add ax, bx           

    mov total_gaji, ax  

    lea dx, msg_totalkerja
    mov ah, 09h
    int 21h

    mov ax, total_jkerja
    call tampil_angka    

    lea dx, msg_totalgaji
    mov ah, 09h
    int 21h

    mov ax, total_gaji
    call tampil_angka    

    lea dx, msg_garis3
    mov ah, 09h
    int 21h

selesai:
    mov ah, 4Ch
    int 21h

tampil_angka proc
    push ax
    push bx
    push cx
    push dx

    xor cx, cx           
    mov bx, 10           

ulang_angka:
    xor dx, dx           
    div bx               
    push dx              
    inc cx               
    cmp ax, 0
    jne ulang_angka      

tampil_digit:
    pop dx               
    add dl, '0'          
    mov ah, 02h
    int 21h
    loop tampil_digit    

    pop dx
    pop cx
    pop bx
    pop ax
    ret
tampil_angka endp

input_two_digits proc
    lea dx, input_buffer
    mov ah, 0Ah
    int 21h
    mov al, [input_buffer+1]
    sub al, '0'
    mov ah, [input_buffer+2]
    sub ah, '0'
    mov ax, 0
    mov bl, 10
    mul bl
    add ax, bx
    ret
input_two_digits endp
