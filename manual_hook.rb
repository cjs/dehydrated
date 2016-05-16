#!/usr/bin/env ruby

require 'resolv'
require 'pry'
require 'awesome_print'
require 'public_suffix'

def setup_dns(domain, txt_challenge)
  dns_name = PublicSuffix.parse("#{domain}").domain
  put "prepping change for #{domain}. Create TXT record for:"
  put "\"#{txt_challenge}\""
  get "Press any key when DNS has been updated..."
  dns = Resolv::DNS.new;
  resp2 = dns.getresource(domain, Resolv::DNS::Resource::IN::TXT)
  ap resp2
  until resp2.valid
    sleep 30
    resp2 = dns.getresource(domain, Resolv::DNS::Resource::IN::TXT)
    ap resp2
  end
end

def delete_dns(domain, txt_challenge)
  put "Challenge complete. Please delete this TXT record."
  get "Press any key when DNS has been updated..."
end

if __FILE__ == $0
  hook_stage = ARGV[0]
  domain = ARGV[1]
  txt_challenge = ARGV[3]

  puts hook_stage
  puts domain
  puts txt_challenge

  if hook_stage == "deploy_challenge"
    setup_dns(domain, txt_challenge)
  elsif hook_stage == "clean_challenge"
    delete_dns(domain, txt_challenge)
  end

end
