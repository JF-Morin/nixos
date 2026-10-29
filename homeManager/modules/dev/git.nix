{ config, pkgs, user,  ... }:

{
    programs.git = {
        enable = true;
        settings = {
            user = {
                name  = "JF-Morin";
                email = user.email;
            };
            alias = {
                aa   = "add --all";
                ai   = "add -i";
                br   = "branch";
                bra  = "branch -a";
                brd  = "branch -d";
                brr  = "branch -r";
                ci   = "commit";
                cia  = "commit -a";
                cim  = "commit -m";
                ciam = "commit -am";
                cl   = "clone";
                f    = "fetch";
                fo   = "fetch origin";
                fu   = "fetch upstream";
                lg   = "log --oneline";
                lg2  = "log --oneline --graph --decorate";
                m    = "merge";
                ma   = "merge --abort";
                mc   = "merge --continue";
                co   = "checkout";
                cob  = "checkout -b";
                ps   = "push";
                psu  = "push -u";
                pl   = "pull";
                rb   = "rebase";
                rst  = "reset";
                st   = "status";
            };
            init.defaultBranch = "main";
            core.editor         = "nvim";
            web.browser         = "brave";
            color = {
                ui     = "auto";
                branch = {
                    current = "yellow bold";
                    local   = "green bold";
                    remote  = "cyan bold";
                };
                diff = {
                    meta       = "yellow bold";
                    frag       = "magenta bold";
                    old        = "red bold";
                    new        = "green bold";
                    whitespace = "red reverse";
                };
                status = {
                    added     = "green bold";
                    changed   = "yellow bold";
                    untracked = "red bold";
                };
            };
            diff.tool       = "vimdiff";
            difftool.prompt = false;
        };
    };
}
