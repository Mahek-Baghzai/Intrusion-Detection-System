.model small
.stack 100h

.data

; =========================================================
;                    LOGIN DATA
; =========================================================

correctUser db 'mahek'
correctPass db '1234'

username    db 21 dup(0)
password    db 21 dup(0)

usernameLen db 0
passwordLen db 0


; =========================================================
;                 SECURITY VARIABLES
; =========================================================

failedAttempts   db 0
successfulLogins db 0
systemLocked     db 0


; =========================================================
;                    SCREEN MESSAGES
; =========================================================

titleMsg db 13,10
         db '============================================',13,10
         db '        INTRUSION DETECTION SYSTEM',13,10
         db '============================================',13,10,'$'


menuMsg db 13,10
        db '-------------- MAIN MENU -----------------',13,10
        db '1. Secure Login',13,10
        db '2. Security Status / Log',13,10
        db '3. Reset Security System',13,10
        db '4. Exit',13,10
        db '--------------------------------------------',13,10
        db 'Enter your choice: $'


userMsg db 13,10
        db 'Enter Username: $'

passMsg db 13,10
        db 'Enter Password: $'


correctMsg db 13,10
           db '--------------------------------------------',13,10
           db '           ACCESS GRANTED!',13,10
           db '           Welcome, Admin!',13,10
           db '--------------------------------------------',13,10,'$'


wrongMsg db 13,10
         db 'ACCESS DENIED!',13,10
         db 'Invalid username or password.',13,10,'$'


attemptMsg db 'Failed attempts: $'


alertMsg db 13,10
         db '********************************************',13,10
         db '*          !!! SECURITY ALERT !!!         *',13,10
         db '********************************************',13,10
         db '*          INTRUSION DETECTED!             *',13,10
         db '*          SYSTEM HAS BEEN LOCKED!         *',13,10
         db '********************************************',13,10,'$'


lockedMsg db 13,10
          db '============================================',13,10
          db '             SYSTEM IS LOCKED!',13,10
          db 'Too many failed login attempts detected.',13,10
          db 'Please reset the security system.',13,10
          db '============================================',13,10,'$'


statusTitle db 13,10
            db '========= SECURITY STATUS / LOG =========',13,10,'$'


failedMsg db 'Failed Login Attempts : $'

successMsg db 13,10
           db 'Successful Logins     : $'


maxMsg db 13,10
       db 'Maximum Allowed       : 3',13,10,'$'


secureMsg db 'System Status          : SECURE',13,10,'$'


lockedStatusMsg db 'System Status          : LOCKED',13,10,'$'


resetMsg db 13,10
         db '============================================',13,10
         db '       SECURITY SYSTEM HAS BEEN RESET',13,10
         db '       Failed attempts cleared.',13,10
         db '       System status: SECURE',13,10
         db '============================================',13,10,'$'


invalidMsg db 13,10
           db 'Invalid choice! Please select 1-4.',13,10,'$'


pressMsg db 13,10
         db 'Press any key to continue...$'


exitMsg db 13,10
        db '============================================',13,10
        db '  Exiting Intrusion Detection System...',13,10
        db '             Goodbye!',13,10
        db '============================================',13,10,'$'


; =========================================================
;                        CODE
; =========================================================

.code

main proc

    ; Initialize Data Segment
    mov ax, @data
    mov ds, ax

    ; Display program title
    lea dx, titleMsg
    mov ah, 09h
    int 21h


; =========================================================
;                      MAIN MENU
; =========================================================

mainMenu:

    lea dx, menuMsg
    mov ah, 09h
    int 21h

    ; Read menu choice
    mov ah, 01h
    int 21h

    ; Check choice immediately
    ; before another DOS interrupt changes AL

    cmp al, '1'
    je secureLogin

    cmp al, '2'
    je securityStatus

    cmp al, '3'
    je resetSystem

    cmp al, '4'
    je exitProgram


    ; Invalid choice

    lea dx, invalidMsg
    mov ah, 09h
    int 21h

    call pauseProgram

    jmp mainMenu



; =========================================================
;                     SECURE LOGIN
; =========================================================

