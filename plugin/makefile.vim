" **************************************************************************** "
"                                                                              "
"                                                         :::      ::::::::    "
"    File: makefile.vim [ Generator ]                   :+:      :+:    :+:    "
"                                                     +:+ +:+         +:+      "
"    By: abanlin <abanlin@student.42.fr>            +#+  +:+       +#+         "
"                                                 +#+#+#+#+#+   +#+            "
"    Created: 2013/12/20 22:52:51 by abanlin           #+#    #+#              "
"    Updated: 2015/01/12 00:11:11 by abanlin          ###   ########.fr        "
"                                                                              "
" **************************************************************************** "
" " Makefile generator (c, cpp)" *
" ********************************

if exists("b:makefile_gen")
    finish
else
    let b:makefile_gen = 1
endif

" ****************
" "  S T A R T " *
" ****************

function s:color()
    call append (0, "GREEN\t=\t\"\\033[32m\"")
    call append (0, "RED\t\t=\t\"\\033[31m\"")
    call append (0, "DEFAULT\t=\t\"\\033[0m\"")
endfunction

function s:comline(nb)
    return repeat('#', a:nb)
endfunction

function s:comtxt(txt)
    return "\#[ " . a:txt ." ]" . s:comline(75 - len(a:txt))
endfunction

function s:pathsub()
    return "OBJS\t:=\t$(patsubst %,$(OBJDIR)/%.o,$(SRC))"
endfunction

function s:vpath(path)
    return "VPATH\t=\t" . a:path
endfunction

function s:cflags(inc)
    call append (0, "CFLAGS\t+=\t-c")
    call append (0, "endif")
    call append (0, "\tCFLAGS\t+=\t-g")
    call append (0, "ifeq ($(DEBUG), yes)")
    call append (0, "CFLAGS\t+=\t-I " . a:inc)
    call append (0, "CFLAGS\t+=\t-pedantic")
    call append (0, "CFLAGS\t+=\t-ansi")
    call append (0, "CFLAGS\t+=\t-W")
    call append (0, "CFLAGS\t+=\t-Wall")
    call append (0, "CFLAGS\t+=\t-Wextra")
endfunction

"******[ "functions" ] ->

function s:name()
    call append (0, "\t\t\t$(CC) $(LDFLAGS) -o $(NAME) $(OBJS)")
    call append (0, "\t\t\t@$(ECHO) $(GREEN) " .'"' . "- - -" . '"' . "$(DEFAULT)")
    call append (0, "$(NAME)\t:\t$(OBJS)")
endfunction

function s:all()
    return "all\t\t:\t$(NAME)"
endfunction

function s:objs()
    call append (0, "\t\t\tmkdir -p $(OBJDIR)")
    call append (0, "$(OBJDIR):")
    call append (0, "")
    call append (0, "$(OBJS)\t:\t| $(OBJDIR)")
    call append (0, "")
    call append (0, "\t\t\t$(CC) $(CFLAGS) $< -o $@")
    call append (0, "$(OBJDIR)/%.o\t:\t%")
endfunction

function s:clean()
    call append (0, "\t\t\t@$(RMV) $(OBJS)")
    call append (0, "\t\t\t@$(ECHO) $(RED)" . '"' . "REMOVE..." . '"' . "$(DEFAULT)")
    call append (0, "clean\t:")
endfunction

function s:fclean()
    call append (0, "\t\t\t@$(ECHO) $(GREEN) " . '"' . "- - -" . '"' . "$(DEFAULT)")
    call append (0, "\t\t\t@$(RMV) $(NAME)")
    call append (0, "fclean\t:\tclean")
endfunction

function s:re()
    return "re\t\t:\tfclean all"
endfunction

function s:phony()
    return ".PHONY\t:\tall obj/%.o clean fclean re"
endfunction

function s:varIsInTab(val, tab)
    for check in a:tab
        if check == a:val
           return 1
        endif
    endfor
    return 0
endfunction

function s:allowedfilename(filename)
    if (s:varIsInTab(a:filename, ["c", "cpp", "cc", "\c+", "\c++"]))
        return 1
    endif
    return 0
endfunction

function s:srcBuf()
    let l:i = 1
    let l:max = tabpagebuflist()
    let l:bool = 0
    let l:allowedfirstbuf = ""
    while l:i < max[0]
        if (s:allowedfilename(fnamemodify(bufname(l:i), ':e')))
            if (l:bool == 0)
                let l:allowedfirstbuf  = fnamemodify(bufname(l:i), ":t")
                let l:bool = 1
            elseif (l:bool == 1)
                call append (0, "\t\t\t" . fnamemodify(bufname(l:i), ':t'))
                let l:bool = 2
            else
                call append (0, "\t\t\t" . fnamemodify(bufname(l:i), ':t') . " \\")
            endif
        endif
        let l:i = l:i + 1
    endwhile
    if (l:bool == 1)
        call append (0, "SRC\t\t=\t" . l:allowedfirstbuf)
    elseif (l:bool == 2)
        call append (0, "SRC\t\t=\t" . l:allowedfirstbuf . " \\")
    else
        call append (0, "SRC\t\t=\t")
    endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"       "  function principal "                                                |
"-------------------------------------------------------------------------------

function s:MakefileGen()
    let l:name = input(bufname('%') . " binary name: ")
    let l:cc = input(bufname('%') . " Compilator: ")
    let l:sf = input(bufname('%') . " Source folders: ")
    let l:inc = input(bufname('%') . " Source Include: ")
    let l:ldflags = input(bufname('%') . " Link flags: ")
    let l:buildir = input(bufname('%') . " build directory: ")
    "###### " init "
    call append (1, s:comline(80))
    call append (0, s:phony())
    call append (0, "")
    call append (0, s:re())
    call append (0, "")
    call s:fclean()
    call append (0, "")
    call s:clean()
    call append (0, "")
    call s:objs ()
    call append (0, "")
    call append (0, s:all())
    call append (0, "")
    call s:name ()
    call append (0, "")
    call append (0, s:comtxt("EXEC"))
    " ##### " exec "
    call append (0, "")
    call s:cflags(l:inc)
    call append (0, "")
    call append (0, "LDFLAGS\t=\t" . l:ldflags)
    call append (0, "")
    call append (0, s:vpath(l:sf))
    call append (0, s:pathsub())
    call append (0, "OBJDIR\t:=\t" . l:buildir)
    call append (0, "")
    call append (0, s:comtxt("SYS"))
    " ##### " sys  "
    call append (0, "")
    call append (0, "ECHO\t=\techo -e")
    call append (0, "RM\t\t=\trm -f")
    call append (0, "RMV\t\t=\trm -vf")
    call append (0, "CC\t\t=\t" . l:cc)
    call append (0, "")
    call append (0, s:comtxt("CMD"))
    " ##### " cmd  "
    call append (0, "")
    call s:color()
    call append (0, "")
    call append (0, s:comtxt("COLOR"))
    call append (0, "")
    call s:srcBuf()
    call append (0, "")
    call append (0, "NAME\t=\t" . l:name)

    execute "FtHeader"
endfunction

command FtMakefile call s:MakefileGen()
autocmd BufNewFile {Makefile} call s:MakefileGen()
