if [ `whoami` = "root" ]; then
	export PS1="${RED}\u${NORMAL}@${CYAN}\h${WHITE}\$(vcs_branch)${WHITE} \w${GREEN}${NORMAL}\\$ ${RESET}"
else
	export PS1="${GREEN}\u${NORMAL}@${CYAN}\h${WHITE}\$(vcs_branch)${WHITE} \w${GREEN}${NORMAL}\\$ ${RESET}"
fi
