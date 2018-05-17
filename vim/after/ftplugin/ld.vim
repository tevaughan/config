
setlocal formatoptions=croql
setlocal comments=sr:/*,mb:*,el:*/

setlocal grepprg="pcregrep -n $* /dev/null"
command! -buffer -nargs=1 Cgrep grep <q-args> `find . -iname '*.c' -o -iname '*.cpp' -o -iname '*.h' -o -iname '*.hpp'`

