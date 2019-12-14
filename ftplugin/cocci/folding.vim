" Vim folding file
" Language:     Cocci (SmPL)
" Author:       Jaskaran Singh <jaskaransingh7654321@gmail.com>
" License:      You may redistribute this under the same terms as Vim itself.

if exists("g:cocci_folding") && g:cocci_folding
    setlocal foldmethod=expr
    setlocal foldexpr=GetCocciFold(v:lnum)
endif


function! s:GetMatchCount(pattern, start, end)
    redir => cnt
        silent! exe a:start . ',' . a:end . 's/' . a:pattern . '//gn'
    redir END
    echom cnt
    let res = trim(strpart(cnt, 0, stridx(cnt, " ")))
    return str2nr(res)
endfunction


function! GetCocciFold(lnum)
    let rule_pattern = '\v^\s*\@.*\@'
    let non_blank_pattern = '\v^\s*\S'
    let rule_pats_before = <SID>GetMatchCount(rule_pattern, 1, a:lnum - 1)

    if getline(a:lnum) =~? rule_pattern
        \ && a:lnum == 1
    return '>1'
    endif

    if getline(a:lnum) =~? rule_pattern
        \ && fmod(rule_pats_before, 2) == 0.0
    return '>1'
    endif

    if getline(a:lnum) =~? non_blank_pattern
        \ && getline(nextnonblank(a:lnum + 1)) =~? rule_pattern
        \ && fmod(rule_pats_before, 2) == 0.0
    return '<1'
    endif

    return  '='
endfunction
