dep 'nmap installed.src' do

  merge :versions, {:nmap => '5.21'}
  source "http://nmap.org/dist/nmap-#{var(:versions)[:nmap]}.tar.bz2"
  setup {
    prefix var(:nmap_prefix, :default => '/usr/local')
    provides var(:nmap_prefix) / 'bin/nmap'
  }

  configure { log_shell "configure",
              default_configure_command,
              :sudo => Babushka::GemHelper.should_sudo? }
  build { log_shell "build", "make", :sudo => Babushka::GemHelper.should_sudo? }
  install { log_shell "install",
            "make install",
            :sudo => Babushka::GemHelper.should_sudo? }

  met? {
    if !File.executable?(var(:nmap_prefix) / 'bin/nmap')
      unmet "nmap isn't installed"
    else
      installed_version = shell(var(:nmap_prefix) / 'bin/nmap -V') {
        |shell| shell.stdout
      }.val_for('Nmap version').sub(' ( http://nmap.org )', '')
      if installed_version != var(:versions)[:nmap]
        unmet "an outdated version of nmap is installed (#{installed_version})"
      else
        met "nmap-#{installed_version} is installed"
      end
    end
  }
end
