" Usable with https://gist.github.com/535542

function! Reblock(reindent)
  let start = line(".")
  let end = search("^" . substitute(getline("."), "block:", "/block:", "g"))

  if a:reindent == 1
    exec start + 1 . "," . end . ">"
  endif

  exec end . "d"
  exec start
  s/{block:\(.*\)}/- block "\1" do/
endfunc

nmap ,b :call Reblock(0)<Cr>
nmap ,B :call Reblock(1)<Cr>
