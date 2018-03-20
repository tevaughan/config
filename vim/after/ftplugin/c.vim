
setlocal formatoptions=croql
setlocal comments=sr:/*,mb:*,el:*/

" For clang-format.
"map <buffer> <C-K> :pyf ~/.vim/clang-format.py<CR>
map <buffer> <C-K> :py3f ~/.vim/clang-format.py<CR>

setlocal grepprg="pcregrep -n $* /dev/null"
command! -buffer -nargs=1 Cgrep grep <q-args> `find . -iname '*.c' -o -iname '*.cpp' -o -iname '*.h' -o -iname '*.hpp'`

