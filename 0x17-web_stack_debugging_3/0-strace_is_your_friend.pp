# This Puppet manifest ensures the required PHP modules for Apache are installed
# problem was due to misspelled phpp so i changed it to php `wp-settings.php`.

exec { 'fix-wordpress':
  command => 'sed -i s/phpp/php/g /var/www/html/wp-settings.php',
  path    => '/usr/local/bin/:/bin/'
}
