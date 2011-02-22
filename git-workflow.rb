dep 'topgit.src' do
  define_var :topgit_prefix,
    :default => '/usr/local/topgit',
    :message => "Where would you like topgit installed"

  provides "#{var :topgit_prefix}/bin/tg"
  source "git://repo.or.cz/topgit.git"
  configure { true }
  build { shell "make install prefix=#{var :topgit_prefix}" }
end
