
setlocal formatoptions=croql
setlocal comments=sr:/*,mb:*,el:*/,:///,://

" For clang-format.
map <buffer> <C-K> :pyf ~/.vim/clang-format.py<CR>
imap <buffer> <C-K> <ESC>:pyf ~/.vim/clang-format.py<CR>i

command -buffer -nargs=* Cgrep grep <args> `find . -iname '*.c' -o -iname '*.cpp' -o -iname '*.h' -o -iname '*.hpp'`
command -buffer -nargs=* Hgrep grep <args> `find . -iname '*.h' -o -iname '*.hpp'`

