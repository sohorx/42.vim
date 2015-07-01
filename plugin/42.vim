" **************************************************************************** "
"                                                                              "
"                                                         :::      ::::::::    "
"    42.vim                                             :+:      :+:    :+:    "
"                                                     +:+ +:+         +:+      "
"    By: 1 <abanlin_bocal@staff.42.fr>              +#+  +:+       +#+         "
"                                                 +#+#+#+#+#+   +#+            "
"    Created: 2013/07/25 01:50:26 by 1                 #+#    #+#              "
"    Updated: 2015/04/25 03:20:03 by abanlin          ###   ########.fr        "
"                                                                              "
" **************************************************************************** "
" " Protect Header && call StdHeader && RM whitespace "
" ***************************************************"

if exists("b:loaded_42h")
	finish
else
    let b:loaded_42h = 1
endif

function s:VarIsInTab(val, tab)
    for check in a:tab
        if check == a:val
           return 1
        endif
    endfor
    return 0
endfunction

function s:ProtectHeaders()
    if (!s:VarIsInTab(expand("%:e"), ["h", "hh", "hpp"]))
        return
    endif
    let l:filename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
	execute "normal! Go" .
                \ '#ifndef '. l:filename . "\n".
                \ '# define ' . l:filename . "\n".
                \ "\n\n\n".
                \ '#endif /* !' . l:filename . ' */'
	execute "17"
endfunction

function s:HeaderCreate()
    execute "FtHeader"
    execute "13"
    call s:ProtectHeaders()
endfunction

function! s:RemoveST()
    let l:pos = line(".")
    execute "0,$s/[ \t]*$//"
    execute l:pos
endfunction

autocmd BufNewFile	*.{h,hh,hpp,c,cc,cpp}   call s:HeaderCreate()
autocmd BufWritePre *                       call s:RemoveST()
