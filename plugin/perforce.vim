" --------------------------------------------------------------------
" Perforce Plugins
" --------------------------------------------------------------------
if exists("g:perforce_vim")
  finish
endif
if !has('win32')
  finish
endif
let g:perforce_vim=1
let s:save_cpo = &cpo
set cpo&vim
function! SafePath()
	return '"' . fnameescape(expand('%:p')) . '"'
endfunction
command! P4edit call system('p4 edit ' . SafePath())
command! P4revert call system('p4 revert -c default ' . SafePath())
command! P4add call system('p4 add ' . SafePath())
command! P4diff call system('start /min p4 diff ' . SafePath())
command! P4opend echo system('p4 opened')
command! P4cleanup call system('p4 revert -a -c default') | echo system('p4 opened')
command! P4filelog echo iconv(system('p4 filelog -L ' . SafePath()), 'cp932', &encoding)
command! P4v execute '!start p4v -s ' . SafePath()
command! P4vHistory execute '!start p4v -t history -s ' . SafePath()
let &cpo = s:save_cpo
unlet s:save_cpo
