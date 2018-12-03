Gem::Specification.new do |s|
  s.name     = "discord_archiver"
  s.version  = "0.1.0"
  s.authors  = "TheAssailant"
  s.email    = "theassailant@protonmail.com"
  s.summary  = %q{Archives a specified channel in a Discord server.}
  s.homepage = "https://github.com/TheAssailant/discord-archiver"
  s.license  = "MIT"

  s.executables << "discord_archiver"
  s.require_paths = ['lib']

  s.required_ruby_version = "~> 2.3"

  s.add_dependency "discordrb", "~> 3.3.0"

  s.add_development_dependency "bundler", "~> 1.15"

  s.files      = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- test/*`.split("\n")
end
