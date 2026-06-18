{ config, pkgs, userSettings, ... }:

{
    programs.git = {
        enable = true;
        userName = "JF-Morin";
        userEmail = userSettings.email; 
        extraConfig = {
            init.defaultBranch = "main";
            core.editor = "nvim";
            web.browser = "brave";
            color = {
                ui = "auto";
                branch = {
                    current = "yellow bold";
                    local = "green bold";
                    remote = "cyan bold";
                };
                diff = {
                    meta = "yellow bold";
                    frag = "magenta bold";
                    old = "red bold";
                    new = "green bold";
                    whitespace = "red reverse";
                };
                status = {
                    added = "green bold";
                    changed = "yellow bold";
                    untracked = "red bold";
                };
            };

            diff.tool = "vimdiff";
            difftool.prompt = false;
        };

        aliases = {
            # Add
            aa = "add --all";
            add = "add -i";

            # Branch
            br = "branch";
            bra = "branch -a";
            brd = "branch -d";
            brr = "branch -r";

            # Commit
            ci = "commit";
            cim = "commit -m";

            # Clone
            cl = "clone";

            # Fetch 
            f = "fetch";

            # Log
            lg = "log";
            lg2 = "log --oneline --graph --decorate";

            # Merge
            m = "merge";
            ma = "merge --abort";
            mc = "merge --continue";

            # Checkout
            co = "checkout";
            cob = "checkout -b";

            # Push
            ps = "push";
            psu = "push -u";

            # Pull
            pl = "pull";

            # Rebase 
            rb = "rebase";

            # Reset
            rst = "reset";

            # Status
            st = "status";

        };
    };
}
