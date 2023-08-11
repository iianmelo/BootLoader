org 0x7e00
jmp 0x0000:start

margem db '------------------------------------',0
;Menu

%include "sprite.asm"

%define CoordXInicialCX 10  ;coluna
%define CoordYInicialDX 80  ;linha

%define CoordXInicialCX_obstaculo1 280 ;coluna
%define CoordYInicialDX_obstaculo1 75  ;linha
%define CoordXInicialCX_obstaculo2 140 ;coluna
%define CoordYInicialDX_obstaculo2 35  ;linha
%define life 3
%define velocidade_inicial 1

titulo	db	'TRAFFIC RACER', 0
opcao1 	db	'1 - PLAY', 0jm
opcao2	db	'2 - INSTRUCTIONS', 0
opcao3	db	'3 - CREDITS', 0

bug db ' ', 0

;Variaveis
carro_pos times 10 db 0
vida times 5 db 0
arvore_pos times 10 db 0
arvore_pos2 times 10 db 0
obstaculo1_pos times 10 db 0
obstaculo2_pos times 10 db 0
score_player times 10 db 0
obst_linha1 times 10 db 0
obst_linha2 times 10 db 0
velocidade_atual times 10 db 0

;Creditos
alunos 	db 'ALUNOS :', 0
raas 	db '<raas>', 0
imm2 	db '<imm2>', 0
jvfr 	db '<jvfr>', 0
hlpaa 	db '<hlpaa>', 0
esc 	db 'press ESC to return', 0

;Instrucoes/ ALTERAR
como 	db	'-Para jogar basta usar seta pra cima e pra baixo.', 0
score	db 	'-Com o passar do tempo sua pontuacao aumenta.', 0
lose	db	'-Se bater em algum obstaculo perde.', 0

;Jogo
score_show db 'SCORE:', 0
score_num times 20 db 0
linha_num times 20 db 0
vida_show db 'VIDA: ', 0

;Game over
game_over_string db '  GAME OVER!', 0
jogar_denovo     db '1 - JOGAR DE NOVO', 0 
ir_menu          db '2 - MENU PRINCIPAL', 0

;Voce venceu!
voce_venceu_string db 'PARABENS! VOCE VENCEU O JOGO!', 0

start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    
    call Menu

jmp $

Menu:

	mov ax, 13h; VGA mode 13h 320x200
    int 10h
	
	;Mudando a cor do background
  	mov ah, 0xb ; escolhe a cor da telacarro_verm
	mov bh, 0
	mov bl, 0   ;COR
	int 10h     ;VIDEO
	
	;margem superior
	mov ah, 02h  ;move o cursor para o lugar certo
	mov bh, 0    ;Pagina 0
	mov dh, 1    ;Linha
	mov dl, 2   ;Coluna
	int 10h
	mov bl, 14
	mov si, margem
	call print_string
	
	;Titulo-str
	mov ah, 02h  ;move o cursor para o lugar certo
	mov bh, 0    ;Pagina 0
	mov dh, 1    ;Linha
	mov dl, 14   ;Coluna
	int 10h
	mov bl, 14
	mov si, titulo
	call print_string
	
	;Play-str
	mov ah, 02h  ;move o cursor para o lugar certo
	mov bh, 0    ;Pagina 0
	mov dh, 9    ;Linha
	mov dl, 12   ;Coluna
	int 10h
	mov bl, 14
	mov si, opcao1
	call print_string
	
	;Instructions-str
	mov ah, 02h  ;move o cursor para o lugar certo
	mov bh, 0    ;Pagina 0
	mov dh, 12   ;Linha
	mov dl, 12   ;Coluna
	int 10h
	mov bl, 14
	mov si, opcao2
	call print_string
	
	;credits-str
	mov ah, 02h  ;move o cursor para o lugar certo
	mov bh, 0    ;Pagina 0
	mov dh, 15   ;Linha
	mov dl, 12   ;Coluna
	int 10h
	mov bl, 14
	mov si, opcao3
	call print_string
	
	ler_opcao:
		mov ah, 0
		int 16h ; teclado al-> recebe ASCII 
		
		cmp al, '1'
		je loop_game
		
		cmp al, '2'
		je intructions
		
		cmp al, '3'
		je credits
		
		jne ler_opcao
		

