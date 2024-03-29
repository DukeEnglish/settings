put these into ~/.vimrc
------------------------------------------------------------


set number
set autoindent
set shiftwidth=4
set softtabstop=4
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 显示相关
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on           " 语法高亮
" 在处理未保存或只读文件的时候，弹出确认
set confirm

" 自动缩进
set autoindent
set cindent
set smartindent
" Tab键的宽度
set tabstop=4
" 统一缩进为4
set softtabstop=4
set shiftwidth=4
" 不要用空格代替制表符
set expandtab
" 在行和段开始处使用制表符
set smarttab

set smartcase
"显示行号
set number
" 显示输入命令
set showcmd

"autocmd InsertLeave * set nocul  " 浅色高亮当前行
"autocmd InsertEnter * set cul    " 用浅色高亮当前行
"set ruler           " 显示标尺
" 设置配色方案
"let g:solarized_termcolors=256
"set background=dark
"colorscheme solarized
colorscheme elflord
"set background=light
"
set scrolloff=7     " 光标移动到buffer的顶部和底部时保持N行距离
set novisualbell    " 不要闪烁

"编码方式
set fencs=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936
set fileencoding=utf-8
:au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""实用设置"""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 设置当文件被改动时自动载入
set autoread
" quickfix模式
"autocmd FileType c,cpp map <buffer> <leader><space> :w<cr>:make<cr>

"代码补全
set completeopt=preview,menu

"允许插件
filetype plugin on
"共享剪贴板
set clipboard+=unnamed

"从不备份
"set nobackup
"自动保存
set autowrite

"搜索逐字符高亮
set hlsearch
set incsearch

" 总是显示状态行
set laststatus=1
" 命令行（在状态行下）的高度
set cmdheight=1

" 带有如下符号的单词不要被换行分割
set iskeyword+=_,$,@,%,#,-

" 允许使用使用鼠标的模式(当前设置为可视模式)
set mouse=v
set selection=exclusive
set selectmode=mouse,key

" 高亮显示匹配的括号
set showmatch
" 匹配括号高亮的时间（单位是十分之一秒）
set matchtime=1

"自动补全
:inoremap ( <c-r>=AutoPair('(', ')')<CR>
:inoremap ) <c-r>=ClosePair(')')<CR>
:inoremap { <c-r>=AutoPair('{', '}')<CR>
:inoremap } <c-r>=ClosePair('}')<CR>
:inoremap [ <c-r>=AutoPair('[', ']')<CR>
:inoremap ] <c-r>=ClosePair(']')<CR>
:inoremap " <c-r>=QuotPair('"')<CR>
:inoremap ' <c-r>=QuotPair("'")<CR>

function! AutoPair(open, close)
    let line = getline('.')
    if col('.') > strlen(line) || line[col('.') - 1] == ' '
        "if a:open=='{'
        "    return a:open."\n \n".a:close."\<Up>\<Tab> \<ESC>i"
        "    endif
        return a:open.a:close."\<ESC>i"
    else
        return a:open
  endif
endfunction

function! ClosePair(char)
    if getline('.')[col('.') - 1] == a:char
        return "\<Right>"
    else
        return a:char
    endif
endfunction

function! QuotPair(char)
    let line = getline('.')
    if line[col('.') - 2] == a:char && line[col('.') - 1]==a:char
        return "\<Right>"
    endif
    if col('.') > strlen(line) || line[col('.') - 1] == ' '
        return a:char.a:char."\<ESC>i"
    else
        return a:char
    endif
endfunction

" 侦测文件类型
filetype on
" 载入文件类型插件
filetype plugin on
" 为特定文件类型载入相关缩进文件
filetype indent on


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""快速调试""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"列出当前目录文件
"map <F3> :tabnew .<CR>

"打开树状文件目录
"map <C-F3> \be

"python,shell,C,C++ 按F5编译运行
map <F5> :call CompileRunGcc()<CR>
nmap <leader>g :call CompileRunGcc()<CR>
func! CompileRunGcc()
    exec "w"
    if &filetype == 'c'
        exec "!g++ % -o %<"
        exec "! ./%<"
    elseif &filetype == 'cpp'
        exec "!g++ % -o %<"
        exec "! ./%<"
    elseif &filetype == 'java'
        exec "!javac %"
        exec "!java %<"
    elseif &filetype == 'sh'
        :!sh ./%
    elseif &filetype == 'python'
        :!python ./%|more
    endif
endfunc

"C,C++的调试
map <F8> :call Rungdb()<CR>
func! Rungdb()
    exec "w"
    exec "!g++ % -g -o %<"
    exec "!gdb ./%<"
endfunc


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""新文件标题""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"新建.c,.h,.sh,.java文件，自动插入文件头

autocmd BufNewFile  *.cpp,*.[ch],*.sh,*.java,*.py exec ":call SetTitle()"

""定义函数SetTitle，自动插入文件头

func SetTitle()
    if &filetype == 'sh' || &filetype == 'python'
        call setline(1,"\#########################################################################")
        call append(line("."), "\# File Name: ".expand("%"))
        call append(line(".")+1, "\# Author: Junyi Li")
        call append(line(".")+2, "\# Personal page: dukeenglish.github.io")
        call append(line(".")+3, "\# Created Time: ".strftime("%T %F"))
        call append(line(".")+4, "\#########################################################################")
    else
        call setline(1, "/*************************************************************************")
        call append(line("."), "   > File Name: ".expand("%"))
        call append(line(".")+1, "   > Author: Junyi Li")
        call append(line(".")+2, "   > Personal page: dukeenglish.github.io")
        call append(line(".")+3, "   > Created Time: ".strftime("%T %F"))
        call append(line(".")+4, " ************************************************************************/")
    endif

    if &filetype == 'sh'
        call append(line(".")-1, "\#!/bin/bash")
        call append(line(".")+6, "")
    endif

    if &filetype == 'python'
        call append(line(".")-1, "\#-*- coding:UTF-8 -*-")
        call append(line(".")-2, "\#!/usr/bin/python")
        call append(line(".")+5, "import sys")
        call append(line(".")+6, "")
    endif

    if &filetype == 'cpp'
        call append(line(".")+5, "#include<iostream>")
        call append(line(".")+6, "using namespace std;")
        call append(line(".")+7, "")
    endif

    if &filetype == 'c'
        call append(line(".")+5, "#include<stdio.h>")
        call append(line(".")+6, "")
    endif

    "新建文件后，自动定位到文件末尾
    exe "normal G"

endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
