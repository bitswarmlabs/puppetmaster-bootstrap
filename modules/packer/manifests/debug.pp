class packer::debug(
  $message = "nobody home"
) {
  notify { "#### packer::debug: ${message}": }

  if $::ec2_tag_profile {
    notify { "ec2_tag_profile: ${::ec2_tag_profile}": }
  }
  else {
    notify { "no ec2_tag_profile available": }
  }

  if $::ec2_tag_role {
    notify { "ec2_tag_role: ${::ec2_tag_role}": }
  }
  else {
    notify { "no ec2_tag_role available": }
  }

  $hello_worlds = hiera_array('hello_worlds', [])
  if $hello_worlds {
    $joined = join($hello_worlds, "\n  - ")
    notify { "## packer::debug hello_worlds:\n  - ${joined}\n\n": }
  }
}