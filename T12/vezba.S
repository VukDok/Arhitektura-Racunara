.section .data
input_msg: .ascii "Unesite rec: \0"
input_len = . - input_msg
output_msg: .ascii "Izlaz: \0"
output_len = . - output_msg
max_len = 30
input: .fill max_len, 1, 42
.section .text
.global main

main:
	movl $4, %eax #write input_msg
	movl $1, %ebx
	movl $input_msg, %ecx
	movl $input_len, %edx
	int $0x80
	
	movl $3, %eax #read input
	movl $0, %ebx
	movl $input, %ecx
	movl $max_len, %edx
	int $0x80
	
	movl $0, %esi #brojac slova i brojac promena
	movl $0, %edi #cuva input u petlji
	movl $0, %ebp #cuva broj slova sa enterom, radi 69. linije (brisanje zvezdica)
	
brojslova: #broji slova u inputu bez entera, kada naidje na enter ide na proveru (enter = 10 ascii)
	incl %ebp
	cmpb $10, (%ecx)
	je provera
	incl %esi
	incl %ecx
	jmp brojslova
	
provera: #testl nad %esi, ako zero flag bude 1, to znaci da je broj slova paran
	testl $1, %esi
	jz paran
	
neparan:
	movl $0, %esi #vracanje esija na 0, da bi se koristio za broj promena
	movl $input+1, %edi #input+1 stavlja edi kao pokazivac na drugo slovo
	jmp petlja
	
paran:
	movl $0, %esi
	movl $input, %edi #ovde pocinje od prvog tj neparnog

petlja:
	cmpb $10, (%edi) #kada dodje do entera staje petlja
	je kraj
	
	movb $42, (%edi) #ubacivanje zvezdice na prvo mesto edija
	incl %esi #svaki put kad se napravi promena brojac se dize za 1
	addl $2, %edi #prebacuje edi dva slova napred
	jmp petlja
	
kraj:

	movl $4, %eax #write output_msg
	movl $1, %ebx
	movl $output_msg, %ecx
	movl $output_len, %edx
	int $0x80
	
	movl $4, %eax #write rezultat
	movl $1, %ebx
	movl $input, %ecx
	movl %ebp, %edx #ebp nam je brojao slova sa enterom pa je zato ovde da skloni zvezdice sa inputa
	int $0x80

	movl $1, %eax
	movl %esi, %ebx #broj promena u izlaz
	int $0x80
