def send_group_cmd(verb,cmd,gname,session)
  session.post(verb, { :cmd_typ => cmd, :hostgroup => gname, :cmd_mod => 2, :btnSubmit => "Commit" })
end

def send_host_cmd(verb,cmd,host,session)
  session.post(verb, {:cmd_typ => cmd, :host => host, :cmd_mod => 2, :btnSubmit => "Commit"})
end
