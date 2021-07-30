# frozen_string_literal: true


control "Bastion tier security group should exist" do
  describe aws_security_group(group_id: attribute("security_group_ids")['bastion'], vpc_id: attribute("vpc_id")) do
    it { should exist }
  end
end

control "Web tier security group should exist" do
  describe aws_security_group(group_id: attribute("security_group_ids")['web'], vpc_id: attribute("vpc_id")) do
    it { should exist }
  end
end

control "App tier security group should exist" do
  describe aws_security_group(group_id: attribute("security_group_ids")['app'], vpc_id: attribute("vpc_id")) do
    it { should exist }
  end
end

control "Db tier security group should exist" do
  describe aws_security_group(group_id: attribute("security_group_ids")['db'], vpc_id: attribute("vpc_id")) do
    it { should exist }
  end
end

control "Web tier security group should allow http, https from Internet" do
  describe aws_security_group(group_id: attribute("security_group_ids")['web'], vpc_id: attribute("vpc_id")) do
    it { should allow_in(ipv4_range: ["0.0.0.0/0"], port: 80, protocol: 'tcp') }
    it { should allow_in(ipv4_range: ["0.0.0.0/0"], port: 443, protocol: 'tcp') }
  end
end

control "App tier security group should allow http, https from Web tier" do
  describe aws_security_group(group_id: attribute("security_group_ids")['app'], vpc_id: attribute("vpc_id")) do
    it { should allow_in(security_group: attribute("security_group_ids")['web'], port: 80, protocol: 'tcp') }
    it { should allow_in(security_group: attribute("security_group_ids")['web'], port: 443, protocol: 'tcp') }
  end
end

control "Db tier security group should allow postgresql from App tier" do
  describe aws_security_group(group_id: attribute("security_group_ids")['db'], vpc_id: attribute("vpc_id")) do
    it { should allow_in(security_group: attribute("security_group_ids")['app'], port: 5432, protocol: 'tcp') }
  end
end

