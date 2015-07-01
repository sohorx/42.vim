" **************************************************************************** "
"                                                                              "
"                                                        :::      ::::::::     "
"    stdheader.vim                                     :+:      :+:    :+:     "
"                                                    +:+ +:+         +:+       "
"    By: zaz <zaz@staff.42.fr>                     +#+  +:+       +#+          "
"                                                +#+#+#+#+#+   +#+             "
"    Created: 2013/06/15 12:45:56 by zaz              #+#    #+#               "
"    Updated: 2015/04/25 03:51:56 by abanlin          ###   ########.fr        "
"                                                                              "
" **************************************************************************** "
" " HEADER 42 ++ [ comment ] "
" ***************************"

if exists("b:header_42h")
	finish
else
    let b:header_42h = 1
endif

let s:asciiart = [
			\"        :::      ::::::::",
			\"      :+:      :+:    :+:",
			\"    +:+ +:+         +:+  ",
			\"  +#+  +:+       +#+     ",
			\"+#+#+#+#+#+   +#+        ",
			\"     #+#    #+#          ",
			\"    ###   ########.fr    "
			\]

let s:styles = [
			\{
			\'extensions': ['\.c$', '\.h$', '\.cc$', '\.hh$', '\.cpp$', '\.hpp$'],
			\'start': '/*', 'end': '*/', 'fill': '*', 'sep': ' '
			\},
			\{
			\'extensions': ['\.htm$', '\.html$', '\.xml$', '\.md$', '\.markdownd$'],
			\'start': '<!--', 'end': '-->', 'fill': '*', 'sep': '-'
			\},
			\{
			\'extensions': ['\.js$'],
			\'start': '//', 'end': '//', 'fill': '*', 'sep': ' '
			\},
			\{
			\'extensions': ['\.tex$'],
			\'start': '%', 'end': '%', 'fill': '*', 'sep': ' '
			\},
			\{
			\'extensions': ['\.ml$', '\.mli$', '\.mll$', '\.mly$'],
			\'start': '(*', 'end': '*)', 'fill': '*', 'sep': '*'
			\},
			\{
			\'extensions': ['\.vim$', 'vimrc$', '\.myvimrc$', 'vimrc$', 'gvimrc', '\.gvimrc'],
			\'start': '"', 'end': '"', 'fill': '*', 'sep': ' '
			\},
			\{
			\'extensions': ['\.el$', '\.emacs$', '\.myemacs$'],
			\'start': ';', 'end': ';', 'fill': '*', 'sep': ' '
			\},
			\{
			\'extensions': ['\.hs$', '\.haskell$'],
			\'start': '--', 'end': '--', 'fill': '-', 'sep': '-'
			\}
			\]

let s:linelen		= 80
let s:marginlen		= 5
let s:contentlen	= s:linelen - (3 * s:marginlen) - strlen(s:asciiart[0])

function s:trimlogin ()
	let l:trimlogin = strpart($ft_USER, 0, 9)
	if strlen(l:trimlogin) == 0
		let l:trimlogin = "marvin"
	endif
	return l:trimlogin
endfunction

function s:trimemail ()
	let l:trimemail = strpart($ft_MAIL, 0, s:contentlen - 16)
	if strlen(l:trimemail) == 0
		let l:trimemail = "marvin@42.fr"
	endif
	return l:trimemail
endfunction

function s:midgap ()
	return repeat(' ', s:marginlen)
endfunction

function s:lmargin ()
	return repeat(' ', s:marginlen - strlen(s:start))
endfunction

function s:rmargin ()
	return repeat(' ', s:marginlen - strlen(s:end))
endfunction

function s:empty_content ()
	return repeat(' ', s:contentlen)
endfunction

function s:left ()
	return s:start . s:lmargin()
endfunction

function s:right ()
	return s:rmargin() . s:end
endfunction

function s:bigline ()
	return s:start . s:sep . repeat(s:fill, s:linelen - 2 - strlen(s:start) - strlen(s:end)) . s:sep . s:end
endfunction

function s:logo1 ()
	return s:left() . s:empty_content() . s:midgap() . s:asciiart[0] . s:right()
endfunction

function s:fileline ()
	let l:trimfile = strpart("Module: " . expand('%:t:r'), 0, s:contentlen)
	return s:left() . l:trimfile . repeat(' ', s:contentlen - strlen(l:trimfile)) . s:midgap() . s:asciiart[1] . s:right()
endfunction

function s:logo2 ()
	return s:left() . s:empty_content() . s:midgap() .s:asciiart[2] . s:right()
endfunction

function s:coderline ()
	let l:contentline = "By: ". s:trimlogin () . ' <' . s:trimemail () . '>'
	return s:left() . l:contentline . repeat(' ', s:contentlen - strlen(l:contentline)) . s:midgap() . s:asciiart[3] . s:right()
endfunction

function s:logo3 ()
	return s:left() . s:empty_content() . s:midgap() .s:asciiart[4] . s:right()
endfunction

function s:dateline (prefix, logo)
	let l:date = strftime("%Y/%m/%d %H:%M:%S")
	let l:contentline = a:prefix . ": " . l:date . " by " . s:trimlogin ()
	return s:left() . l:contentline . repeat(' ', s:contentlen - strlen(l:contentline)) . s:midgap() . s:asciiart[a:logo] . s:right()
endfunction

function s:createline ()
	return s:dateline("Created", 5)
endfunction

function s:updateline ()
	return s:dateline("Updated", 6)
endfunction

function s:emptyline ()
	return s:start . repeat(' ', s:linelen - strlen(s:start) - strlen(s:end)) . s:end
endfunction

function s:noteline ()
	return s:start . " Note: " . repeat(' ', s:linelen - strlen(s:start) - 7 - strlen(s:end)) . s:end
endfunction

function s:filetype ()
	let l:file = fnamemodify(bufname("%"), ':t')

	let s:start = '#'
	let s:end = '#'
	let s:fill = '*'

	for l:style in s:styles
		for l:ext in l:style['extensions']
			if l:file =~ l:ext
				let s:start = l:style['start']
				let s:end = l:style['end']
				let s:fill = l:style['fill']
				let s:sep = l:style['sep']
			endif
		endfor
	endfor
endfunction

function s:insert ()
	call s:filetype ()
	call append (0, s:bigline())
	call append (0, s:emptyline())
	call append (0, s:updateline())
	call append (0, s:createline())
	call append (0, s:logo3())
	call append (0, s:coderline())
	call append (0, s:logo2())
	call append (0, s:fileline())
	call append (0, s:logo1())
	call append (0, s:emptyline())
	call append (0, s:bigline())
endfunction

function s:note ()
    if s:update() == 0
        call s:insert ()
    endif
	call append (11, s:bigline())
	call append (11, s:emptyline())
	call append (11, s:emptyline())
	call append (11, s:noteline())
endfunction

function s:update ()
	call s:filetype ()

	let l:pattern = s:start . repeat(' ', 5 - strlen(s:start)) . "Updated: [0-9]"
	let l:line = getline (9)

	if l:line =~ l:pattern
		call setline(9, s:updateline())
        return 1
	endif
    return 0
endfunction

command FtHeader call s:insert ()
command FtNotes  call s:note ()
autocmd BufWritePre * call s:update ()
