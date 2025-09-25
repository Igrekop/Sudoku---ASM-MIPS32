# ===== Section donnees =====  
.data

    file: .asciiz "grille.txt"
    grille: .space 81 
    #grille: .asciiz "123456789456789123789123456214365897365897214897214365531642978642978531978531642"
    espace_col: .asciiz "|"
    espace_row: .asciiz "____________"
    z_t_s: .asciiz " "
    erreur_message: .asciiz "Erreur : doublon trouvé dans la ligne.\n"
    no_error_message: .asciiz "Aucune erreur : la ligne est valide.\n"

# ===== Section code =====  
.text
###########################################################
# main :
#   1) Charger et initialiser la grille
#   2) Afficher la grille initiale
#   3) Vérifier la grille (check_sudoku)
#   4) Résoudre (solve_sudoku)
#   5) Afficher un message si pas de solution
###########################################################
main:
    # 1) Charger la grille en mémoire
    la    $a0, file
    jal   loadFile
    move  $t0, $v0

    move  $a0, $t0
    jal   parseValues

    move  $a0, $t0
    jal   closeFile

    # Convertir ASCII->entiers
    jal   transformAsciiValues

    # 2) Afficher la grille brute
    jal   zeroToSpace
    jal   displaySudoku
    jal   addNewLine
    jal   addNewLine
    
        # 1) Recharge la grille en mémoire car avec zero to space cela modifie les 0 en 32
    la    $a0, file
    jal   loadFile
    move  $t0, $v0

    move  $a0, $t0
    jal   parseValues

    move  $a0, $t0
    jal   closeFile

    # Convertir ASCII->entiers
    jal   transformAsciiValues

    # 3) Vérifier la grille
    jal   check_sudoku   # => v0 = 1 ou 0
    beq   $v0, $zero, no_solution_possible
    # si déjà invalide => on ne va même pas chercher à résoudre

    # 4) Résolution
    jal   solve_sudoku   # => v0 = 1 si on a trouvé au moins une solution

    # Sinon => on est passé par displaySudoku si on a trouvé une solution
    j end_main

no_solution_possible:
    # Affiche un message "Aucune solution possible"
    li  $v0, 4
    la  $a0, erreur_message
    syscall
    j end_main

end_main:
    # Quitte le programme
    jal  exit



# ----- Fonctions ----- 
#loadfile
# ouvrir un fichier passé en argument : appel systeme 13 
#	$a0 nom du fichier
#	$a1 (= 0 lecture, = 1 ecriture)
# Registres utilises : $v0, $a1
loadFile:
	li $v0, 13
	li $a1, 0
	syscall
	jr $ra
	
#parseValues
#lire un fichier passé en argument : appel système 14
#$a0 descripteur du fichier ouvert
#Registres utilisés : $a1, $a2, $v0	
parseValues:
	la $a1, grille #charge l'adresse de là ou va être stocké la grille
	li $a2, 81 #lecture 81 caratères
	li $v0, 14 #appel système 14 : lire
	syscall
	jr $ra

#closeFile
# Fermer le fichier : appel systeme 16
# $a0 descripteur de fichier  ouvert
# Registres utilises : $v0
closeFile:
	li $v0, 16
	syscall
	jr  $ra

# ----- Fonction addNewLine -----  
# objectif : fait un retour a la ligne a l'ecran
# Registres utilises : $v0, $a0
addNewLine:
    li      $v0, 11
    li      $a0, 10
    syscall
    jr $ra



