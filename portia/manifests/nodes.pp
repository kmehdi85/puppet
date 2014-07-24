Exec {
  path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/','/usr/local/bin' ]
}

#node 'development'{
#node 'puppet'{
#node '223.180.81.92'{
node 'chkip'{
include portia
}
