#
# Cookbook Name:: winbase
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#node['chocolatey']['upgrade'] = false

include_recipe "chocolatey"

%w{ toolsroot sysinternals 7zip vim git cmdermini.portable }.each do |pack|
      chocolatey pack
end


# replaced with inwodws_link below
powershell_script 'make vim link' do
    action :nothing
    code <<-'EOS'
        $programfiles=${env:ProgramFiles(x86)}
        if( $programfiles -eq $nil ) {
            $programfiles=${env:ProgramFiles}
        }
        $vimbin = "$programfiles\vim\vim74\gvim.exe"
        $gvimlink = "c:\Users\Public\Desktop\GVim"
        $link = $gvimlink
        $dest = $vimbin
        if(test-path "$link") {
            $dir = $( cmd /c dir $link )
            if( $dir.ToLower() -match [regex]::escape($dest) ) {
                echo "Link already present: $link => $dest"
                return
            }
            rm $link
        }
        cmd /c mklink  "$link" "$dest"
    EOS
    guard_interpreter :powershell_script
end

windows_shortcut 'c:/Users/Public/Desktop/GVim.lnk' do
  pf = ENV['ProgramFiles(x86)'] || ENV['ProgramFiles']
  vb = '\vim\vim74\gvim.exe'
  target pf + vb
  description "GVim 7.4"
end

windows_shortcut 'c:/Users/Public/Desktop/Cmder.lnk' do
  vb = 'c:\tools\cmdermini\Cmder.exe'
  target vb
  description "Cmder"
end

ruby_block  "set-path" do
  block { ENV['PATH'] = 'c:\Program files\git\cmd;' + ENV['PATH'] }
  not_if { ENV['PATH'].include?('git\cmd')}
end

git 'Users/IEUser/Config' do
    repository 'https://github.com/byrney/Config.git'
#    destination "c:/"
    notifies :run, 'execute[install-config]', :immediately
    environment 'PATH' => ENV['PATH'] + ';c:\Program Files\Git\cmd'
end

execute "install-config" do
    u = 'IEUser'
    h = "c:\\Users\\#{u}"
    #creates "#{h}/.vimrc"
    cwd "#{h}\\Config"
    command 'bash install.sh rob.cfg'
    environment 'HOME' => "c:\\Users\\#{u}"
    action :nothing
end

# start-process -wait -verb runas -argumentlist "ruby -version 2.1.6" cinst
chocolatey 'ruby' do
    action :install
    version '2.1.6'
end

# start-process -wait -verb runas -argumentlist "rubygems -version 2.4.6" cinst
chocolatey 'rubygems' do
    action :install
    version '2.4.6'
end
chocolatey 'ruby2.devkit' do
    action :install
end