credits:
	
	mov ax, 13h; VGA mode 13h 320x200
    int 10h
	
	;Mudando a cor do background
  	mov ah, 0xb ; escolhe a cor da tela
	mov bh, 0
	mov bl, 0   ;COR
	int 10h     ;VIDEO
	
	;margem superior
	mov ah, 02h  ;move o cursor para o lugar certo
	mov bh, 0    ;Pagina 0
	mov dh, 1    ;Linha
	mov dl, 2    ;Coluna
	int 10h
	mov bl, 14
	mov si, margem
	call print_string
	
	;Titulo-str
	mov ah, 02h  ;move o cursor para o lugar certo
	mov bh, 0    ;Pagina 0
	mov dh, 1    ;Linha
	mov dl, 14   ;Coluna
	int 10h
	mov bl, 14
	mov si, titulo
	call print_string
	
	
	mov ah, 02h  ;move o cursor para o lugar certo
	mov bh, 0    ;Pagina 0
	mov dh, 3    ;Linha
	mov dl, 2    ;Coluna
	int 10h
	mov bl, 14
	mov si, alunos
	call print_string_delay
	
	mov ah, 02h  ;move o cursor para o lugar certo
	mov bh, 0    ;Pagina 0
	mov dh, 6   ;Linha
	mov dl, 4   ;Coluna
	int 10h
	mov bl, 14
	mov si, raas
	call print_string_delay

	mov ah, 02h  ;move o cursor para o lugar certo
	mov bh, 0    ;Pagina 0
	mov dh, 9    ;Linha
	mov dl, 4    ;Coluna
	int 10h
	mov bl, 14
	mov si, imm2
	call print_string_delay
	
	mov ah, 02h  ;move o cursor para o lugar certo
	mov bh, 0    ;Pagina 0
	mov dh, 12   ;Linha
	mov dl, 4    ;Coluna
	int 10h
	mov bl, 14
	mov si, jvfr
	call print_string_delay
	
	mov ah, 02h  ;move o cursor para o lugar certo
	mov bh, 0    ;Pagina 0
	mov dh, 15   ;Linha
	mov dl, 4    ;Coluna
	int 10h
	mov bl, 14
	mov si, hlpaa
	call print_string_delay
	
	mov ah, 02h  ;move o cursor para o lugar certo
	mov bh, 0    ;Pagina 0
	mov dh, 22   ;Linha
	mov dl, 10   ;Coluna
	int 10h
	mov bl, 14
	mov si, esc
	call print_string
	
	mov ah, 0
	int 16h ; teclado al-> recebe ASCII 

	call instruction_wait
	
intructions:
	
	mov ax, 13h; VGA mode 13h 320x200
    int 10h
	
	;Mudando a cor do background
  	mov ah, 0xb ; escolhe a cor da tela
	mov bh, 0
	mov bl, 0   ;COR
	int 10h     ;VIDEO
	
	;margem superior
	mov ah, 02h  ;move o cursor para o lugar certo
	mov bh, 0    ;Pagina 0
	mov dh, 1    ;Linha
	mov dl, 2   ;Coluna
	int 10h
	mov bl, 14
	mov si, margem
	call print_string
	
	;Titulo-str
	mov ah, 02h  ;move o cursor para o lugar certo
	mov bh, 0    ;Pagina 0
	mov dh, 1    ;Linha
	mov dl, 14   ;Coluna
	int 10h
	mov bl, 14
	mov si, titulo
	call print_string
	
	mov ah, 02h  ;move o cursor para o lugar certo
	mov bh, 0    ;Pagina 0
	mov dh, 5   ;Linha
	mov dl, 3   ;Coluna
	int 10h
	mov bl, 14
	mov si, como
	call print_string_delay
	
	mov ah, 02h  ;move o cursor para o lugar certo
	mov bh, 0    ;Pagina 0
	mov dh, 10   ;Linha
	mov dl, 3   ;Coluna
	int 10h
	mov bl, 14
	mov si, score
	call print_string_delay
	
	mov ah, 02h  ;move o cursor para o lugar certo
	mov bh, 0    ;Pagina 0
	mov dh, 15   ;Linha
	mov dl, 3   ;Coluna
	int 10h
	mov bl, 14
	mov si, lose
	call print_string_delay
	
	mov ah, 02h  ;move o cursor para o lugar certo
	mov bh, 0    ;Pagina 0
	mov dh, 22   ;Linha
	mov dl, 10   ;Coluna
	int 10h
	mov bl, 14
	mov si, esc
	call print_string
	
	mov ah, 0
	int 16h ; teclado al-> recebe ASCII 

	call instruction_wait

