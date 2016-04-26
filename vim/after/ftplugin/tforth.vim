
setlocal comments=:\\S,:\\
setlocal tw=72

" For inserting a full-line comment in Forth.
map <buffer> e :exe "normal A" . repeat(' ', 71 - virtcol("$")) . ";" <Return>

