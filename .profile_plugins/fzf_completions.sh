_fzf_complete_rostopic() {
  ARGS="$@"
  _fzf_complete "--sort" "$@" < <(
  { rostopic list }
  )
}

_fzf_complete_rosnode() {
  ARGS="$@"
  _fzf_complete "--sort" "$@" < <(
  { rosnode list }
  )
}

_fzf_complete_rosservice() {
  ARGS="$@"
  _fzf_complete "--sort" "$@" < <(
  { rosservice list }
  )
}

_fzf_complete_rosparam() {
  ARGS="$@"
  _fzf_complete "--sort" "$@" < <(
  { rosparam list }
  )
}