# ----- Fonction displayGrille -----   
# Affiche la grille.
# Registres utilises : $v0, $a0, $t[0-2]
displayGrille:  
    la      $t0, grille
    add     $sp, $sp, -4        # Sauvegarde de la reference du dernier jump
    sw      $ra, 0($sp)
    li      $t1, 0
    boucle_displayGrille:
        bge     $t1, 81, end_displayGrille     # Si $t1 est plus grand ou egal a 81 alors branchement a end_displayGrille
            add     $t2, $t0, $t1           # $t0 + $t1 -> $t2 ($t0 l'adresse du tableau et $t1 la position dans le tableau)
            lb      $a0, ($t2)              # load byte at $t2(adress) in $a0
            li      $v0, 1                  # code pour l'affichage d'un entier
            syscall
            add     $t1, $t1, 1             # $t1 += 1;
        j boucle_displayGrille
    end_displayGrille:
        lw      $ra, 0($sp)                 # On recharge la reference 
        add     $sp, $sp, 4                 # du dernier jump
    jr $ra


# ----- Fonction transformAsciiValues -----   
# Objectif : transforme la grille de ascii a integer
# Registres utilises : $t[0-3]
transformAsciiValues:  
    add     $sp, $sp, -4
    sw      $ra, 0($sp)
    la      $t3, grille
    li      $t0, 0
    boucle_transformAsciiValues:
        bge     $t0, 81, end_transformAsciiValues
            add     $t1, $t3, $t0
            lb      $t2, ($t1)
            sub     $t2, $t2, 48
            sb      $t2, ($t1)
            add     $t0, $t0, 1
        j boucle_transformAsciiValues
    end_transformAsciiValues:
    lw      $ra, 0($sp)
    add     $sp, $sp, 4
    jr $ra


# ----- Fonction getModulo ----- 
# Objectif : Fait le modulo (a mod b)
#   $a0 represente le nombre a (doit etre positif)
#   $a1 represente le nombre b (doit etre positif)
# Resultat dans : $v0
# Registres utilises : $a0
getModulo: 
    sub     $sp, $sp, 4
    sw      $ra, 0($sp)
    boucle_getModulo:
        blt     $a0, $a1, end_getModulo
            sub     $a0, $a0, $a1
        j boucle_getModulo
    end_getModulo:
    move    $v0, $a0
    lw      $ra, 0($sp)
    add     $sp, $sp, 4
    jr $ra


