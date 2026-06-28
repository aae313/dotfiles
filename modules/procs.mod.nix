_: {
  flake.nixosModules.procs =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.lists) singleton;

      inherit (config.local) user;

      column = kind: style: numeric_search: nonnumeric_search: align: {
        inherit
          kind
          style
          numeric_search
          nonnumeric_search
          align
          ;
      };
    in
    {
      hjem.users.${user.name} = {
        packages = singleton pkgs.procs;

        xdg.config.files."procs/config.toml" = {
          generator = pkgs.writers.writeTOML "procs-config.toml";
          value = {
            columns = [
              (column "Pid" "BrightYellow|Yellow" true false "Left")
              (column "User" "BrightGreen|Green" false true "Left")
              (column "Separator" "White|BrightBlack" false false "Left")
              (column "Tty" "BrightWhite|Black" false false "Left")
              (column "UsageCpu" "ByPercentage" false false "Right")
              (column "UsageMem" "ByPercentage" false false "Right")
              (column "CpuTime" "BrightCyan|Cyan" false false "Left")
              (column "MultiSlot" "ByUnit" false false "Right")
              (column "Separator" "White|BrightBlack" false false "Left")
              (column "Command" "BrightWhite|Black" false true "Left")
            ];

            style = {
              header = "BrightWhite|Black";
              unit = "BrightWhite|Black";
              tree = "BrightWhite|Black";

              by_percentage = {
                color_000 = "BrightBlue|Blue";
                color_025 = "BrightGreen|Green";
                color_050 = "BrightYellow|Yellow";
                color_075 = "BrightRed|Red";
                color_100 = "BrightRed|Red";
              };

              by_state = {
                color_d = "BrightRed|Red";
                color_r = "BrightGreen|Green";
                color_s = "BrightBlue|Blue";
                color_t = "BrightCyan|Cyan";
                color_z = "BrightMagenta|Magenta";
                color_x = "BrightMagenta|Magenta";
                color_k = "BrightYellow|Yellow";
                color_w = "BrightYellow|Yellow";
                color_p = "BrightYellow|Yellow";
              };

              by_unit = {
                color_k = "BrightBlue|Blue";
                color_m = "BrightGreen|Green";
                color_g = "BrightYellow|Yellow";
                color_t = "BrightRed|Red";
                color_p = "BrightRed|Red";
                color_x = "BrightBlue|Blue";
              };
            };

            search = {
              numeric_search = "Exact";
              nonnumeric_search = "Partial";
              logic = "And";
              case = "Smart";
            };

            display = {
              show_self = false;
              show_self_parents = false;
              show_thread = false;
              show_thread_in_tree = true;
              show_parent_in_tree = true;
              show_children_in_tree = true;
              show_header = true;
              show_footer = false;
              cut_to_terminal = true;
              cut_to_pager = false;
              cut_to_pipe = false;
              color_mode = "Auto";
              separator = "│";
              ascending = "▲";
              descending = "▼";
              tree_symbols = [
                "│"
                "─"
                "┬"
                "├"
                "└"
              ];
              abbr_sid = true;
              theme = "Auto";
              show_kthreads = true;
            };

            sort = {
              column = 0;
              order = "Ascending";
            };

            docker.path = "unix:///var/run/docker.sock";

            pager = {
              mode = "Auto";
              detect_width = false;
              use_builtin = false;
              command = "ov --header=1 --wrap=false --column-delimiter=│";
            };
          };
        };
      };
    };
}
