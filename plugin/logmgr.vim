" vim:set fdm=marker sw=4 ts=4:
" LogMgr - One of many simple vim logging scripts 
" Maintainer: LoganBell <loganbell@gmail.com> 
"
" License: 
" LogMgr, a simple log management script for Vim 
" Copyright (C) 2009  Logan J. Bell
" 
" This program is free software: you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation, either version 3 of the License, or
" (at your option) any later version.
" 
" This program is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.
" 
" You should have received a copy of the GNU General Public License
" along with this program.  If not, see <http://www.gnu.org/licenses/>.

if exists("loaded_logmgr")
  finish
endif

let loaded_logmgr = 1
"Setup up mapping


" Logs is a global variable that is required " Format: let log ='/path/to/log:/path/to/second/log'
if !exists("g:logmgr_logs")
   finish
endif

"Script variables {{{
let s:logs = g:logmgr_logs
let s:log_ar = split(s:logs,":")
let s:bufnum = ''

let s:count = 1
"}}}

"Mapping Setup {{{
for n in s:log_ar

  if !hasmapto('<Plug>OReadTail' . s:count)
    exec 'map <unique> <silent> <Leader>lo' . s:count .' <Plug>OReadTail' . s:count
  endif

  exec 'noremap <unique> <silent> <script> <Plug>OReadTail' .s:count .' :call <SID>ReadTail(' . s:count . ')<CR>'

  let s:count = s:count + 1

endfor

if !hasmapto('<Plug>OCloseTail1')
   map <unique> <Leader>lc  <Plug>OCloseTail1 
endif 
noremap <unique> <script> <Plug>OCloseTail1 :call <SID>CloseTail()<CR>

"}}}

" ReadTail() {{{
"  
" Description: Executes a system call to tail
"              populates results in a vertical buffer
function! s:ReadTail(log_num)

      let s:log_num = a:log_num -1
      let s:cur_log = s:log_ar[s:log_num]

      if s:bufnum > 0
          exec 'bdelete ' . s:bufnum
      endif

      vert new

      let s:bufnum = bufnr( $ )

      setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
      call append(winline()-1,split(system("tail " . s:cur_log),"\n"))

      setlocal nomodifiable

endfunction
" }}}

" CloseTail() {{{
"
" Description: Closes buffer window
function! s:CloseTail()

  if s:bufnum > 0
      exec 'bdelete ' . s:bufnum
  endif

  let s:bufnum = 0

endfunction
" }}}