#################################################
#               A completer !                   #
#                                               #
# Nom et prenom binome 1 :                      #
# Nom et prenom binome 2 :                      #
#                                               #
# Fonction check_n_col                          #
# Objectif : Vérifie la validité de la n-ième ligne du Sudoku.
#registres utilisés $t[0-7], $v0
#résultat dans $v0
check_n_col:
    	# Arguments : n est passé dans $s0
    	# $t0 = adresse de la grille (grille commence à l'adresse de la mémoire)
    	la $t0, grille                # Charger l'adresse de la grille (tableau 9x9)
    	add $sp, $sp, -4              # Sauvegarde de la référence du dernier jump
    	sw  $ra, 0($sp)

    	# Calculer l'adresse de la colonne n
    	mul $t1, $s0, 1               # $t1 = n (index de la colonne)
    	add $t1, $t0, $t1             # $t1 = adresse de la première cellule de la colonne n (grille + n)

    	li $t2, 0                     # Index1 (pour la première boucle de vérification)
    	li $t3, 0                     # Index2 (pour la deuxième boucle de vérification)
    	li $t7, 0                     # Compteur de doublons (0 initialement)

	boucle_verification_1_c:
    		bge $t2, 9, end_check        # Si index1 >= 9, fin de la vérification (pas de doublon)

    		bge $t7, 1, end_check        # Si doublon trouvé, sortir de la boucle

    		# Charger la valeur de grille[t2][n] dans $t5 (élément de la colonne)
    		mul $t4, $t2, 9              # Décalage pour la ligne t2
    		add $t5, $t1, $t4            # $t5 = adresse de grille[t2][n]
    		lb $t5, 0($t5)               # Charger la valeur dans $t5

   		 li $t3, 0                     # Réinitialisation de l'index2

	boucle_verification_2_c:
    		bge $t3, 9, boucle_verification_1_bis_c  # Si index2 >= 9, revenir à la vérification de la ligne suivante

    		bge $t7, 1, end_check_c      # Si doublon trouvé, sortir

   		beq $t2, $t3, next_index2_c  # Si t2 == t3, ne pas se comparer à soi-même

    		# Charger la valeur de grille[t3][n] dans $t6 (élément de la colonne)
    		mul $t4, $t3, 9              # Décalage pour la ligne t3
    		add $t6, $t1, $t4            # $t6 = adresse de grille[t3][n]
    		lb $t6, 0($t6)               # Charger la valeur dans $t6
		
		beq $t5, $zero, skip_compare_col
		beq $t6, $zero, skip_compare_col
    		beq $t5, $t6, cas_faux_c      # Si grille[t2][n] == grille[t3][n], il y a un doublon

    		addi $t3, $t3, 1             # Incrémenter index2
    		j boucle_verification_2_c     # Revenir à la boucle interne

	boucle_verification_1_bis_c:
    		addi $t2, $t2, 1             # Incrémenter index1
    		j boucle_verification_1_c    # Revenir à la première boucle

	next_index2_c:
    		addi $t3, $t3, 1             # Incrémenter index2
    		j boucle_verification_2_c    # Revenir à la deuxième boucle

	cas_faux_c:
    		# Cas où il y a un doublon (grille[t2][n] == grille[t3][n])
    		addi $t7, $t7, 1             # Incrémenter le compteur de doublons
    		j end_check_c                # Fin de la vérification

	end_check_c:
    		# Afficher un message en fonction de la valeur de $t7 (compteur d'erreurs)
    		beqz $t7, no_error_c         # Si $t7 == 0, pas d'erreur, afficher "Aucune erreur"

    		# Message d'erreur
    		li $v0, 0
    		lw      $ra, 0($sp)
    		add     $sp, $sp, 4
    		jr $ra                       # Terminer la fonction

	no_error_c:
   		 # Message de succès (pas d'erreur)
   		li $v0, 1
    		lw      $ra, 0($sp)
    		add     $sp, $sp, 4
    		jr $ra                       # Terminer la fonction
    		
    	skip_compare_col:
    		addi $t3, $t3, 1
    		j boucle_verification_2_c

 
