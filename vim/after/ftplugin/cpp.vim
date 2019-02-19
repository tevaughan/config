
setlocal formatoptions=1cjnroq
let     &formatlistpat='^\s*\d\+[.\)]\s\+\|^\s*[\-\+\*]\+\s\+\|^\s*@\w\+\s\+'
setlocal comments=sr:/*,mb:*,el:*/,:///,://

" For light-gray column at beginning of margin.
highlight ColorColumn ctermbg=darkgray
setlocal colorcolumn=+1

setlocal tw=79
setlocal sw=2

" For clang-format.
"map <buffer> <C-K> :pyf ~/.vim/clang-format.py<CR>
map <buffer> <C-K> :py3f ~/.vim/clang-format.py<CR>

setlocal grepprg="pcregrep -n $* /dev/null"
command! -buffer -nargs=1 Cgrep grep <q-args> `find . -iname '*.c' -o -iname '*.cpp' -o -iname '*.h' -o -iname '*.hpp'`

" ';' means to use tags nearest tags file here or in superior directory
" hierarchy.
setlocal tags=tags;
