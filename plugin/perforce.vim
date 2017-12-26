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
command! P4edit call system('p4 edit "' . fnameescape(expand('%:p')) . '"')
command! P4revert call system('p4 revert -c default "' . fnameescape(expand('%:p')) . '"')
command! P4diff call system('start /min p4 diff "' . fnameescape(expand('%:p')) . '"')
command! P4epend echo system('p4 opened')
command! P4cleanup call system('p4 revert -a -c default') | echo system('p4 opened')
command! P4v execute '!start p4v -s "' . fnameescape(expand('%:p')) . '"'
command! P4vHistory execute '!start p4v -t history -s "' . fnameescape(expand('%:p')) . '"'
command! P4filelog echo iconv(system('p4 filelog -L ' . fnameescape(expand('%:p'))), 'cp932', &encoding)
let &cpo = s:save_cpo
unlet s:save_cpo
