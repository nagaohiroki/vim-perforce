if exists("g:perforce_vim")
  finish
endif
let g:perforce_vim=1
let s:save_cpo = &cpo
set cpo&vim
function! s:safe_path()
	return '"' . fnameescape(expand('%:p')) . '"'
endfunction
command! P4edit call system('p4 edit ' . s:safe_path())
command! P4revert call system('p4 revert ' . s:safe_path())
command! P4add call system('p4 add ' . s:safe_path())
command! P4cleanup call system('p4 revert -a -c default') | echo system('p4 opened')
command! P4filelog echo iconv(system('p4 filelog -L ' . s:safe_path()), 'cp932', &encoding)
if has('win32')
	command! P4v execute '!start p4v -s ' . s:safe_path()
	command! P4vHistory execute '!start p4v -t history -s ' . s:safe_path()
endif
function! P4_fzf()
python3 << EOF
import subprocess
import marshal
import vim
info = subprocess.Popen('p4 -G info', shell=True, stdout=subprocess.PIPE)
info.wait()
info_dic = marshal.load(info.stdout)
root = info_dic[b'clientRoot'].decode()
client = info_dic[b'clientName'].decode()
out = subprocess.Popen('p4 -G opened', shell=True, stdout=subprocess.PIPE)
files = []
try:
	while True:
		files.append(marshal.load(out.stdout))
except EOFError:
	pass
ft = [f[b'clientFile'].decode().replace('//' + client, root) for f in files]
vim.command(':let s:p4_opend_files = ' + str(ft))
EOF
	return s:p4_opend_files
endfunction
command! P4FZF call fzf#run({
\  'source':  P4_fzf(),
\  'sink':    'e',
\  'options': '-m -x +s',
\  'down':    '40%'})
let &cpo = s:save_cpo
unlet s:save_cpo
