" Vim syntax file
" Language:    FORTH
" Maintainer:  Thomas E. Vaughan
" Last Change: 2016 April
" Filenames:   *.4th,*.4TH

" This is based on the forth syntax distributed with vim but with a few minor
" differences. I couldn't figure out how to make it all work by extending the
" default forth, and so I just made a new syntax. The standard forth doesn't
" use the file extensions that I use, and so it seems natural.


" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif

let s:cpo_save = &cpo
set cpo&vim

" Synchronization method
syn sync ccomment
syn sync maxlines=200

" Some special, non-FORTH keywords
syn keyword tforthTodo contained TODO FIXME XXX
syn match tforthTodo contained 'Copyright\(\s([Cc])\)\=\(\s[0-9]\{2,4}\)\='

" Characters allowed in keywords
" I don't know if 128-255 are allowed in ANS-FORTH
if version >= 600
    setlocal iskeyword=!,@,33-35,%,$,38-64,A-Z,91-96,a-z,123-126,128-255
else
    set iskeyword=!,@,33-35,%,$,38-64,A-Z,91-96,a-z,123-126,128-255
endif

" when wanted, highlight trailing white space
if exists("tforth_space_errors")
    if !exists("tforth_no_trail_space_error")
        syn match tforthSpaceError display excludenl "\s\+$"
    endif
    if !exists("tforth_no_tab_space_error")
        syn match tforthSpaceError display " \+\t"me=e-1
    endif
endif

" Keywords

" basic mathematical and logical operators
syn keyword tforthOperators + - * / MOD /MOD NEGATE ABS MIN MAX
syn keyword tforthOperators AND OR XOR NOT LSHIFT RSHIFT INVERT 2* 2/ 1+
syn keyword tforthOperators 1- 2+ 2- 8* UNDER+
syn keyword tforthOperators M+ */ */MOD M* UM* M*/ UM/MOD FM/MOD SM/REM
syn keyword tforthOperators D+ D- DNEGATE DABS DMIN DMAX D2* D2/
syn keyword tforthOperators F+ F- F* F/ FNEGATE FABS FMAX FMIN FLOOR FROUND
syn keyword tforthOperators F** FSQRT FEXP FEXPM1 FLN FLNP1 FLOG FALOG FSIN
syn keyword tforthOperators FCOS FSINCOS FTAN FASIN FACOS FATAN FATAN2 FSINH
syn keyword tforthOperators FCOSH FTANH FASINH FACOSH FATANH F2* F2/ 1/F
syn keyword tforthOperators F~REL F~ABS F~
syn keyword tforthOperators 0< 0<= 0<> 0= 0> 0>= < <= <> = > >= U< U<=
syn keyword tforthOperators U> U>= D0< D0<= D0<> D0= D0> D0>= D< D<= D<>
syn keyword tforthOperators D= D> D>= DU< DU<= DU> DU>= WITHIN ?NEGATE
syn keyword tforthOperators ?DNEGATE

" stack manipulations
syn keyword tforthStack DROP NIP DUP OVER TUCK SWAP ROT -ROT ?DUP PICK ROLL
syn keyword tforthStack 2DROP 2NIP 2DUP 2OVER 2TUCK 2SWAP 2ROT 2-ROT
syn keyword tforthStack 3DUP 4DUP 5DUP 3DROP 4DROP 5DROP 8DROP 4SWAP 4ROT
syn keyword tforthStack 4-ROT 4TUCK 8SWAP 8DUP
syn keyword tforthRStack >R R> R@ RDROP 2>R 2R> 2R@ 2RDROP
syn keyword tforthRstack 4>R 4R> 4R@ 4RDROP
syn keyword tforthFStack FDROP FNIP FDUP FOVER FTUCK FSWAP FROT

" stack pointer manipulations
syn keyword tforthSP SP@ SP! FP@ FP! RP@ RP! LP@ LP!

" address operations
syn keyword tforthMemory @ ! +! C@ C! 2@ 2! F@ F! SF@ SF! DF@ DF!
syn keyword tforthAdrArith CHARS CHAR+ CELLS CELL+ CELL ALIGN ALIGNED FLOATS
syn keyword tforthAdrArith FLOAT+ FLOAT FALIGN FALIGNED SFLOATS SFLOAT+
syn keyword tforthAdrArith SFALIGN SFALIGNED DFLOATS DFLOAT+ DFALIGN DFALIGNED
syn keyword tforthAdrArith MAXALIGN MAXALIGNED CFALIGN CFALIGNED
syn keyword tforthAdrArith ADDRESS-UNIT-BITS ALLOT ALLOCATE HERE
syn keyword tforthMemBlks MOVE ERASE CMOVE CMOVE> FILL BLANK

" conditionals
syn keyword tforthCond IF ELSE ENDIF THEN CASE OF ENDOF ENDCASE ?DUP-IF
syn keyword tforthCond ?DUP-0=-IF AHEAD CS-PICK CS-ROLL CATCH THROW WITHIN