#                                               #
#                                               #
#                                               #
# Fonction check_n_row                          #
# Objectif : Vérifie la validité de la n-ième colonne du Sudoku.
#registres utilisés $t[0-7], $v0
#résultat dans $v0
check_n_row:
    	# Arguments : n est passé dans $s0b
    	# $t0 = adresse de la grille (grille commence à l'adresse de la mémoire)
    	la $t0, grille                # Charger l'adresse de la grille (tableau 9x9)
    	add     $sp, $sp, -4        # Sauvegarde de la reference du dernier jump
    	sw      $ra, 0($sp)

    	# Calculer l'adresse de la ligne n (lignes de 9 éléments)
    	mul $t1, $s0, 9               # $t1 = n * 9 (9 éléments par ligne)
    	add $t1, $t0, $t1             # $t1 = adresse de la ligne n (grille + n*9)

    	li $t2, 0                     # Index1 (pour la première boucle de vérification)
    	li $t3, 0                      # Index2 (pour la deuxième boucle de vérification)
    	li $t4, 9                     # Compteur de la ligne (9 éléments)
    	li $t7, 0                     # Compteur de doublons

	boucle_verification_1:
    		bge $t2, $t4, end_check       # Si index1 >= 8, fin de la vérification (pas de doublon)

    		bge $t7, 1, end_check         # Si doublon trouvé (t7 > 0), sortir

    		# Charger la valeur de grille[n][t2] dans $t5
    		add $t5, $t1, $t2             # $t5 = adresse de grille[n][t2]
    		lb $t5, 0($t5)                # Charger la valeur dans $t5

    		li $t3, 1                     # Réinitialisation de l'index2

	boucle_verification_2:
   		bge $t3, $t4, boucle_verification_1_bis # Si index2 >= 8, passer à la vérification suivante

    		bge $t7, 1, end_check         # Si doublon trouvé, sortir
    		beq $t2, $t3, next_index2     # Si t2 == t3, passer à la prochaine itération (on ne se compare pas à soi-même)

    		# Charger la valeur de grille[n][t3] dans $t6
    		add $t6, $t1, $t3             # $t6 = adresse de grille[n][t3]
    		lb $t6, 0($t6)                # Charger la valeur dans $t6
		
		beq $t5, $zero, skip_compare
		beq $t6, $zero, skip_compare
		
    		beq $t5, $t6, cas_faux        # Si grille[n][t2] == grille[n][t3], il y a un doublon

    		addi $t3, $t3, 1              # Incrémenter index2
    		j boucle_verification_2        # Revenir à la boucle interne

	boucle_verification_1_bis:
    		addi $t2, $t2, 1              # Incrémenter index1
    		j boucle_verification_1       # Revenir à la première boucle
    		
    	next_index2:
            addi $t3, $t3, 1              # Incrémenter index2
            j boucle_verification_2       # Revenir à la deuxième boucle
    	

	cas_faux:
    		# Cas où il y a un doublon (grille[n][t2] == grille[n][t3])
    		addi $t7, $t7, 1              # Incrémenter le compteur de doublons
    		j end_check                   # Fin de la vérification

	end_check:
    		# Afficher un message en fonction de la valeur de $t7 (compteur d'erreurs)
    		beqz $t7, no_error             # Si $t7 == 0, pas d'erreur, afficher "Aucune erreur"
    
    		# Message d'erreur
    		li $v0, 0
    		lw      $ra, 0($sp)
    		add     $sp, $sp, 4
    		jr $ra                        # Terminer la fonction

	no_error:
    		# Message de succès (pas d'erreur)
    		li $v0, 1
    		lw      $ra, 0($sp)
    		add     $sp, $sp, 4
    		jr $ra                        # Terminer la fonction
    	
    	skip_compare:
    		addi $t3, $t3, 1              # On incrémente index2
    		j boucle_verification_2       # Retour au début de la boucle


#                                               #
#                                               #
#                                               #
# Fonction check_n_square
# Objectif :
#   Vérifie qu'il n'y a pas de doublon dans la n-ième case 3x3 du Sudoku
#   (n est passé dans $s0, 0 <= n <= 8).
#   Ignorer si l'une des deux cases vaut 0 (case vide).
#
# Retour :
#   $v0 = 1 si pas de doublon
#   $v0 = 0 si au moins un doublon détecté
#registre utilisés : $t[0-7],  $t9, $a[0-1], $s[0-5]
check_n_square:
    addi    $sp, $sp, -4         # Réserve 4 octets sur la pile 
    sw      $ra, 0($sp)          # Sauvegarde l'adresse de retour ($ra)
    la      $t0, grille          # $t0 pointe sur le début de la grille (9x9)

    move    $a0, $s0             # Prépare $a0 pour getModulo, où n = $s0
    li      $a1, 3               # Diviseur = 3
    jal     getModulo            # => v0 = (n % 3)

    mul     $t4, $v0, 3          #  (n % 3)*3 => stocké dans $t4

    div     $s0, $a1             # div n, 3 => quotient dans LO
    mflo    $t3                  # t3 = floor(n/3)
    mul     $t3, $t3, 3          # = floor(n/3)*3 => stocké dans $t3

    # t7 => compteur de doublons
    li      $t7, 0
    li      $t1, 0              

boucle_i:
    bge     $t1, 9, end_check_square  
    # On sort si i >= 9

    # Calcul de row_i, col_i
    move    $s1, $t1      # on sauvegarde i avant 'div'
    li      $a1, 3

    # = t1 % 3
    move    $a0, $s1
    jal     getModulo
    move    $s2, $v0

    # = floor(t1 / 3)
    div     $s1, $a1
    mflo    $s3

    # = rowStart + s3
    add     $s3, $t3, $s3
    # = colStart + s2
    add     $s2, $t4, $s2

    # Charger la valeur grille[row_i][col_i] => t5
    mul     $t6, $s3, 9
    add     $t6, $t6, $s2
    add     $t6, $t6, $t0
    lb      $t5, 0($t6)

    # Comparer cette case aux suivantes j = i+1..8
    addi    $t2, $t1, 1

