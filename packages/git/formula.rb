$:.unshift File.expand_path('../../../lib', __FILE__)
require 'debian_formula'

class Git < DebianFormula
  url 'http://kernel.org/pub/software/scm/git/git-1.7.5.4.tar.bz2'
  md5 '4985b774db84d3bbcc2b8d90952552a3'
  homepage 'http://git-scm.com'

  section 'vcs'
  name 'git'
  version '1.7.5.4~github1'
  description <<-DESC
    The Git DVCS with custom patches and bugfixes for GitHub.
  DESC

  build_depends \
    'libz-dev',
    'libcurl4-gnutls-dev | libcurl3-gnutls-dev',
    'libexpat1-dev',
    'subversion', 'libsvn-perl | libsvn-core-perl',
    'unzip',
    'gettext'

  depends \
    'perl-modules, liberror-perl',
    'libsvn-perl | libsvn-core-perl, libwww-perl, libterm-readkey-perl'

  provides  'git-core'
  replaces  'git-core'
  conflicts 'git-core'

  def patches
    [
      'patches/post-upload-pack-hook.diff',
      'patches/remove-duplicate-dot-have-lines.diff',
      'patches/git-fetch-performance.diff',
      # 'patches/patch-id-eof-fix.diff',     # in 1.7.4.2
      # 'patches/upload-pack-deadlock.diff', # in 1.7.5.1
    ]
  end

  def build
    make(vars)
  end

  def install
    make(:install, vars.merge('DESTDIR' => destdir))
  end

  private

  def vars
    {
      'prefix' => prefix,
      'gitexecdir' => '/usr/lib/git-core',
      'NO_CROSS_DIRECTORY_HARDLINKS' => 1,
      # 'NO_PERL' => 1,
      # 'NO_PYTHON' => 1,
      'NO_TCLTK' => 1
    }
  end
end

if __FILE__ == $0
  Object.__send__ :remove_const, :HOMEBREW_CACHE
  HOMEBREW_WORKDIR = Pathname.new(File.expand_path('../', __FILE__))
  HOMEBREW_CACHE = HOMEBREW_WORKDIR+'cache'
  FileUtils.mkdir_p(HOMEBREW_CACHE)

  Git.package!
end