instruction_wait:
	
	mov ah, 0
	int 16h
	
	cmp al, 27
	je Menu
	jne instruction_wait
	
loop_game:

	mov ax, 13h; VGA mode 13h 320x200
    int 10h
	
	;Mudando a cor do background
  	mov ah, 0xb ; escolhe a cor da tela
	mov bh, 0
	mov bl, 0   ;COR
	int 10h     ;VIDEO

	call salvar_vida

	call draw_pista

	mov ax, 0h

	;armazenando a posicao inicial do carro
	mov dx, CoordYInicialDX
	mov cx, CoordXInicialCX
	call salvar_posicao_carro
	
	;printando o carro pela primeira vez:
	call print_carro
	
	;armazenando a posicao inicial dos obstaculos:
	mov dx, CoordYInicialDX_obstaculo1
	mov cx, CoordXInicialCX_obstaculo1
	call salvar_posicao_obstaculo1
	
	call print_obstaculo1
	
	mov dx, CoordYInicialDX_obstaculo2
	mov cx, CoordXInicialCX_obstaculo2
	call salvar_posicao_obstaculo2
	
	call print_obstaculo1
	
	;setando a score como 0
	call carregar_score_player
	mov ax, 0
	call salvar_score_player

	;Setando a linha
	call carregar_linha1
	mov ax, 0
	call salvar_linha1
	
	;setando a linha
	call carregar_linha2
	mov ax, 6
	call salvar_linha2

	;setando velocidade inicial
	call carregar_velocidade
	mov ax, 1
	call salvar_velocidade

	;printando as frases pela primeira vez:
	call print_score_frase
	call print_vida_frase
	
	
	.controlar_carro:
		
		call .main_loop

		;vendo se o teclado foi apertado
		mov ah, 1h
		int 16h
		jnz .press ;se foi, ver qual a tecla
		
		call carregar_posicao_carro
		call print_carro
		jmp .controlar_carro
		
	.press:
	
		mov ah, 00h
		int 16h

		;caso seja esc:
		cmp al, 27
		je Menu

		cmp al, 'w'
		je .mover_cima

		cmp al, 's'
		je .mover_baixo
		
		jmp .controlar_carro

	.mover_cima:
		
		;carregando coordenada do carro
		call carregar_posicao_carro

		;apagando a posicao antiga
		mov si, null
		call _print_sprite

		;atualizando coordenada para faixa de cima
		sub dx, 40

		;checando se esta fora do limite superior
		cmp dx, 40
		jl .foradapistaAlto

		;desenhando nova posicao
		call print_carro

		call salvar_posicao_carro
		jmp .controlar_carro
		                                                            
	.mover_baixo:

		;carregando posicao do carro em dx, cx
		call carregar_posicao_carro

		;apagando a posicao antiga
		mov si, null
		call _print_sprite

		;atualizando coordenada para faixa de baixo
		add dx, 40

		;checando se esta fora do limite inferior
		cmp dx, 120
		jg .foradapistaBaixo

		;desenhando nova posicao
		call print_carro
		
		call salvar_posicao_carro
		jmp .controlar_carro

	.foradapistaAlto:
		mov dx, 40
		
		call print_carro
		call salvar_posicao_carro

		jmp .controlar_carro

	.foradapistaBaixo:
		mov dx, 120
		
		call print_carro
		call salvar_posicao_carro

		jmp .controlar_carro

	.main_loop:
		
		;vendo se o jogo acabou perdendo
		call carregar_vida
		cmp ax, 0
		je game_over

		;vendo se o jogo acabou ganhando
		call carregar_score_player
		cmp ax, 2000 ;quanto para ganhar
		jg tela_venceu
		
		;apagando a posicao do obstaculo1
		call carregar_posicao_obstaculo1
		call apagar_obstaculo1
		
		;movendo o obstaculo1 para a esquerda
		call carregar_posicao_obstaculo1
		call carregar_velocidade
		sub cx, ax
		
		;verificando se o obstaculo1 saiu da pista
		cmp cx, 5
		jl .reseta_obstaculo1
		
		;salvando posicao do obstaculo1 e printando
		call salvar_posicao_obstaculo1
		call print_obstaculo1
		
		;apagando a posicao do obstaculo2
		call carregar_posicao_obstaculo2
		call apagar_obstaculo2
		
		;movendo o obstaculo2 para a esquerda
		call carregar_posicao_obstaculo2
		call carregar_velocidade
		sub cx, ax
		
		;verificando se o obstaculo2 saiu da pista
		cmp cx, 5
		jl .reseta_obstaculo2
		
		;salvando posicao do obstaculo2 e printando
		call salvar_posicao_obstaculo2
		call print_obstaculo1
		
		;mudando velocidade
		call mudar_velocidade

		;aumentando a score
		call carregar_score_player
		inc ax
		call salvar_score_player

		;printando score
		call print_score_numero
		
		;printando barra da vida
		call print_barra_vida

		;verificando colisao
		call checkCollision1
		call checkCollision2

		ret

	.reseta_obstaculo1:
		mov si, nullc ;apagando posicao antiga do obstaculo1
		call _print_sprite

		;Salvando a linha do obstaculo1
		call carregar_linha1
		inc ax
		call salvar_linha1

		mov cx, CoordXInicialCX_obstaculo1 ;resetando coordenadas
		;mov dx, CoordYInicialDX_obstaculo1
		jmp .mudar_linha1
		
		call salvar_posicao_obstaculo1
		call print_obstaculo1

		ret
		
	.reseta_obstaculo2:
		mov si, nullc
		call _print_sprite
		
		;Salvando a linha do obstaculo2
		call carregar_linha2
		inc ax
		call salvar_linha2
		
		mov cx, 280 ;resetando coordenadas
		;mov dx, CoordYInicialDX_obstaculo2
		jmp .mudar_linha2
		;mov dx, 35
		
		call salvar_posicao_obstaculo2
		call print_obstaculo1
	ret
	
	.mudar_linha1:
		call carregar_linha1
		mov bl, 11
		div bl; ah = %3
		cmp ah, 0
		je .coluna0
		cmp ah, 1
		je .coluna1
		cmp ah, 2
		je .coluna2
		cmp ah, 3
		je .coluna3
		cmp ah, 4
		je .coluna4
		cmp ah, 5
		je .coluna5
		cmp ah, 6
		je .coluna6
		cmp ah, 7
		je .coluna7
		cmp ah, 8
		je .coluna8
		cmp ah, 9
		je .coluna9
		cmp ah, 10
		je .coluna10


		.coluna0:
			mov dx, 35
			jmp .parte2
		.coluna1:
			mov dx, 75
			jmp .parte2
		.coluna2:
			mov dx, 115
			jmp .parte2
		.coluna3:
			mov dx, 75
			jmp .parte2
		.coluna4:
			mov dx, 115
			jmp .parte2
		.coluna5:
			mov dx, 35
			jmp .parte2
		.coluna6:
			mov dx, 115
			jmp .parte2
		.coluna7:
			mov dx, 75
			jmp .parte2
		.coluna8:
			mov dx, 115
			jmp .parte2
		.coluna9:
			mov dx, 35
			jmp .parte2
		.coluna10:
			mov dx, 75
			jmp .parte2
		.parte2:
			call salvar_posicao_obstaculo1
			call print_obstaculo1

		ret
		
	.mudar_linha2:
		call carregar_linha2
		mov bl, 11
		div bl; ah = %3
		cmp ah, 0
		je .2coluna0
		cmp ah, 1
		je .2coluna1
		cmp ah, 2
		je .2coluna2
		cmp ah, 3
		je .2coluna3
		cmp ah, 4
		je .2coluna4
		cmp ah, 5
		je .2coluna5
		cmp ah, 6
		je .2coluna6
		cmp ah, 7
		je .2coluna7
		cmp ah, 8
		je .2coluna8
		cmp ah, 9
		je .2coluna9
		cmp ah, 10
		je .2coluna10


		.2coluna0:
			mov dx, 35
			jmp .2parte2
		.2coluna1:
			mov dx, 75
			jmp .2parte2
		.2coluna2:
			mov dx, 115
			jmp .2parte2
		.2coluna3:
			mov dx, 75
			jmp .2parte2
		.2coluna4:
			mov dx, 115
			jmp .2parte2
		.2coluna5:
			mov dx, 35
			jmp .2parte2
		.2coluna6:
			mov dx, 115
			jmp .2parte2
		.2coluna7:
			mov dx, 75
			jmp .2parte2
		.2coluna8:
			mov dx, 115
			jmp .2parte2
		.2coluna9:
			mov dx, 35
			jmp .2parte2
		.2coluna10:
			mov dx, 75
			jmp .2parte2
		.2parte2:
			call salvar_posicao_obstaculo2
			call print_obstaculo1
			ret

	

