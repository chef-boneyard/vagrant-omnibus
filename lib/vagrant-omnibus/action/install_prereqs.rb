module VagrantPlugins
  module Omnibus
    module Action
      # @author Sean OMeara <someara@opscode.com>
      #
      # This action installs Chef Omnibus packages at the desired version.
      class InstallPrereqs

        def initialize(app, env)
          @app = app
          # Config#finalize! SHOULD be called automatically
          env[:global_config].omnibus.finalize!
        end

        def call(env)          
          env[:ssh_run_command] = install_prereqs_command
          @app.call(env)
        end

        private

        def install_prereqs_command
          <<-SCRIPT
function debian_install_rsync {
    dpkg -l | awk '{ print $2 }' | grep ^rsync$ 2>&1>/dev/null
    if [ $? -gt 0 ]; then
        if [ \"$(id -u)\" != \"0\" ]; then
            sudo apt-get -y install rsync
        else
            apt-get -y install rsync
        fi
    fi
}

function debian_install_sudo {
    dpkg -l | awk '{ print $2 }' | grep ^sudo$ 2>&1>/dev/null
    if [ $? -gt 0 ]; then
        if [ \"$(id -u)\" != \"0\" ]; then
            sudo apt-get -y install sudo
        else
            apt-get -y install sudo
        fi
    fi
}

function debian_install_curl {
    dpkg -l | awk '{ print $2 }' | grep ^curl$ 2>&1>/dev/null
    if [ $? -gt 0 ]; then
        if [ \"$(id -u)\" != \"0\" ]; then
            sudo apt-get -y install curl
        else
            apt-get -y install curl
        fi
    fi
}

cat /etc/issue | grep -i ^ubuntu 2>&1>/dev/null
if [ $? -eq 0 ]; then
  debian_install_rsync
  debian_install_sudo
  debian_install_curl
fi
  SCRIPT
end
      end
    end
  end
end
