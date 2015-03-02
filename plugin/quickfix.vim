
function! QFRegex(regex, dir)
   " Gather info about the window state
   let l:winnr = winnr()
   let l:winrest = winrestcmd()
   let l:lastwin = winnr('$')
   " Use the error window to find the current error number
   copen
   let l:errnum = line('.') - 1
   " Restore the window state
   if l:lastwin != winnr('$')
      cclose
   endif
   exec l:winnr . "wincmd w"
   exe l:winrest
   " Get the quickfix list
   let l:qf = getqflist()
   " Find and go to the next matching item in the list
   if a:dir 
      while l:errnum > 0
         if l:qf[l:errnum]['text'] =~ a:regex
            exe "cc " . (l:errnum - 1)
            return
         endif
         let l:errnum -= 1
      endwhile
   else
      let l:len = len(l:qf)
      while l:errnum < l:len
         if l:qf[l:errnum]['text'] =~ a:regex
            exe "cc " . (l:errnum + 1)
            return
         endif
         let l:errnum += 1
      endwhile
   endif
   " Give error if not found 
   echoerr "E553: No coincidences"
endfunction

function! QFNextRegex(regex)
   call QFRegex(a:regex, 0)
endfunction

function! QFPrevRegex(regex)
   call QFRegex(a:regex, 1)
endfunction

command! -nargs=1 QFNextRegex call QFNextRegex(<f-args>)
command! QFNextError call QFNextRegex('error:')

" Shortcut next/previous
map <F3>   :cn<CR> 
map <S-F3> :cprev<CR> 
map <F4>   :call QFNextRegex('error:')<CR>
map <S-F4> :call QFPrevRegex('error:')<CR>