mudar_velocidade:
;funcao que muda velocidade do jogo conforme score aumenta
	
	call carregar_score_player ;setando o ax como valor do score
		
	cmp ax, 1500
	je .mudar_score_70
		
	cmp ax, 1000
	je .mudar_score_50	
	
	cmp ax, 600
	je .mudar_score_30
	
	cmp ax, 200
	je .mudar_score_10
	
	.fim:
		ret
		
	.mudar_score_10:
		mov ax, 2
		call salvar_velocidade
		jmp .fim
	
	.mudar_score_30:
		mov ax, 3
		call salvar_velocidade
		jmp .fim
		
	.mudar_score_50:
		mov ax, 4
		call salvar_velocidade
		jmp .fim
		
	.mudar_score_70:
		mov ax, 5
		call salvar_velocidade
		jmp .fim
		

game_over:

	;colocando a tela toda preta:
	mov ax, 13h; VGA mode 13h 320x200
    int 10h
  	mov ah, 0xb ; escolhe a cor da tela
	mov bh, 0
	mov bl, 0   ;COR
	int 10h     ;VIDEO

	;Game Over
	mov ah, 02h  ;move o cursor para o lugar certo
	mov bh, 0    ;Pagina 0
	mov dh, 3    ;Linha
	mov dl, 14   ;Coluna
	int 10h
	mov bl, 4
	mov si, game_over_string
	call print_string

	;Your Score
	mov ah, 02h
	mov bh, 0
	mov dh, 5 
	mov dl, 17
	int 10h
	mov bl, 15
	mov si, score_show
	call print_string_delay

	;Numero Score
	mov ah, 02h  ;move o cursor para o lugar certo
	mov bh, 0    ;Pagina 0
	mov dh, 5    ;Linha
	mov dl, 23   ;Coluna
	int 10h
	mov bl, 15
	mov si, score_num
	call print_string_delay

	;Jogar de Novo
	mov ah, 02h  ;move o cursor para o lugar certo
	mov bh, 0    ;Pagina 0
	mov dh, 9    ;Linha
	mov dl, 12   ;Coluna
	int 10h
	mov bl, 15
	mov si, jogar_denovo
	call print_string_delay

	;Voltar ao Menu:
	mov ah, 02h  ;move o cursor para o lugar certo
	mov bh, 0    ;Pagina 0
	mov dh, 15   ;Linha
	mov dl, 12   ;Coluna
	int 10h
	mov bl, 15
	mov si, ir_menu
	call print_string_delay

	.teclado_wait:

		mov ah, 1h
		int 16h
		jnz .press ;se foi, ver qual a tecla
		jmp .teclado_wait

	.press:
	
		mov ah, 00h
		int 16h

		;caso seja 1 (voltar a jogar):
		cmp al, 49
		je loop_game

		;caso seja 2(voltar ao menu):
		cmp al, 50
		je Menu

		jmp .teclado_wait


