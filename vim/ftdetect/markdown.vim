
" For some older versions of vim that need correcting, override the erroneous
" recognition of a '*.md' file as being of type 'modula-2'. It should rather be
" of type 'markdown'.
autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown

