function _pure_parse_git_branch --description "Parse current Git branch name"
    command env GIT_OPTIONAL_LOCKS=0 git symbolic-ref --short HEAD 2>/dev/null;
        or command env GIT_OPTIONAL_LOCKS=0 git name-rev --name-only HEAD 2>/dev/null
end