carregar_linha1:
	mov si, obst_linha1
	lodsw
ret

salvar_linha1:
	mov di, obst_linha1
	stosw
ret

carregar_linha2:
	mov si, obst_linha2
	lodsw
	
	ret
	
salvar_linha2:
	mov di, obst_linha2
	stosw
	
	ret

carregar_score_player:
	;carrega score em ax
	mov si, score_player
	lodsw
	ret

salvar_score_player:
	;salva score em score_player
	mov di, score_player
	stosw
	ret

carregar_posicao_obstaculo1:
	;carrega a nova posicao em cx, dx
	mov si, obstaculo1_pos
	lodsw
	mov dx, ax
	lodsw
	mov cx, ax

	ret

salvar_posicao_obstaculo1:
	;salva a nova posicao em obstaculo1_pos
	mov di, obstaculo1_pos
	mov ax, dx
	stosw
	mov ax, cx
	stosw

	ret
	
carregar_posicao_obstaculo2:
	;carrega a nova posicao em cx, dx
	mov si, obstaculo2_pos
	lodsw
	mov dx, ax
	lodsw
	mov cx, ax
	
	ret
	
salvar_posicao_obstaculo2:
	;salva a nova posicao em obstaculo2_pos
	mov di, obstaculo2_pos
	mov ax, dx
	stosw
	mov ax, cx
	stosw
	
	ret
	
