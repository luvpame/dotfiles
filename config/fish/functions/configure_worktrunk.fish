function configure_worktrunk
    functions --erase __worktrunk_wt
    functions --copy wt __worktrunk_wt

    function wt
        if test "$HERDR_ENV" = 1 \
                && test "$argv[1]" = switch \
                && not contains -- --cd $argv \
                && not contains -- --no-cd $argv
            __worktrunk_wt switch --no-cd $argv[2..]
            return $status
        end

        __worktrunk_wt $argv
    end
end
