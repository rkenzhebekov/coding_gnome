use Mix.Releases.Config,
    # This sets the default release built by `mix release`
    default_release: :default,
    # This sets the default environment used by `mix release`
    default_environment: :dev

# For a full list of config options for both releases
# and environments, visit https://hexdocs.pm/distillery/configuration.html


# You may define one or more environments in this file,
# an environment's settings will override those of a release
# when building in that environment, this combination of release
# and environment configuration is called a profile

environment :dev do
  set cookie: :"<.ldJP0%z1ejsFG:_@9S5zN0>q=|.A:stI~~q`?$gJbYIs%VA)$g*u.Va/QOPi?S"
end

environment :prod do
  set cookie: :"<.ldJP0%z1ejsFG:_@9S5zN0>q=|.A:stI~~q`?$gJbYIs%VA)$g*u.Va/QOPi?S"
end

# You may define one or more releases in this file.
# If you have not set a default release, or selected one
# when running `mix release`, the first release in the file
# will be used by default

release :fw do
  set version: current_version(:fw)
  plugin Shoehorn
  if System.get_env("NERVES_SYSTEM") do
    set dev_mode: false
    set include_src: false
    set include_erts: System.get_env("ERL_LIB_DIR")
    set include_system_libs: System.get_env("ERL_SYSTEM_LIB_DIR")
    set vm_args: "rel/vm.args"
  end
end