carregar_posicao_carro:
	;carrega a nova posicao em cx, dx
	mov si, carro_pos
	lodsw
	mov dx, ax
	lodsw
	mov cx, ax

	ret

salvar_posicao_carro:
	;salva a nova posicao em obstaculo1_pos
	mov di, carro_pos
	mov ax, dx
	stosw
	mov ax, cx
	stosw

	ret

print_obstaculo1: ;essa funcao printa o obstaculo1 em cx, dx (sem apagar posicao antiga)
	
	;desenhando nova posicao
	mov si, cone
	call _print_sprite						

	ret 


print_obstaculo2: ;essa funcao printa o obstaculo2 em cx, dx (sem apagar posicao antiga)
	
	;desenhando nova posicao
	mov si, carro_azul
	call _print_sprite
	
	ret
	
apagar_obstaculo1:
	
	mov si, nullc
	call _print_sprite
	
	ret
	
apagar_obstaculo2:

	mov si, null
	call _print_sprite
	
	ret
	
print_carro: ;essa funcao printa o carro em cx, dx (ainda falta apagar da posicao antiga)

	;desenhando a nova posicao
	mov si, carro_verm
	call _print_sprite

	ret

print_score_frase: ;printa a frase score no canto superior direito
	
	mov ah, 02h  ;move o cursor para o lugar certo
	mov bh, 0    ;Pagina 0
	mov dh, 1   ;Linha
	mov dl, 30  ;Coluna
	int 10h
	mov bl, 15
	mov si, score_show
	call print_string

	ret