" iterations
syn keyword tforthLoop BEGIN WHILE REPEAT UNTIL AGAIN
syn keyword tforthLoop ?DO LOOP I J K +DO U+DO -DO U-DO DO +LOOP -LOOP
syn keyword tforthLoop UNLOOP LEAVE ?LEAVE EXIT DONE FOR NEXT

" new words
syn match tforthClassDef '\<:class\s*[^ \t]\+\>'
syn match tforthObjectDef '\<:object\s*[^ \t]\+\>'
syn match tforthColonDef '\<:m\?\s*[^ \t]\+\>'
syn keyword tforthEndOfColonDef ; ;M ;m
syn keyword tforthEndOfClassDef ;class
syn keyword tforthEndOfObjectDef ;object
syn keyword tforthDefine CONSTANT 2CONSTANT FCONSTANT VARIABLE 2VARIABLE
syn keyword tforthDefine FVARIABLE CREATE USER VALUE TO DEFER IS DOES> IMMEDIATE
syn keyword tforthDefine COMPILE-ONLY COMPILE RESTRICT INTERPRET POSTPONE EXECUTE
syn keyword tforthDefine LITERAL CREATE-INTERPRET/COMPILE INTERPRETATION>
syn keyword tforthDefine <INTERPRETATION COMPILATION> <COMPILATION ] LASTXT
syn keyword tforthDefine COMP' POSTPONE, FIND-NAME NAME>INT NAME?INT NAME>COMP
syn keyword tforthDefine NAME>STRING STATE C; CVARIABLE
syn keyword tforthDefine , 2, F, C,
syn match tforthDefine "\[IFDEF]"
syn match tforthDefine "\[IFUNDEF]"
syn match tforthDefine "\[THEN]"
syn match tforthDefine "\[ENDIF]"
syn match tforthDefine "\[ELSE]"
syn match tforthDefine "\[?DO]"
syn match tforthDefine "\[DO]"
syn match tforthDefine "\[LOOP]"
syn match tforthDefine "\[+LOOP]"
syn match tforthDefine "\[NEXT]"
syn match tforthDefine "\[BEGIN]"
syn match tforthDefine "\[UNTIL]"
syn match tforthDefine "\[AGAIN]"
syn match tforthDefine "\[WHILE]"
syn match tforthDefine "\[REPEAT]"
syn match tforthDefine "\[COMP']"
syn match tforthDefine "'"
syn match tforthDefine '\<\[\>'
syn match tforthDefine "\[']"
syn match tforthDefine '\[COMPILE]'

" debugging
syn keyword tforthDebug PRINTDEBUGDATA PRINTDEBUGLINE
syn match tforthDebug "\<\~\~\>"

" Assembler
syn keyword tforthAssembler ASSEMBLER CODE END-CODE ;CODE FLUSH-ICACHE C,

" basic character operations
syn keyword tforthCharOps (.) CHAR EXPECT FIND WORD TYPE -TRAILING EMIT KEY
syn keyword tforthCharOps KEY? TIB CR
" recognize 'char (' or '[char] (' correctly, so it doesn't
" highlight everything after the paren as a comment till a closing ')'
syn match tforthCharOps '\<char\s\S\s'
syn match tforthCharOps '\<\[char\]\s\S\s'
syn region tforthCharOps start=+."\s+ skip=+\\"+ end=+"+

" char-number conversion
syn keyword tforthConversion <<# <# # #> #>> #S (NUMBER) (NUMBER?) CONVERT D>F
syn keyword tforthConversion D>S DIGIT DPL F>D HLD HOLD NUMBER S>D SIGN >NUMBER
syn keyword tforthConversion F>S S>F

