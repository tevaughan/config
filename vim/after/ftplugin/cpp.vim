
setlocal formatoptions=1cjnroq
let     &formatlistpat='^\s*\w\+[.\)]\s\+\|^\s*[\-\+\*]\+\s\+\|^\s*@\w\+\s\+'
setlocal comments=sr:/*,mb:*,el:*/,:///,://

" For light-gray column at beginning of margin.
highlight ColorColumn ctermbg=darkgray
setlocal colorcolumn=+1

setlocal tw=79
setlocal sw=2

" For clang-format.
"map <buffer> <C-K> :pyf ~/.vim/clang-format.py<CR>
map <buffer> <C-K> :py3f ~/.vim/clang-format.py<CR>

" Comment out next line to allow using <C-K> in insert mode for typing a
" non-Latin symbol, such as μ via <C-K> m *.
"imap <buffer> <C-K> <ESC>:pyf ~/.vim/clang-format.py<CR>i

setlocal grepprg="pcregrep -n $* /dev/null"
command! -buffer -nargs=1 Cgrep grep <q-args> `find . -iname '*.c' -o -iname '*.cpp' -o -iname '*.h' -o -iname '*.hpp'`

