function la --wraps=ls --wraps='ls -al' --wraps='lsd -al' --description 'alias la lsd -al'
  lsd -al $argv; 
end