boucle_j:
    bge     $t2, 9, next_i          # si j >= 9 => plus rien à comparer
    bge     $t7, 1, end_check_square 
    # si doublon trouvé, on sort

    # Calcul row_j, col_j
    move    $s1, $t2
    li      $a1, 3

    # j % 3
    move    $a0, $s1
    jal     getModulo
    move    $s4, $v0

    # j / 3
    div     $s1, $a1
    mflo    $s5

    # row_j =  + (j / 3)
    add     $s5, $t3, $s5
    # col_j =  + (j % 3)
    add     $s4, $t4, $s4

    # Charger la valeur grille[row_j][col_j] => t9
    mul     $t9, $s5, 9
    add     $t9, $t9, $s4
    add     $t9, $t9, $t0
    lb      $t9, 0($t9)

    # Ignorer si l'une des deux cases vaut 0
    # => si $t5 == 0 ou $t9 == 0, on saute la comparaison
    beq     $t5, $zero, skip_compare_square
    beq     $t9, $zero, skip_compare_square

    # Comparer la case i (t5) et la case j (t9)
    beq     $t5, $t9, doublon

skip_compare_square:
    addi    $t2, $t2, 1  # j++
    j       boucle_j

next_i:
    addi    $t1, $t1, 1  # i++
    j       boucle_i

# doublon : on a trouvé un doublon (t5 == t9)
doublon:
    addi    $t7, $t7, 1
    j       end_check_square

end_check_square:
    beqz    $t7, no_error_sq
    # si t7 == 0 => pas de doublon

    # doublon -> v0 = 0
    li      $v0, 0
    lw      $ra, 0($sp)
    addi    $sp, $sp, 4
    jr      $ra

no_error_sq:
    # pas de doublon -> v0 = 1
    li      $v0, 1
    lw      $ra, 0($sp)
    addi    $sp, $sp, 4
    jr      $ra





#                                               #
#                                               #
#                                               #
# Fonction check_columns                        #
# ----- Fonction check_columns -----   
# Objectif : Check chaque colonne de la grille pour voir si elles sont valides
# Registres utilises : $s0
check_columns:
	add     $sp, $sp, -4        # Sauvegarde de la reference du dernier jump
    	sw      $ra, 0($sp)
	li $s0, 0	#$s0 -> indice de la colonne a vérifier
	
	boucle_check_columns:
	
		bge $s0, 8, end_check_columns	#Si $s0 est supérieur à 9 on s'arrête
		jal check_n_col	#sinon on vérifie la colonne $s0
		addi $s0, $s0, 1	#on incrémente l'indice
		beq $v0, $zero, erreur_col #si le résultat de check_n_col est 0, il y a erreur, on sort
		j boucle_check_columns
		
	erreur_col:
		j end_check_columns 
		
	end_check_columns:
		lw	$ra, 0($sp)
		add	$sp, $sp, 4
		jr 	$ra
#                                               #
#                                               #
#                                               #
# Fonction check_rows                           #
# Objectif : Check toutes les lignes de la grille pour vérifier qu'elles sont valides
# Registres utilises : $t[0-3]
check_rows:
	add     $sp, $sp, -4        # Sauvegarde de la reference du dernier jump
    	sw      $ra, 0($sp)
	li $s0, 0		#$s0 -> indice de la ligne à vérifier
	
	boucle_check_rows:
	
		bge $s0, 9, end_check_rows	#si $s0 >= 9, on s'arrête
		jal check_n_row		#on vérifie la n-ieme ligne
		addi $s0, $s0, 1	#on incrémente l'indice
		beq $v0, $zero, erreur_row #si $v0 = 0, il y a une erreur, on sort
		j boucle_check_rows
	
	erreur_row:
		j end_check_rows
	
	end_check_rows:
		lw	$ra, 0($sp)
		add	$sp, $sp, 4
		jr 	$ra
