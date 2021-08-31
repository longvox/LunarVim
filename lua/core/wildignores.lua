local Wildignore = {}

Wildignore.defaults = {
  [[  
    set wildignore=*/dist*/*,*/target/*,*/builds/*,*/node_modules/*
    set wildignore+=*/vendors/*
    " Binary
    set wildignore+=*.aux,*.out,*.toc
    set wildignore+=*.o,*.obj,*.exe,*.dll,*.jar,*.pyc,*.rbc,*.class
    set wildignore+=*.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp
    set wildignore+=*.avi,*.m4a,*.mp3,*.oga,*.ogg,*.wav,*.webm
    set wildignore+=*.eot,*.otf,*.ttf,*.woff
    set wildignore+=*.doc,*.pdf
    set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
    " Cache
    set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*.gem
    set wildignore+=.sass-cache
    set wildignore+=npm-debug.log
    " Compiled
    set wildignore+=*.marko.js
    set wildignore+=*.min.*,*-min.*
    " Temp/System
    set wildignore+=*.*~,*~
    set wildignore+=*.swp,.lock,.DS_Store,._*,tags.lock
    " javscript prject
    set wildignore+=package-lock.json,*.lock
    " dart
    set wildignore+=*.inject.summary;*.inject.dart;*.g.dart;

    " source from https://www.vim.org/scripts/script.php?script_id=2557
    if exists("g:loaded_gitignore_wildignore")
      finish
    endif
    let g:loaded_gitignore_wildignore = 1
  ]],
  [[
    function! WildignoreFromGitignore(...)
      let gitignore = (a:0 && !empty(a:1)) ? fnamemodify(a:1, ':p') : fnamemodify(expand('%'), ':p:h') . '/'
      let gitignore .= '.gitignore'
      if filereadable(gitignore)
        let igstring = ''
        for oline in readfile(gitignore)
          let line = substitute(oline, '\n|\r', '', "g")
          echo line
          if line =~ '^#' | con | endif
          if line == ''   | con | endif
          if line =~ '^!' | con | endif
          if line =~ '\s' | con | endif
          if line =~ '/$' | let igstring .= "," . line . "*" | con | endif
          let igstring .= "," . line
        endfor
        echo igstring
        let execstring = "set wildignore+=".substitute(igstring, '^,', '', "g")
        execute execstring
      endif
    endfunction

    command -nargs=? WildignoreFromGitignore :call WildignoreFromGitignore(<q-args>)

    augroup wildignorefromgitignore_fugitive
        autocmd!
        autocmd User Fugitive if exists('b:git_dir') | call WildignoreFromGitignore(fnamemodify(b:git_dir, ':h')) | endif
    augroup END
  ]]

}

Wildignore.load = function(commands)
  for _, command in ipairs(commands) do
    vim.cmd(command)
  end
end

return Wildignore
