  set :ssh_options, {
       user: 'deploy',
       auth_methods: %w(publickey)
   }

   server '<ip/domain>', user: 'deploy', roles: %w{app web}