#                                               #
#                                               #
#                                               #
#Fonction check_square				#

# Fonction check_square
# Objectif : Vérifie les 9 sous-grilles 3x3 du Sudoku,
#            en appelant la fonction check_n_square pour
#            chacune d'entre elles
#registres utilisés $s0
check_square:
    addi    $sp, $sp, -4          # Réserve 4 octets sur la pile
    sw      $ra, 0($sp)           # Sauvegarde l'adresse de retour ($ra)

    li      $s0, 0                # Initialise $s0 à 0 
                                  # (nous parcourons les sous-grilles de n=0 à n=8)

boucle_all_squares:
    bgt     $s0, 8, end_all_squares 
    # Si $s0 > 8, nous avons vérifié toutes les 9 sous-grilles (0..8),
    # on sort de la boucle.

    jal     check_n_square        # Appel de la fonction check_n_square(n=$s0)
    addi    $s0, $s0, 1           # Incrémente n (on passe à la sous-grille suivante)
    beq	    $v0, $zero, erreur_square
    j       boucle_all_squares    # Retour au début de la boucle

erreur_square :
    j end_all_squares
    
end_all_squares:
    lw      $ra, 0($sp)           # Restaure l'adresse de retour
    addi    $sp, $sp, 4           # Libère l'espace occupé sur la pile
    jr      $ra                   # Retour à l'appelant




#                                               #
#                                               #
#                                               #
# Fonction check_sudoku                         #
# Vérifier si toute la grille est valide
# Registres utilises : $v0, $zero
check_sudoku:
	addi $sp, $sp, -4 #réserve 4 octects sur la pile
	sw $ra, 0($sp) #save de l'addresse de retour
	
	#Vérification des lignes
	jal check_rows #fonction vérifiant toutes les lignes
	beq $v0, $zero, sudoku_error #si check_n_rows renvoie 0, il y a une erreur donc on arrête de check
	
	#Vérification des colonnes
	jal check_columns #Fonction qui vérifie les colonnes
	beq $v0, $zero, sudoku_error #si check_n_columns renvoie 0, on a une erreur, on sort
	
	#Vérification des carrés 3x3
	jal check_square #fonction qui vérifie les carrés
	beq $v0, $zero, sudoku_error #si il y a une erreur dans un carré on arrête la fonction
	
	#aucune erreur détecté
	li $v0, 1 #sudoku valide
	j sudoku_end
	
	sudoku_error:
		li $v0, 0 #sudoku invalide
		j sudoku_end
	
	sudoku_end:
		lw $ra, 0($sp)
		addi $sp, $sp 4 #on libère l'espace de la pile
		jr $ra
	
#                                               #
#                                               #
#                                               #
# Fonction solve_sudoku                         #
# Objectif : Trouver toutes les solutions.
#  - On dispose d'une fonction find_empty_cell(
#    qui renvoie (ligne, colonne) dans deux registres
#    ou (-1, -1) si pas de case vide.
#  - check_sudoku($v0=1 ou 0) pour savoir si la grille est valide
# displaySudoku pour affichage
#  - On renvoie 1 dans $v0 si on a trouvé au moins une solution,
#    0 sinon.
#registre utilisés : $t[0-4], $s[0-2], $a[0-1]

solve_sudoku:
    addi  $sp, $sp, -4
    sw    $ra, 0($sp)

    # 1) find_empty_cell
    jal   find_empty_cell
    # => s1, s2, ou -1, -1

    li    $t0, -1
    bne   $s1, $t0, check_s2
    bne   $s2, $t0, check_s2

    # plus de cases vides => afficher la grille
    jal   displaySudoku
    li    $v0, 1
    j     end_solve

