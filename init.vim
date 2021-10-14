call plug#begin()
Plug 'https://github.com/kien/ctrlp.vim'
Plug 'jiangmiao/auto-pairs'
call plug#end()
set clipboard+=unnamedplus
set autoindent
set mouse=a
set number
set tabstop=4
set shiftwidth=4
set expandtab 
set hidden
let mapleader=" "
nnoremap <leader>e :CtrlP<Enter>
nnoremap <leader>r :CtrlPBuffer<Enter>
nnoremap <F3> :wa<Enter>:make -C build<Enter><Enter>:copen<Enter>
nnoremap <F4> :wa<Enter>:make<Enter><Enter>:cw<Enter>
nnoremap <leader>x :cn<Enter>
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l
nnoremap <leader>v :vs<Enter>
nnoremap <leader>d <C-]>zz
nnoremap <leader>D <C-t>zz
highlight LineNr ctermfg=grey

function! Smart_TabComplete()
  let line = getline('.')                         " current line

  let substr = strpart(line, -1, col('.')+1)      " from the start of the current
                                                  " line to one character right
                                                  " of the cursor
  let substr = matchstr(substr, "[^ \t]*$")       " word till cursor
  if (strlen(substr)==0)                          " nothing to match on empty string
    return "\<tab>"
  endif
  let has_period = match(substr, '\.') != -1      " position of period, if any
  let has_slash = match(substr, '\/') != -1       " position of slash, if any
  if (!has_period && !has_slash)
    return "\<C-X>\<C-P>"                         " existing text matching
  elseif ( has_slash )
    return "\<C-X>\<C-F>"                         " file matching
  else
    return "\<C-X>\<C-O>"                         " plugin matching
  endif
endfunction

inoremap <tab> <c-r>=Smart_TabComplete()<CR>

"
" Insert gates and include statement when creating c and c++ files
"
function! s:insert_gates()
  execute "normal! i#pragma once"
  normal! o
  normal! o
endfunction
autocmd BufNewFile *.{h,hpp} call <SID>insert_gates()

function! s:insert_include()
  let gatename = ""
  echo expand("%:r")
  if filereadable(expand("%:r") . ".h")
      let gatename = expand("%:t:r") . ".h"
      echo gatename
  elseif filereadable(expand("%:r") . ".hpp")
      let gatename = expand("%:t:r") . ".hpp"
  endif

  if(filereadable(expand("%:h") . "/" . gatename))
      execute "normal! i#include \"" . gatename . "\""
      normal! kk
  endif
endfunction
autocmd BufNewFile *.{c,cpp,cc} call <SID>insert_include()

"
" Toggle header in c and c++
"
let g:default_header_ext=".h"
let g:default_source_ext=".cc"
function ToggleHeader()
    let type = expand("%:e")
    if type=="h" || type=="hpp"
        if filereadable(expand("%:r") . ".cc")
            :e %:r.cc
        elseif filereadable(expand("%:r") . ".c")
            :e %:r.c
        elseif filereadable(expand("%:r") . ".cpp")
            :e %:r.cpp
        else
            execute "e " . expand("%:r") . g:default_source_ext
        endif
    elseif type=="cc" || type=="cpp"
        if filereadable(expand("%:r") . ".hpp")
            :e %:r.hpp
        elseif filereadable(expand("%:r") . ".h")
            :e %:r.h
        else
            execute "e " . expand("%:r") . g:default_header_ext
        endif
    elseif type=="c"
        :e %:r.h
    endif
endfunction
nnoremap <leader>m :call ToggleHeader()<cr>