secureLogin:

    ; Check whether system is locked

    cmp systemLocked, 1
    je showLocked


    ; -----------------------------------------------------
    ; Enter Username
    ; -----------------------------------------------------

    lea dx, userMsg
    mov ah, 09h
    int 21h

    lea si, username
    mov cx, 20

    call readUsername


    ; -----------------------------------------------------
    ; Enter Password
    ; -----------------------------------------------------

    lea dx, passMsg
    mov ah, 09h
    int 21h

    lea si, password
    mov cx, 20

    call readPassword


    ; -----------------------------------------------------
    ; Check Username
    ; -----------------------------------------------------

    call checkUsername

    cmp al, 0
    je loginFailed


    ; -----------------------------------------------------
    ; Check Password
    ; -----------------------------------------------------

    call checkPassword

    cmp al, 0
    je loginFailed


    ; =====================================================
    ; LOGIN SUCCESSFUL
    ; =====================================================

    inc successfulLogins

    lea dx, correctMsg
    mov ah, 09h
    int 21h

    call pauseProgram

    jmp mainMenu



; =========================================================
;                    LOGIN FAILED
; =========================================================

loginFailed:

    inc failedAttempts

    lea dx, wrongMsg
    mov ah, 09h
    int 21h


    lea dx, attemptMsg
    mov ah, 09h
    int 21h

    mov al, failedAttempts
    call printNumber


    ; Check if failed attempts reached 3

    cmp failedAttempts, 3
    jae triggerAlert


    call pauseProgram

    jmp mainMenu



; =========================================================
;                  INTRUSION ALERT
; =========================================================

triggerAlert:

    mov systemLocked, 1

    lea dx, alertMsg
    mov ah, 09h
    int 21h


    ; Beep / Alarm

    mov dl, 07h
    mov ah, 02h
    int 21h


    call pauseProgram

    jmp mainMenu



; =========================================================
;                    SYSTEM LOCKED
; =========================================================

showLocked:

    lea dx, lockedMsg
    mov ah, 09h
    int 21h

    call pauseProgram

    jmp mainMenu



; =========================================================
;              SECURITY STATUS / LOG
; =========================================================

securityStatus:

    lea dx, statusTitle
    mov ah, 09h
    int 21h


    ; -----------------------------------------------------
    ; Display Failed Attempts
    ; -----------------------------------------------------

    lea dx, failedMsg
    mov ah, 09h
    int 21h

    mov al, failedAttempts
    call printNumber


    ; -----------------------------------------------------
    ; Display Successful Logins
    ; -----------------------------------------------------

    lea dx, successMsg
    mov ah, 09h
    int 21h

    mov al, successfulLogins
    call printNumber


    ; -----------------------------------------------------
    ; Display Maximum Attempts
    ; -----------------------------------------------------

    lea dx, maxMsg
    mov ah, 09h
    int 21h


    ; -----------------------------------------------------
    ; Display Current System Status
    ; -----------------------------------------------------

    cmp systemLocked, 1
    je displayLockedStatus


    lea dx, secureMsg
    mov ah, 09h
    int 21h

    jmp statusFinished


displayLockedStatus:

    lea dx, lockedStatusMsg
    mov ah, 09h
    int 21h


statusFinished:

    call pauseProgram

    jmp mainMenu



; =========================================================
;                 RESET SECURITY SYSTEM
; =========================================================

resetSystem:

    ; Clear failed attempts
    mov failedAttempts, 0

    ; Clear successful login counter
    mov successfulLogins, 0

    ; Unlock system
    mov systemLocked, 0


    lea dx, resetMsg
    mov ah, 09h
    int 21h


    call pauseProgram

    jmp mainMenu



; =========================================================
;                  CHECK USERNAME
;
; Returns:
; AL = 1 -> Correct
; AL = 0 -> Incorrect
; =========================================================

checkUsername:

    ; Correct username length is 5

    cmp usernameLen, 5
    jne usernameIncorrect


    lea si, username
    lea di, correctUser

    mov cx, 5


compareUsername:

    mov al, [si]

    cmp al, [di]
    jne usernameIncorrect

    inc si
    inc di

    loop compareUsername


    mov al, 1
    ret


usernameIncorrect:

    mov al, 0
    ret



; =========================================================
;                  CHECK PASSWORD
;
; Returns:
; AL = 1 -> Correct
; AL = 0 -> Incorrect
; =========================================================

checkPassword:

    ; Correct password length is 4

    cmp passwordLen, 4
    jne passwordIncorrect


    lea si, password
    lea di, correctPass

    mov cx, 4


comparePassword:

    mov al, [si]

    cmp al, [di]
    jne passwordIncorrect

    inc si
    inc di

    loop comparePassword


    mov al, 1
    ret


passwordIncorrect:

    mov al, 0
    ret



; =========================================================
;                    READ USERNAME
; =========================================================

readUsername:

    xor bx, bx


readUsernameLoop:

    ; Read character

    mov ah, 01h
    int 21h


    ; Check ENTER

    cmp al, 13
    je usernameDone


    ; Maximum 20 characters

    cmp bl, 20
    jae usernameDone


    ; Store character

    mov [si], al

    inc si
    inc bl

    jmp readUsernameLoop


usernameDone:

    mov usernameLen, bl


    ; New line

    mov dl, 13
    mov ah, 02h
    int 21h

    mov dl, 10
    mov ah, 02h
    int 21h

    ret



; =========================================================
;                    READ PASSWORD
;                    Displays * instead
; =========================================================

readPassword:

    xor bx, bx


readPasswordLoop:

    ; Read character

    mov ah, 01h
    int 21h


    ; Check ENTER

    cmp al, 13
    je passwordDone


    ; Maximum 20 characters

    cmp bl, 20
    jae passwordDone


    ; Store actual password character

    mov [si], al

    inc si
    inc bl


    ; Display *

    mov dl, '*'
    mov ah, 02h
    int 21h


    jmp readPasswordLoop


passwordDone:

    mov passwordLen, bl


    ; New line

    mov dl, 13
    mov ah, 02h
    int 21h

    mov dl, 10
    mov ah, 02h
    int 21h

    ret



; =========================================================
;                    PRINT NUMBER
;
; AL contains number from 0-255
; =========================================================

printNumber:

    xor ah, ah


    ; -----------------------------------------------------
    ; Check for one digit
    ; -----------------------------------------------------

    cmp al, 10
    jb printSingleDigit


    ; -----------------------------------------------------
    ; Check for two digits
    ; -----------------------------------------------------

    cmp al, 100
    jb printTwoDigits


    ; -----------------------------------------------------
    ; Three digit number
    ; -----------------------------------------------------

    xor ah, ah

    mov bl, 100
    div bl

    ; AL = hundreds
    ; AH = remainder

    mov bh, ah

    add al, '0'

    mov dl, al
    mov ah, 02h
    int 21h


    ; Get remainder

    mov al, bh
    xor ah, ah

    mov bl, 10
    div bl

    ; AL = tens
    ; AH = ones

    add al, '0'

    mov dl, al

    mov bh, ah

    mov ah, 02h
    int 21h


    ; Print ones

    mov dl, bh
    add dl, '0'

    mov ah, 02h
    int 21h

    ret



; =========================================================
;                    TWO DIGITS
; =========================================================

printTwoDigits:

    xor ah, ah

    mov bl, 10
    div bl

    ; AL = tens
    ; AH = ones

    add al, '0'

    mov dl, al

    mov bh, ah

    mov ah, 02h
    int 21h


    ; Print ones

    mov dl, bh
    add dl, '0'

    mov ah, 02h
    int 21h

    ret



; =========================================================
;                    ONE DIGIT
; =========================================================

printSingleDigit:

    add al, '0'

    mov dl, al

    mov ah, 02h
    int 21h

    ret



; =========================================================
;                    PAUSE PROGRAM
; =========================================================

pauseProgram:

    lea dx, pressMsg
    mov ah, 09h
    int 21h


    mov ah, 01h
    int 21h


    ; New line

    mov dl, 13
    mov ah, 02h
    int 21h

    mov dl, 10
    mov ah, 02h
    int 21h

    ret



; =========================================================
;                       EXIT
; =========================================================

exitProgram:

    lea dx, exitMsg
    mov ah, 09h
    int 21h


    mov ah, 4Ch
    mov al, 00h
    int 21h


main endp

end main