check_s2:
    li    $t1, 1

loop_try_digit:
    ble   $t1, 9, try_digit
    li    $v0, 0
    j     end_solve

try_digit:
    # place digit dans la grille
    mul   $t2, $s1, 9
    add   $t2, $t2, $s2
    la    $t3, grille
    add   $t2, $t2, $t3
    sb    $t1, 0($t2)

    # => Sauvegarder t0..t3, s1, s2 (pas $ra) pour check_sudoku
    addi  $sp, $sp, -24
    sw    $t0,  0($sp)
    sw    $t1,  4($sp)
    sw    $t2,  8($sp)
    sw    $t3, 12($sp)
    sw    $s1, 16($sp)
    sw    $s2, 20($sp)

    jal   check_sudoku   # $v0=1 si OK, 0 si erreur

    lw    $t0,  0($sp)
    lw    $t1,  4($sp)
    lw    $t2,  8($sp)
    lw    $t3, 12($sp) #on load ici, on a save, car il y avait une perte des donnés après l'appel de check_sudoku...
    lw    $s1, 16($sp) #ce n'est pas la manière orthofdoxe, mais c'est celle qui marche pour nous
    lw    $s2, 20($sp)
    addi  $sp, $sp, 24

    beq   $v0, $zero, revert_value #si check_sudoku n'est pas bon, on remet 0

    # si sudoku OK => appel récursif solve_sudoku
    jal   solve_sudoku   # $v0 = 1 => solution, 0 => pas solution

    # Rétro-propagation
revert_value:
    li   $t4, 0
    sb   $t4, 0($t2)
    addi $t1, $t1, 1
    j    loop_try_digit

end_solve:
    lw   $ra, 0($sp)       
    addi $sp, $sp, 4
    jr   $ra     

#                                               #
#                                               #
# Autres fonctions que nous avons ajoute :      #

# find_empty_cell
# Parcours la grille
# Renvoie:
#   s1 = ligne, s2 = colonne
#   si aucune case vide => s1 = -1, s2 = -1
#   "Case vide" => case = 0
#registre utilisés : $t[0-3], $s[1-2], $a1, $a0
find_empty_cell:
    addi  $sp, $sp, -4
    sw    $ra, 0($sp)

    la    $t0, grille  # début de la grille
    li    $t1, 0       # i = 0
loop_find:
    bge   $t1, 81, no_cell  # si t1 >= 81 => pas trouvé
    add   $t2, $t0, $t1
    lb    $t3, 0($t2)       # t3 = grille[t1] => (valeur)
    beq   $t3, $zero, found # si grille[t1] == 0 => c'est vide => trouvé
    addi  $t1, $t1, 1
    j     loop_find

no_cell:
    # pas de case vide
    li  $s1, -1
    li  $s2, -1
    j   end_find

found:
    # on a trouvé la case vide => t1
    # Convertir t1 => ligne, colonne
    # ligne = t1 / 9
    # col   = t1 % 9
    li   $a1, 9
    move $a0, $t1
    jal  getModulo
    move $s2, $v0  # s2 = t1%9

    div  $t1, $a1
    mflo $s1       # s1 = t1 / 9

end_find:
    lw   $ra, 0($sp)
    addi $sp, $sp, 4
    jr   $ra


#                                               #
# Fonction ???                                  #  


