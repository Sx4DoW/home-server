{ ... }:
{
    programs.tmux = {
        enable = true;
        clock24 = true;
        keyMode = "vi";
        extraConfig = ''
        # Mouse support (click windows, resize panes)
        set -g mouse on
        
        # Use Ctrl+a as prefix
        set -g prefix C-a
        unbind C-b
        bind C-a send-prefix

        # Split panes using | and -
        bind | split-window -h
        bind - split-window -v
        unbind '"'
        unbind %
        '';
    };
}