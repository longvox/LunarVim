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
    let filename = '.gitignore'
    if filereadable(filename)
        let igstring = ''
        for oline in readfile(filename)
            let line = substitute(oline, '\s|\n|\r', '', "g")
            if line =~ '^#' | con | endif
            if line == '' | con  | endif
            if line =~ '^!' | con  | endif
            if line =~ '/$' | let igstring .= "," . line . "*" | con | endif
            let igstring .= "," . line
        endfor
        let execstring = "set wildignore=".substitute(igstring, '^,', '', "g")
        execute execstring
    endif
  ]]

}

Wildignore.load = function(commands)
  for _, command in ipairs(commands) do
    vim.cmd(command)
  end
end

return Wildignore
