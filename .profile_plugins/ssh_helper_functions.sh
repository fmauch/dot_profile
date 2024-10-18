list_ssh_keys() {
  SSH_AUTH_SOCK=$1
  SSH_AGENT_PID="${1##*.}"

  ssh-add -l
}

set_ssh_agent() {
  agent_files=$(find /tmp/ssh-* -name "agent.*")
  agents=()
  agent_pids=()
  counter=0
  for agent in /tmp/ssh-*/agent.*; do
    agents+=("$agent")
    agent_pids+=("${agent##*.}")

    ((counter=counter+1))
    echo "$counter: $agent(${agent##*.})\n$(list_ssh_keys $agent)"
  done

  echo "Which ssh-agent would you like to use?"
  read num
  export SSH_AUTH_SOCK=${agents[num]}
  export SSH_AGENT_PID=${agent_pids[num]}
}