print_score_numero: ;printa o numero score no canto superior direito
	
	;transformando o numero da score em string
	call carregar_score_player
	mov bl, 20
	div bl
	mov ah, 0
	mov di, score_num
	call tostring 

	mov ah, 02h  ;move o cursor para o lugar certo
	mov bh, 0    ;Pagina 0
	mov dh, 1   ;Linha
	mov dl, 36   ;Coluna
	int 10h
	mov bl, 15
	mov si, score_num
	call print_string

	ret

;funcoes auxiliares:
;----------------------------------------------------------------
print_string_delay:
	lodsb
	cmp al,0
	je end

	mov ah, 0eh
	;mov bl, 14
	int 10h

	mov dx, 0
	.delay_print:
	inc dx
	mov cx, 0
		.time:
			inc cx
			cmp cx, 40000
			jne .time

	cmp dx, 1000
	jne .delay_print

	jmp print_string_delay

	end:
		mov ah, 0eh
		mov al, 0xd
		int 10h
		mov al, 0xa
		int 10h
		ret


_print_sprite:                   ; imprime um sprite (guardado em SI) na posição coluna=cx, linha= dx

	push dx
	push cx
	

	.loop:
		lodsb   
		cmp al,'0'
		je .fim

		cmp al,'.'	
		je .next_line

		.next_pixel:
			call _print_pixel
			inc cx
			jmp .loop	
		
		.next_line:	
			
			pop cx      		 ;reseta cx para o valor inicial, o começo de uma nova linha
			push cx

			inc dx
			lodsb
			jmp .next_pixel
		
		.fim:
			pop cx
			pop dx	
			ret 


_print_pixel:      	  			; printa um pixel na posição coluna = dx , linha = dx
        mov ah, 0ch
        mov bh, 0
        int 10h
        ret

print_string:
	lodsb
	cmp al, 0
	je .done

	mov ah, 0eh ; codigo para imprimir caractere em al
	int 10h ; interrupcao de video

	jmp print_string
	.done:
ret

;coverte um inteiro em ax para um string em di
tostring:
	push di

	.loop1:
		cmp ax, 0
		je .endloop1
		xor dx, dx
		mov bx, 10
		div bx
		xchg ax, dx
		add ax, 48
		stosb
		xchg ax, dx
		jmp .loop1

	.endloop1:
		pop si
		cmp si, di
		jne .done
		mov al, 48
		stosb
	
	.done:
	mov al, 0
	stosb
	call reverse
	ret

reverse:
	mov di, si
	xor cx, cx

	.loop1:
		lodsb
		cmp al, 0
		je .endloop1
		inc cl
		push ax
		jmp .loop1

	.endloop1:

	.loop2:
		cmp cl, 0
		je .endloop2
		dec cl
		pop ax
		stosb
		jmp .loop2

	.endloop2:
		ret

print_vida_frase: ;printa a frase vida no canto superior esquerdo
	
	mov ah, 02h  ;move o cursor para o lugar certo
	mov bh, 0    ;Pagina 0
	mov dh, 1   ;Linha
	mov dl, 2  ;Coluna
	int 10h
	mov bl, 15
	mov si, vida_show
	call print_string

	ret

print_barra_vida:
	
	call carregar_vida
	cmp ax, 3
	je .barra_vida_3

	cmp ax, 2
	je .barra_vida_2

	cmp ax, 1
	je .barra_vida_1

	ret

	.barra_vida_1:
		
		;apagando terceiro coracao
		mov cx, 110
		mov dx, 5
		mov si, nullcoracao
		call _print_sprite

		;apagando segundo coracao
		mov cx, 85
		mov dx, 5
		mov si, nullcoracao
		call _print_sprite
		
		;desenhando primeiro coracao
		mov cx, 60
		mov dx, 5
		mov si, coracao
		call _print_sprite

		ret

	.barra_vida_2:
		
		;apagando terceiro coracao
		mov cx, 110
		mov dx, 5
		mov si, nullcoracao
		call _print_sprite

		;desenhando primeiro coracao
		mov cx, 60
		mov dx, 5
		mov si, coracao
		call _print_sprite

		;desenhando segundo coracao
		mov cx, 85
		mov dx, 5
		mov si, coracao
		call _print_sprite
		
		ret 
		
	.barra_vida_3:

		;desenhando primeiro coracao
		mov cx, 60
		mov dx, 5
		mov si, coracao
		call _print_sprite

		;desenhando segundo coracao
		mov cx, 85
		mov dx, 5
		mov si, coracao
		call _print_sprite

		;desenhando terceiro coracao
		mov cx, 110
		mov dx, 5
		mov si, coracao
		call _print_sprite

		ret


