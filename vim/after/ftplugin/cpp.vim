
setlocal formatoptions=croql
setlocal comments=sr:/*,mb:*,el:*/,:///,://

" For clang-format.
map <C-K> :pyf ~/.vim/clang-format.py<CR>
imap <C-K> <ESC>:pyf ~/.vim/clang-format.py<CR>i

command -nargs=* Cgrep grep <args> `find . -iname '*.c' -o -iname '*.cpp' -o -iname '*.h' -o -iname '*.hpp'`
command -nargs=* Hgrep grep <args> `find . -iname '*.h' -o -iname '*.hpp'`

