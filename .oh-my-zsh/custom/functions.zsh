ggg() {
  if [ -z "$1" ]; then
    return 1
  fi
  ga . && gc -m "$1" && gp
}

clean-pycache() {
  local start_dir="${1:-.}"
  local found=$(find "$start_dir" -type d -name "__pycache__")

  if [[ -z "$found" ]]; then
    return 0
  fi

  find "$start_dir" -type d -name "__pycache__" -print0 | xargs -0 rm -rf
}