tela_venceu:

	;colocando a tela toda preta:
	mov ax, 13h; VGA mode 13h 320x200
    int 10h
  	mov ah, 0xb ; escolhe a cor da tela
	mov bh, 0
	mov bl, 0   ;COR
	int 10h     ;VIDEO

	;Voce venceu
	mov ah, 02h  ;move o cursor para o lugar certo
	mov bh, 0    ;Pagina 0
	mov dh, 3    ;Linha
	mov dl, 5   ;Coluna
	int 10h
	mov bl, 14
	mov si, voce_venceu_string
	call print_string

	;Jogar de Novo
	mov ah, 02h  ;move o cursor para o lugar certo
	mov bh, 0    ;Pagina 0
	mov dh, 9    ;Linha
	mov dl, 12   ;Coluna
	int 10h
	mov bl, 15
	mov si, jogar_denovo
	call print_string_delay

	;Voltar ao Menu:
	mov ah, 02h  ;move o cursor para o lugar certo
	mov bh, 0    ;Pagina 0
	mov dh, 15   ;Linha
	mov dl, 12   ;Coluna
	int 10h
	mov bl, 15
	mov si, ir_menu
	call print_string_delay

	.teclado_wait:

		mov ah, 1h
		int 16h
		jnz .press ;se foi, ver qual a tecla
		jmp .teclado_wait

	.press:
	
		mov ah, 00h
		int 16h

		;caso seja 1 (voltar a jogar):
		cmp al, 49
		je loop_game

		;caso seja 2(voltar ao menu):
		cmp al, 50
		je Menu

		jmp .teclado_wait


;Colisao

salvar_vida:
	mov di, vida
	mov ax, life
	stosw
	ret

carregar_vida: 
	mov si, vida
	lodsw
	ret
	
salvar_velocidade:
	mov di, velocidade_atual
	stosw
	ret
	
carregar_velocidade:
	mov si, velocidade_atual
	lodsw
	ret

;COLISAO OBSTACULO 1
checkCollision1:
	call carregar_posicao_carro
	mov bx ,cx
	add bx, 30
	call carregar_posicao_obstaculo1
	cmp cx, bx
	jl CXisequal1
	
	ret

CXisequal1:
	call carregar_posicao_carro
	mov bx, dx
	sub bx ,5
	call carregar_posicao_obstaculo1
	cmp dx, bx
	je colidiu1
	
	ret 

colidiu1:
	call loop_game.reseta_obstaculo1
	mov si, vida
	lodsw
	dec ax
	mov di, vida
	stosw
	
	cmp ax, 0
	je game_over
	
	ret
	
;COLISAO OBSTACULO 2
checkCollision2:
	call carregar_posicao_carro
	mov bx ,cx
	add bx, 30
	call carregar_posicao_obstaculo2
	cmp cx, bx
	jl CXisequal2
	
	ret

CXisequal2:
	call carregar_posicao_carro
	mov bx, dx
	sub bx ,5
	call carregar_posicao_obstaculo2
	cmp dx, bx
	je colidiu2
	
	ret 

colidiu2:
	call loop_game.reseta_obstaculo2
	mov si, vida
	lodsw
	dec ax
	mov di, vida
	stosw
	
	cmp ax, 0
	je game_over
	
	ret