" interpreter, wordbook, compiler
syn keyword tforthForth (LOCAL) BYE COLD ABORT >BODY >NEXT >LINK CFA >VIEW HERE
syn keyword tforthForth PAD WORDS VIEW VIEW> N>LINK NAME> LINK> L>NAME FORGET
syn keyword tforthForth BODY> ASSERT( ASSERT0( ASSERT1( ASSERT2( ASSERT3( )
syn region tforthForth start=+ABORT"\s+ skip=+\\"+ end=+"+

" vocabularies
syn keyword tforthVocs ONLY FORTH ALSO ROOT SEAL VOCS ORDER CONTEXT #VOCS
syn keyword tforthVocs VOCABULARY DEFINITIONS

" File keywords
syn keyword tforthFileMode R/O R/W W/O BIN
syn keyword tforthFileWords OPEN-FILE CREATE-FILE CLOSE-FILE DELETE-FILE
syn keyword tforthFileWords RENAME-FILE READ-FILE READ-LINE KEY-FILE
syn keyword tforthFileWords KEY?-FILE WRITE-FILE WRITE-LINE EMIT-FILE
syn keyword tforthFileWords FLUSH-FILE FILE-STATUS FILE-POSITION
syn keyword tforthFileWords REPOSITION-FILE FILE-SIZE RESIZE-FILE
syn keyword tforthFileWords SLURP-FILE SLURP-FID STDIN STDOUT STDERR
syn keyword tforthBlocks OPEN-BLOCKS USE LOAD --> BLOCK-OFFSET
syn keyword tforthBlocks GET-BLOCK-FID BLOCK-POSITION LIST SCR BLOCK
syn keyword tforthBlocks BUFER EMPTY-BUFFERS EMPTY-BUFFER UPDATE UPDATED?
syn keyword tforthBlocks SAVE-BUFFERS SAVE-BUFFER FLUSH THRU +LOAD +THRU
syn keyword tforthBlocks BLOCK-INCLUDED

" numbers
syn keyword tforthMath DECIMAL HEX BASE
syn match tforthInteger '\<-\=[0-9.]*[0-9.]\+\>'
syn match tforthInteger '\<&-\=[0-9.]*[0-9.]\+\>'
" recognize hex and binary numbers, the '$' and '%' notation is for gforth
syn match tforthInteger '\<\$\x*\x\+\>' " *1* --- dont't mess
syn match tforthInteger '\<\x*\d\x*\>'  " *2* --- this order!
syn match tforthInteger '\<%[0-1]*[0-1]\+\>'
syn match tforthFloat '\<-\=\d*[.]\=\d\+[DdEe]\d\+\>'
syn match tforthFloat '\<-\=\d*[.]\=\d\+[DdEe][-+]\d\+\>'

" XXX If you find this overkill you can remove it. This has to come after the
" highlighting for numbers otherwise it has no effect.
syn region tforthComment start='0 \[if\]' end='\[endif\]' end='\[then\]' contains=forthTodo

" Strings
syn region tforthString start=+\.*\"+ end=+"+ end=+$+ contains=@Spell
" XXX
syn region tforthString start=+s\"+ end=+"+ end=+$+ contains=@Spell
syn region tforthString start=+c\"+ end=+"+ end=+$+ contains=@Spell

" Comments
syn match tforthComment '\\\s.*$' contains=@Spell,tforthTodo,tforthSpaceError
syn region tforthComment start='\\S\s' end='.*' contains=@Spell,tforthTodo,tforthSpaceError
syn match tforthComment '\.(\s[^)]*)' contains=@Spell,tforthTodo,tforthSpaceError
syn region tforthComment start='\(^\|\s\)\zs(\s' skip='\\)' end=')' contains=@Spell,tforthTodo,tforthSpaceError
" CHANGED C-style comments to TFORTH comments.
syn region tforthComment start='^}' end='^{' contains=@Spell,tforthTodo,tforthSpaceError

" Include files
syn match tforthInclude '^INCLUDE\s\+\k\+'
syn match tforthInclude '^require\s\+\k\+'
syn match tforthInclude '^fload\s\+'
syn match tforthInclude '^needs\s\+'

" Locals definitions
" REMOVED forthLocals definitions, which used braces and conflicted with TFORTH
" comments.
syn region tforthDeprecated start='locals|' end='|'

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_tforth_syn_inits")
    if version < 508
	let did_tforth_syn_inits = 1
	command -nargs=+ HiLink hi link <args>
    else
	command -nargs=+ HiLink hi def link <args>
    endif

    " The default methods for highlighting. Can be overridden later.
    HiLink tforthTodo Todo
    HiLink tforthOperators Operator
    HiLink tforthMath Number
    HiLink tforthInteger Number
    HiLink tforthFloat Float
    HiLink tforthStack Special
    HiLink tforthRstack Special
    HiLink tforthFStack Special
    HiLink tforthSP Special
    HiLink tforthMemory Function
    HiLink tforthAdrArith Function
    HiLink tforthMemBlks Function
    HiLink tforthCond Conditional
    HiLink tforthLoop Repeat
    HiLink tforthColonDef Define
    HiLink tforthEndOfColonDef Define
    HiLink tforthDefine Define
    HiLink tforthDebug Debug
    HiLink tforthAssembler Include
    HiLink tforthCharOps Character
    HiLink tforthConversion String
    HiLink tforthForth Statement
    HiLink tforthVocs Statement
    HiLink tforthString String
    HiLink tforthComment Comment
    HiLink tforthClassDef Define
    HiLink tforthEndOfClassDef Define
    HiLink tforthObjectDef Define
    HiLink tforthEndOfObjectDef Define
    HiLink tforthInclude Include
    " REMOVED use of tforthLocals.
    HiLink tforthDeprecated Error " if you must, change to Type
    HiLink tforthFileMode Function
    HiLink tforthFileWords Statement
    HiLink tforthBlocks Statement
    HiLink tforthSpaceError Error

    delcommand HiLink
endif

let b:current_syntax = "tforth"

let &cpo = s:cpo_save
unlet s:cpo_save
" vim:ts=8:sw=4:nocindent:smartindent:
