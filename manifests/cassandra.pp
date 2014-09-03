class cassandra (
  $pname,
  $configpath = '/etc/cassandra/conf',
  $seeds,
  $commitlog_directory = '/var/lib/cassandra/commitlog',
  $cluster_name,
  $num_tokens = '256',
  $initial_token = undef,
  $partitioner = 'org.apache.cassandra.dht.Murmur3Partitioner',
  $data_file_directories = ['/var/lib/cassandra/data'],
  $disk_failure_policy = 'stop',
  $saved_caches_directory = '/var/lib/cassandra/saved_caches',
  $concurrent_reads = '32',
  $concurrent_writes = '32',
  $storage_port = '7000',
  $listen_address = $ipaddress_eth0,
  $broadcast_address = undef,
  $start_native_transport = 'true',
  $start_rpc = 'true',
  $rpc_address = '0.0.0.0',
  $rpc_port = '9160',
  $rpc_server_type = 'sync',
  $incremental_backups = 'false',
  $snapshot_before_compaction = 'false',
  $auto_snapshot = 'true',
  $multithreaded_compaction = 'false',
  $endpoint_snitch = 'RackInferringSnitch',
  $internode_compression = 'all',
  $max_heap_size = undef,
  $heap_newsize = undef,
  $jmx_port = '7199',
  $thread_stack_size = '256',
  $additional_jvm_opts = {},
  $opscenter_ip,
 ) {

  File {
    owner  => 'cassandra',
    group  => 'cassandra',
  }

  package { "${pname}":
    ensure => installed,
  } ->

  package { dsc20:
    ensure => installed,
  } ->

  package { datastax-agent:
    ensure => installed,
  } ->

  mount { $commitlog_directory:
    device  => '/dev/sdb1',
    ensure  => mounted,
    options => 'defaults',
    fstype  => 'ext4',
    atboot  => 'true',
  } ->

  mount { $data_file_directories:
    device  => '/dev/sdc1',
    ensure  => mounted,
    options => 'defaults',
    fstype  => 'ext4',
    atboot  => 'true',
  } ->

  file { '/var/lib/cassandra':
    ensure => directory,
  } ->

  file { $commitlog_directory:
    ensure => directory,
  } ->

  file { $data_file_directories:
    ensure => directory,
  } ->

  file { "${configpath}/cassandra-env.sh":
    ensure => file,
    content => template('cassandra/cassandra-env.sh.erb'),
  } ->

  file { "${configpath}/cassandra.yaml":
    ensure => file,
    content => template('cassandra/cassandra.yaml.erb'),
  } ->

  file { "/var/lib/datastax-agent/conf/address.yaml":
    ensure  => file,
    content => template('cassandra/address.yaml.erb'),
  } ->

  service { 'cassandra':
    ensure => running,
  } ->

  service { 'datastax-agent':
    ensure => running,
  }
}