# Fonction displaySudoku   			#
# Affiche le sudoku de façon matricielle.
# Registres utilises : $v0, $a0, $t[0-5]
displaySudoku:
	la      $t0, grille
    	add     $sp, $sp, -4        # Sauvegarde de la reference du dernier jump
    	sw      $ra, 0($sp)
    	li      $t1, 0
    	li	$t3, 0
    	li	$t4, 0
    	li	$t5, 0
    	boucle_displaySudoku:
        	bge     $t1, 81, end_displaySudoku     # Si $t1 est plus grand ou egal a 81 alors branchement a end_displayGrille
        	bge	$t3, 9, if_sup_a_9	#Si $t3 est plus grand ou egal à 9 alors branchement a if_sup_a_9
        	bge	$t5, 27, make_espace_row #si $t5 est >= à 27 alors branchement à make_espace_row
        	bge	$t4, 3, make_espace_col #Si $t4 est >= à 3 alors branchement à make_espace_col
            	add     $t2, $t0, $t1           # $t0 + $t1 -> $t2 ($t0 l'adresse du tableau et $t1 la position dans le tableau)
            	lb      $a0, ($t2)              # load byte at $t2(adress) in $a0
            	bge	$a0, 32, espace_0
            	li      $v0, 1                  # code pour l'affichage d'un entier
            	syscall
            	add     $t1, $t1, 1             # $t1 += 1;
            	add	$t3, $t3, 1		# $t3 += 1;
            	add	$t4, $t4, 1		# $t4 += 1;
            	add	$t5, $t5, 1		# $t5 += 1;
        	j boucle_displaySudoku
        espace_0:
        	la	$a0, z_t_s
        	li	$v0, 4
        	syscall
        	add     $t1, $t1, 1             # $t1 += 1;
            	add	$t3, $t3, 1		# $t3 += 1;
            	add	$t4, $t4, 1		# $t4 += 1;
            	add	$t5, $t5, 1		# $t5 += 1;
        	j boucle_displaySudoku
        if_sup_a_9:
        	jal addNewLine			#ce sous alorithme sert à sauter une ligne dès que
        	li	$t3, 0			#l'on arrive a neuf chiffres (donc 1 ligne )
        	j boucle_displaySudoku
        make_espace_col:
        	la	$a0, espace_col		#permet de mettre un "|" entre les colonnes de la grille
        	li	$v0, 4
        	syscall
        	li	$t4, 0
        	j boucle_displaySudoku
        make_espace_row:
        	la	$a0, espace_row		#permet de mettre un "_" entre les lignes de la grille
        	li	$v0, 4
        	syscall
        	li	$t5, 0
        	jal addNewLine
        	j boucle_displaySudoku
    	end_displaySudoku:
        	lw      $ra, 0($sp)                 # On recharge la reference 
        	add     $sp, $sp, 4                 # du dernier jump
    		jr $ra 

# ----- Fonction zeroToSpace -----   
# Affiche un espace dans le sudoku à la place des zéro.
# Registres utilises : $a0, $t[0-2]
zeroToSpace:
	add     $sp, $sp, -4 # Sauvegarde de la reference du dernier jump
    	sw      $ra, 0($sp)
    	la      $t0, grille #on charge l'adresse de la grille
    	li	$t1, 0	#$t1 -> indice de la ou on se trouve dans la grille
    	boucle_z_t_s:
    		bge	$t1, 81, end_z_t_s	#si $t1 >= 81, on a fini de parcourir la grille, on arrête la fonction
    		add	$t2, $t0, $t1	#$t2 -> le chiffre actuel grille[n]
    		lb	$a0, ($t2)	#On loadbyte grille[n] dans $a0
    		beq	$a0, 0, remplacer	#Si le chiffre est égal à 0 on remplace
    		add	$t1, $t1, 1	#sinon on incrémente l'indice
    		j boucle_z_t_s
    	remplacer:
    		li	$a0, 32		#32 est le code ascii de l'espace
    		sb	$a0, ($t2)	#on remplace
        	add	$t1, $t1, 1	#on incrémente l'indice
    		j boucle_z_t_s	
    	end_z_t_s:
    		lw	$ra, 0($sp)
    		add	$sp, $sp, 4
    	jr $ra


#                                               #
#                                               #
#                                               #
#                                               #
# Fonction !!!                                  #  
#                                               #
#                                               #
#                                               #
################################################# 





exit: 
    li $v0, 10
    syscall
