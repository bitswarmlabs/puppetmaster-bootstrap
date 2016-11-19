class packer::debug(
  $message = undef
) {
  if $message {
    notify { "packer-debug": message => $message }
  }

  $hello_worlds = hiera_array('hello_worlds', [])
  if $hello_worlds {
    $joined = join($hello_worlds, "\n  - ")
    notify { "## packer::debug hello_worlds:\n  - ${joined}\n\n": }
  }
}